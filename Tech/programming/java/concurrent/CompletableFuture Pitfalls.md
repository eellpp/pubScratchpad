Here are the **common CompletableFuture pitfalls**, each with a **concrete failure scenario**, why it’s bad design, a **better alternative (often a plain/bounded thread pool or virtual threads)**, and **where frameworks make smarter choices**.

---

# 1) “Default pool surprise” (uses the common ForkJoinPool)

**What happens**
`CompletableFuture.supplyAsync(...)` without an executor uses the global **ForkJoinPool.commonPool** (FJP). You have **no isolation**: CPU-bound tasks, blocking I/O, and even 3rd-party libraries may all fight over the same small pool.

**Scenario**
You add a feature that calls 3 slow REST APIs via `supplyAsync()`. Under load, those stages block sockets on the common pool. Meanwhile, another part of your app uses `parallelStream()` (also common FJP) for CPU work. Now the common pool is **starved** by your I/O, CPU tasks crawl, latencies spike, and throughput collapses.

**Why it’s bad**

* No isolation between subsystems.
* Starvation risk when blocking I/O lives on FJP (designed for short, CPU tasks).
* Hard to debug who is clogging the pool.

**Prefer**

* Provide an **explicit, sized executor** per workload:

  ```java
  Executor ioPool = new ThreadPoolExecutor(
      64, 64, 0, TimeUnit.MILLISECONDS,
      new LinkedBlockingQueue<>(200), new NamedThreadFactory("io-"));
  CompletableFuture.supplyAsync(() -> httpCall(), ioPool);
  ```
* For blocking I/O + simple flow: **virtual threads** (`Executors.newVirtualThreadPerTaskExecutor()`).

**Frameworks that do better**

* **Reactor**: separates Schedulers (`parallel()`, `boundedElastic()` for blocking I/O).
* **Vert.x/Netty**: event loop + dedicated worker pools for blocking calls.
* **Resilience4j Bulkhead (thread-pool bulkhead)**: isolates pools per dependency.

---

# 2) No built-in backpressure / unbounded submission

**What happens**
`CompletableFuture` doesn’t manage a queue for you. If you loop over 100k items and fire `supplyAsync` on a cached pool or common pool, you’ll **flood the executor**, explode memory, and create a huge tail of work.

**Scenario**
Batch job reads 1M IDs and does `ids.stream().map(id -> CF.supplyAsync(() -> fetch(id), ioPool))...`. If `ioPool` is unbounded or uses a large queue, you allocate 1M futures + requests, causing **GC pressure**, **timeouts**, and **queue latency** spikes.

**Why it’s bad**

* No natural backpressure; you can overwhelm downstream.
* Latency and memory blow-ups.

**Prefer**

* Use a **bounded** `ThreadPoolExecutor` with a **small queue** + **rejection policy** (e.g., `CallerRunsPolicy`) and **semaphores** to cap parallelism:

  ```java
  var sem = new Semaphore(200);
  for (var id: ids) {
    sem.acquireUninterruptibly();
    CompletableFuture
      .supplyAsync(() -> fetch(id), ioPool)
      .whenComplete((r, e) -> sem.release());
  }
  ```
* Or **`ExecutorService.invokeAll`** in **chunks**.
* Or **structured concurrency** (Java 21) with a fixed concurrency gate.
* Reactor: use `flatMap(..., concurrency=N)` to cap in-flight work.

**Frameworks that do better**

* **Reactor** & **Akka**: explicit concurrency limits and backpressure semantics.
* **Resilience4j RateLimiter/Bulkhead**: bounds inflight calls per dependency.

---

# 3) Blocking inside `then*` callbacks

**What happens**
Calling `.join()`, JDBC, or HTTP **inside `thenApply/thenCompose`** on a small pool blocks worker threads that are supposed to run **non-blocking** continuations. Under load, everything stalls.

**Scenario**

```java
CompletableFuture.supplyAsync(this::fetchUser, commonPool)
  .thenApply(user -> jdbcLookup(user.getId()))  // blocks on same small pool
  .thenApply(this::compute);
```

When many requests arrive, `jdbcLookup` blocks FJP threads; no threads left to run other callbacks → **deadlock-like stalls**.

**Prefer**

* Route blocking stages to an **I/O executor** or use **virtual threads**, or keep the code synchronous on virtual threads:

  ```java
  thenApplyAsync(u -> jdbcLookup(u.getId()), ioPool)
  ```
* Or switch to **structured concurrency** with blocking code on virtual threads.

**Frameworks that do better**

* Reactor: `publishOn(boundedElastic())` for blocking steps.
* Vert.x: `executeBlocking` on worker pool.

---

# 4) Deadlocks from dependency cycles

**What happens**
Futures that **wait on each other** on a **tiny pool** can deadlock.

**Scenario**
Two CF pipelines each `.join()` the other’s result inside callbacks running on the **same (size=1) executor**. The only thread is waiting for work that can’t run → **deadlock**.

**Prefer**

* Avoid cross-joining inside callbacks; split pipelines; use **`thenCombine`** or **`allOf`**.
* Ensure **sufficient threads** or use **virtual threads** and synchronous code.

---

# 5) Lost context (ThreadLocal/MDC, Security, Transactions)

**What happens**
CF hops threads; **ThreadLocal** data (logging MDC, tenant, security) is lost unless you manually propagate it.

**Scenario**
You set MDC `requestId` in the servlet thread. Continuations run on another thread → logs miss `requestId`, tracing is broken.

**Prefer**

* Wrap tasks to capture/restore context (MDC copy).
* Use frameworks that integrate context propagation (e.g., Spring’s `TaskDecorator`, Micrometer context-propagation, Reactor’s `Context`).

**Frameworks that do better**

* Reactor’s `Context` & `Hooks.enableAutomaticContextPropagation()` (with Micrometer).
* Spring `TaskDecorator` and Spring Observability.

---

# 6) Exception handling gaps & swallowed errors

**What happens**
If you forget terminal `.join/get` or don’t chain `.exceptionally/handle`, errors can be **lost** until GC logs a “**unobserved exception**”-like warning (if at all).

**Scenario**
You start CFs and return before joining. The HTTP call fails; nobody is listening → no metric, no alert, **silent failure**.

**Prefer**

* Always **observe** and **propagate** exceptions (`.handle`, `.whenComplete`, terminal join in request scope).
* Centralize error handling utilities & metrics.

**Frameworks that do better**

* Reactor has **onError** operators and mandatory subscription sites.
* Structured Concurrency: `scope.throwIfFailed()` forces you to deal with failures.

---

# 7) Cancellation doesn’t propagate intuitively

**What happens**
`future.cancel(true)` may not cancel upstream/downstream unless you wire it. Downstream stages may still run.

**Scenario**
Client disconnects; you cancel the top CF. The in-flight HTTP call keeps running, consuming sockets/CPU.

**Prefer**

* Tie cancellation to **interrupts** in tasks; check `Thread.interrupted()`.
* Use frameworks that coordinate cancellation (Structured Concurrency cancels siblings; Reactor disposes chains).

---

# 8) Oversubscription & poor sizing

**What happens**
Mixing CF with default executors leads to **too many runnable tasks** vs cores; context switching spikes; throughput falls.

**Scenario**
CPU-heavy `thenApply` graph on cached executor with 1000 threads — looks “fast” in dev, but in prod it thrashes the CPU.

**Prefer**

* For CPU: fixed pool ≈ `Runtime.getRuntime().availableProcessors()` (FJP for fine-grained tasks).
* For I/O: larger pool or virtual threads; keep CPU work separate.

---

# 9) Async vs Async* confusion (`thenApply` vs `thenApplyAsync`)

**What happens**

* `thenApply` runs in the **same** thread that completes the previous stage (possibly an event-loop thread or tiny pool).
* `thenApplyAsync` uses an executor. Misusing them can block critical threads.

**Scenario**
You complete a CF on a Netty event loop and attach `thenApply` that does blocking work. You just blocked the event loop → timeouts.

**Prefer**

* Use `*Async(..., executor)` for anything that may block or is heavy.
* Keep event-loop threads pristine.

**Frameworks that do better**

* Netty/Vert.x enforce non-blocking work on event loop; blocking must go to worker pool.
* Reactor: `subscribeOn`/`publishOn` to move work.

---

# 10) Memory retention & graph leaks

**What happens**
Large CF graphs retain intermediate results and lambdas until completion; accidental references create **leaks**.

**Scenario**
Per-request you build a wide `allOf` over thousands of CFs and stash references in a cache/map for “later”. Under load, heap balloons.

**Prefer**

* Keep graphs **shallow** and scoped.
* Release references after use.
* For bulk data, prefer **chunked `invokeAll`** or **structured scopes**.

---

# 11) Debuggability & tracing

**What happens**
Stack traces are split across threads; root-cause is hard to follow.

**Scenario**
Production outage: you see `CompletionException` with little context.

**Prefer**

* Wrap stages with names/metrics; attach correlation IDs; log on boundaries.
* Use frameworks with better **operator naming** (Reactor has `checkpoint()`/`Hooks.onOperatorDebug()`).

---

# 12) Mixing CF with locks/transactions

**What happens**
Async callbacks try to use a **JPA transaction**/**synchronized** section created on another thread; fails or blocks unpredictably.

**Prefer**

* Keep transactional work **synchronous** on a single thread (virtual threads are great here).
* If you must hop threads, re-create the transactional context explicitly.

---

# When a plain Thread Pool (or Virtual Threads) is better

* **Bounded, bulk parallelism** with clear **backpressure** and **simple control** → `ExecutorService.invokeAll` in chunks on a **bounded** pool.
* **Blocking I/O** and you want simple code → **virtual threads** (Java 21).
* **Strong isolation** per dependency → **one bounded pool per dependency** (a bulkhead).
* **Periodic/scheduled jobs** → `ScheduledThreadPoolExecutor`.
* **Request-scoped parallel fetches** → **Structured Concurrency** (`StructuredTaskScope`) for clear lifetimes, cancellation, and fail-fast.

---

## Mini “bad vs good” snippets

### Bad: default pool + blocking in callback

```java
CompletableFuture.supplyAsync(() -> httpCall())     // common FJP
    .thenApply(resp -> jdbcQuery(resp.id()))        // blocks FJP
    .thenApply(this::compute)                       // starves pool under load
    .join();
```

### Better: explicit pools (or virtual threads)

```java
Executor ioPool = Executors.newFixedThreadPool(64);
Executor cpuPool = Executors.newWorkStealingPool(); // or fixed as needed

CompletableFuture.supplyAsync(this::httpCall, ioPool)
    .thenApplyAsync(resp -> jdbcQuery(resp.id()), ioPool)
    .thenApplyAsync(this::compute, cpuPool)
    .orTimeout(500, TimeUnit.MILLISECONDS)
    .exceptionally(this::fallback)
    .join();
```

### Best (often): virtual threads + structured concurrency (simple, readable)

```java
try (var scope = new StructuredTaskScope.ShutdownOnFailure()) {
    var f1 = scope.fork(() -> httpCall());          // virtual thread
    var f2 = scope.fork(() -> jdbcQuery(f1.resultNow().id()));
    scope.join();
    scope.throwIfFailed();
    return compute(f2.resultNow());
}
```

---

## Where frameworks make smart choices (use as references)

* **Project Reactor**:

  * Separates **event loop** from **blocking** via `Schedulers.parallel()` vs `boundedElastic()`.
  * Built-in **backpressure**, operator-level **timeouts**, **retries**, and **context** propagation.
* **Spring WebFlux + Reactor**:

  * Uses **Netty event loop** for non-blocking I/O; offloads blocking to bounded elastic.
  * **TaskExecutor** customization and **Resilience4j** integration for bulkheads/ratelimits.
* **Resilience4j**:

  * **ThreadPoolBulkhead** to isolate dependencies with **bounded queues** and **rejections**; **RateLimiter** and **CircuitBreaker**.
* **Vert.x / Netty**:

  * Strict separation of **event loops** and **worker pools**; fail fast when you block the loop.
* **Akka** (JVM, Scala):

  * **Dispatchers** and **mailboxes** per actor/system to isolate workloads.
* **Java 21 Structured Concurrency + Virtual Threads**:

  * Provides **clear lifetimes**, **cancellation propagation**, and easy reasoning with synchronous code.

---

## Quick chooser

* Need **simple, controlled concurrency** with backpressure → **ExecutorService** (bounded) or **ThreadPoolBulkhead**.
* Need **high-level async composition** (joins, timeouts) and truly non-blocking I/O → **Reactor/WebFlux** or **CF with explicit executors**.
* Need **lots of blocking I/O** but want readability → **Virtual threads** + **Structured Concurrency**.

If you share your concrete workload (CPU vs I/O mix, throughput/latency targets, dependencies), I’ll sketch pool sizes and a template (Executor-only, CF DAG with bulkheads, or virtual-threads + scopes) tailored to it.
