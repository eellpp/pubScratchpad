
CommonPool is a pre-created, system-wide thread pool optimized for parallel recursive tasks (like those using `parallelStream()`).

**The JDK's common Fork/Join pool is a critical shared resource that is implemented as a singleton**


### What is the Common Pool?

The **Common Pool** specifically refers to the **common fork/join pool** in Java, introduced with the Fork/Join Framework in Java 7. It's a `ForkJoinPool` that is used behind the scenes for parallel operations.

*   **Goal:** Efficiently execute a large number of small, computational tasks by leveraging work-stealing algorithms.
*   **How you use it:** You often don't instantiate it directly. It's used implicitly.
    ```java
    List<Integer> numbers = List.of(1, 2, 3, 4, 5);
    // This parallel stream operation automatically uses the common pool
    List<Integer> doubled = numbers.parallelStream()
                                   .map(n -> n * 2)
                                   .collect(Collectors.toList());
    ```
*   **How you access it explicitly:**
    ```java
    ForkJoinPool commonPool = ForkJoinPool.commonPool();
    ```

---

### The Connection: How are they related?

This is where the confusion comes from. **The Common Pool is often *implemented* as a Singleton.**

When you call `ForkJoinPool.commonPool()`, you are not creating a new pool. You are getting a reference to a single, statically created instance that is shared across the entire JVM.

From the Java documentation for `ForkJoinPool.commonPool()`:
> "Returns the common pool instance. **This pool is statically constructed**..."

So, while the *concept* of a "common pool" (a shared resource for parallel tasks) is different from the *design pattern* "Singleton" (a pattern for ensuring a single instance), the specific implementation of the common pool in the JDK **uses the Singleton pattern** to manage its instance.

### Summary Table

| Feature | Singleton (Pattern) | Common Pool (A Specific Resource) |
| :--- | :--- | :--- |
| **Nature** | A **Design Pattern** (a blueprint). | A **Pre-configured Resource** (a thread pool). |
| **Primary Goal** | Ensure only one instance of a class exists. | Provide a efficient, shared pool for parallel tasks. |
| **Usage** | Used for any class that needs a single instance (Logger, Config, etc.). | Used implicitly by `parallelStream()` and explicitly via `ForkJoinPool`. |
| **Relationship** | The Common Pool **is implemented using** the Singleton pattern. | A Singleton **could be used to manage** a pool, among other things. |



Here’s the mental model you want:

### 1) What is the global `ForkJoinPool.commonPool()`

- A **single, JVM-wide** work-stealing pool that the JDK provides.
- It’s **shared by all code in the same JVM** unless you pass your own executor.
- **Used by default** by things like:
    
    - `CompletableFuture.supplyAsync(...)` / `runAsync(...)`
        
    - `Stream.parallel()` / `parallelStream()`
        
    - Some JDK internals (e.g., `Spliterator` tasks), and 3rd-party libs when they choose to
        
- **Thread type**: daemon `ForkJoinWorkerThread`s.
    
- **Size (parallelism)**: by default ≈ `Runtime.getRuntime().availableProcessors() - 1` (minimum 1).  
    You can override with the system property:
    
    ```
    -Djava.util.concurrent.ForkJoinPool.common.parallelism=<N>
    ```
    
- Other tunables exist (`…common.threadFactory`, `…common.exceptionHandler`, `…common.maximumSpares`) but you **cannot replace** the common pool instance—only tune it or just avoid it by supplying your own `Executor`.
    

👉 Implication: if you “fire and forget” CFs / parallel streams **without an executor**, you’re putting load on a **shared resource** you don’t control.

---

### 2) If I start a vanilla Spring Boot app, what threads/pools exist “by default”?

There isn’t _one_ global “Spring pool.” You’ll usually have several **independent** thread sources:

1. **JVM basics**
    
    - The `main` thread (your app starts here).
        
    - GC threads, reference-handler, signal, etc. (managed by the JVM).
        
    - **`ForkJoinPool.commonPool()`** (created lazily when first used).
        
2. **Web server worker threads** _(only if you run a web app)_
    
    - **Tomcat** (default starter): a request worker pool (max ~200 by default).  
        Each HTTP request is handled by a worker thread.
        
    - **Jetty/Undertow**: similar concept; their own pools with their own defaults.
        
    - These **are not** the common FJP; they’re container-specific executors.
        
3. **Async & scheduling (only if you opt in)**
    
    - `@EnableAsync` (or `@Async` usage) **without a bean**: Spring uses `SimpleAsyncTaskExecutor`, which is **not a real pool** (it can create a new thread per task). This surprises people and can cause unbounded thread creation.  
        ➜ Best practice: define a bounded `ThreadPoolTaskExecutor` bean and let Spring use that.
        
    - `@EnableScheduling` / `@Scheduled` **without a bean**: Spring wires a basic scheduler; best practice is to provide a `ThreadPoolTaskScheduler` with a pool size that fits your jobs.
        
4. **Reactive stack (if you use WebFlux/WebClient)**
    
    - Reactor Netty runs **event-loop threads** (not the FJP) plus a **bounded elastic** worker pool for blocking tasks (if you route work there). Again: separate from the common pool.
        

---

### 3) How “default threads” appear in practice

- **Nothing uses the common pool until you (or a lib) do** an operation that targets it (e.g., `CompletableFuture.supplyAsync()` with no executor, `parallelStream()`).
    
- Web server pools are created by the embedded container when the app starts.
    
- Async/scheduler pools are created only when you enable those features.
    

---

### 4) Good and bad patterns (with examples)

#### Bad: accidental use of the common pool

```java
// This will run on ForkJoinPool.commonPool():
CompletableFuture<String> f = CompletableFuture.supplyAsync(this::callSlowApi);
```

If your app is also using `parallelStream()` elsewhere, both will **share** the same pool → contention.

#### Better: provide an explicit (bounded) pool

```java
Executor ioPool = new ThreadPoolExecutor(
    64, 64, 0L, TimeUnit.MILLISECONDS,
    new LinkedBlockingQueue<>(200), r -> {
        Thread t = new Thread(r, "io-");
        t.setDaemon(true);
        return t;
    });

CompletableFuture<String> f = CompletableFuture.supplyAsync(this::callSlowApi, ioPool);
```

Now your I/O work is **isolated** from CPU work and from other subsystems.

#### Spring Boot best practice for `@Async`

```java
@Configuration
@EnableAsync
public class AsyncConfig {
  @Bean(name = "appExecutor")
  public ThreadPoolTaskExecutor appExecutor() {
    var ex = new ThreadPoolTaskExecutor();
    ex.setCorePoolSize(16);
    ex.setMaxPoolSize(32);
    ex.setQueueCapacity(500);
    ex.setThreadNamePrefix("async-");
    ex.initialize();
    return ex;
  }
}
```

Then:

```java
@Async("appExecutor")
public CompletableFuture<Foo> work(...) { ... }
```

This avoids Spring’s default `SimpleAsyncTaskExecutor` surprise.

---

### 5) How Java “provides defaults”

- **Common pool**: part of `java.util.concurrent`—a singleton, lazily initialized. You **opt in** by calling APIs that use it by default.
    
- **No automatic “app pool”**: aside from the common pool and container/framework pools you explicitly (or implicitly) enable, **Java does not create a general-purpose executor for you**.
    

---

### 6) Quick answers to common questions

- **What is the size of the common pool?**  
    Roughly `CPUs - 1` (min 1). Override with `-Djava.util.concurrent.ForkJoinPool.common.parallelism=N`.
    
- **Can I replace the common pool?**  
    No. You can tune it via system properties, but the instance is fixed. If you need isolation, **pass your own executor**.
    
- **Do Spring’s web request threads come from the common pool?**  
    No. They come from the embedded server (Tomcat/Jetty/Undertow) and are independent.
    
- **Why do I see stalls when using `supplyAsync` + `parallelStream`?**  
    Both default to the **same** common pool; if you block in tasks, you can starve it. Fix by **separating executors** or avoiding blocking on FJP.
    
- **What about virtual threads (Java 21)?**  
    They are **not enabled by default**. If you choose to, you can run blocking tasks on:
    
    ```java
    try (var vexec = Executors.newVirtualThreadPerTaskExecutor()) {
        Future<?> f = vexec.submit(this::callSlowApi);
    }
    ```
    
    This avoids the complexity of CF + FJP for I/O-heavy code while keeping straightforward, synchronous style.
    

---

#### Bottom line

- The **global common FJP** exists and is convenient—but it’s a **shared, limited resource**. Don’t rely on it for blocking or high-volume work.
    
- In a **vanilla Spring Boot app**, you’ll have **server request threads** and whatever you explicitly enable (async/scheduler/reactor). The common pool is **separate** and only used if you call APIs that default to it.
    
- For production, **define your own bounded executors** (or use **virtual threads**) and **wire everything explicitly**(`CompletableFuture` with an executor, `@Async("…")`, scheduler beans). This gives you isolation, backpressure, and predictable behavior.


Short answer: the **common ForkJoinPool (FJP)** is tuned for **many small, CPU-bound tasks**; it’s a bad fit for **slow or blocking I/O** like HTTP calls and JDBC, unless you take special measures.

### Why FJP shines for CPU-intensive work

* **Parallelism ≈ #CPU cores.** Default size is `availableProcessors() - 1` (min 1). That’s ideal when each worker is *always doing CPU work*.
* **Work-stealing scheduler.** Tasks are expected to be **small, non-blocking**, and to fork into subtasks (`fork/join`). Idle workers steal from others, keeping cores busy.
* **Low context-switch pressure.** With threads ≈ cores and short tasks, you minimize blocking and kernel scheduling overhead.
* **Deterministic throughput.** No tail latencies from external systems; the pool keeps cores saturated.

Typical good uses:

* Parallel loops / divide-and-conquer (sorts, scans, image processing).
* `Stream.parallel()` over pure functions.
* `ForkJoinTask` trees where subtasks never block on I/O.

### Why it’s bad for slow APIs/DB calls

1. **Blocking starves the pool**

   * Pool size ~ cores (say 8). If 8 tasks **block on I/O** (HTTP, JDBC), there are **no threads left** to run other tasks or continuations. Latency spikes and you may see apparent “deadlocks” (nothing progresses until an I/O returns).

2. **Unpredictable latency breaks work-stealing assumptions**

   * Work stealing assumes tasks finish quickly so thieves find new work. If tasks randomly take 5–500 ms waiting on networks/disks, stealing doesn’t help—everyone just waits.

3. **Shared JVM-wide resource**

   * `CompletableFuture.supplyAsync(...)`, `parallelStream()`, and some libs all use the **same** common pool unless you pass an executor. Your blocking I/O can stall unrelated CPU work (and vice-versa). No isolation, no backpressure.

4. **No built-in backpressure**

   * If you kick off thousands of I/O CFs onto the FJP, you can create huge in-flight queues and memory pressure. The common pool won’t throttle you.

5. **Managed blocking isn’t automatic**

   * FJP *can* compensate via `ForkJoinPool.ManagedBlocker` (temporarily increasing threads), but **you must call it explicitly** around the blocking call. `CompletableFuture` and most code don’t.

### Concrete mini-scenarios

#### A) Parallel HTTP on common FJP (bad)

```java
List<URI> uris = ...; // 500 endpoints
// Each supplyAsync uses common FJP by default
var futures = uris.stream()
  .map(u -> CompletableFuture.supplyAsync(() -> httpGet(u)))
  .toList();
var bodies = futures.stream().map(CompletableFuture::join).toList();
```

On an 8-core box, only ~7 FJP threads exist. If 7 calls are slow (e.g., 300 ms), the pool is **fully blocked**. Everything else using FJP stalls.

#### B) JDBC in `thenApply` on FJP (worse)

```java
CompletableFuture.supplyAsync(() -> fetchUserId())         // FJP
  .thenApply(id -> jdbcQuery(id))                          // blocks FJP worker
  .thenApply(this::compute)
  .join();
```

Under load, enough requests will block all FJP workers on JDBC. Continuations and other requests stop progressing.

### Better patterns for I/O

* **Use a dedicated, bounded I/O executor** (more threads than cores; separate from FJP):

  ```java
  Executor io = new ThreadPoolExecutor(64, 64, 0, MILLISECONDS,
                                       new LinkedBlockingQueue<>(200));
  CompletableFuture.supplyAsync(() -> httpGet(u), io);
  ```

  * Gives **isolation** (bulkhead) and **backpressure** (bounded queue + rejection policy).
* **Virtual threads (Java 21+)** for blocking I/O with simple code:

  ```java
  try (var vexec = Executors.newVirtualThreadPerTaskExecutor()) {
      var futures = uris.stream().map(u -> vexec.submit(() -> httpGet(u))).toList();
      for (var f : futures) f.get();
  }
  ```

  Virtual threads park cheaply when waiting; you can scale blocking I/O without pool starvation.
* **Reactive runtimes** (Netty/Reactor, Vert.x): keep event loop non-blocking; offload any blocking step to a **bounded elastic/worker pool**.
* **If you must use FJP** around blocking, wrap with **ManagedBlocker** (advanced, rarely necessary if you can choose the above):

  ```java
  ForkJoinPool.managedBlock(new ForkJoinPool.ManagedBlocker() {
    volatile boolean done;
    String result;
    public boolean block() { result = httpGet(u); done = true; return true; }
    public boolean isReleasable() { return done; }
  });
  ```

### Rule of thumb

* **CPU-bound, tiny tasks** → FJP/common pool is great.
* **Potentially slow/blocking I/O** → **don’t** use common FJP. Use:

  * a **separate bounded I/O pool**, or
  * **virtual threads**, or
  * a **reactive stack** with proper offloading.

### Quick chooser

* Need `parallelStream()` for pure compute? → OK on common FJP.
* Doing HTTP/JDBC/file I/O with unknown latency? → **Avoid** common FJP; choose a dedicated executor or virtual threads.
* Mixing compute + I/O? → Split executors (CPU pool vs I/O pool), or use virtual threads and keep code synchronous.

This design keeps CPUs busy for compute, prevents I/O from starving the system, and gives you isolation and backpressure where you need it.
