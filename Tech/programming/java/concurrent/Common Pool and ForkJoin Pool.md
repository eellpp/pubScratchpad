
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

# 1) What is the global `ForkJoinPool.commonPool()`

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

# 2) If I start a vanilla Spring Boot app, what threads/pools exist “by default”?

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

# 3) How “default threads” appear in practice

- **Nothing uses the common pool until you (or a lib) do** an operation that targets it (e.g., `CompletableFuture.supplyAsync()` with no executor, `parallelStream()`).
    
- Web server pools are created by the embedded container when the app starts.
    
- Async/scheduler pools are created only when you enable those features.
    

---

# 4) Good and bad patterns (with examples)

## Bad: accidental use of the common pool

```java
// This will run on ForkJoinPool.commonPool():
CompletableFuture<String> f = CompletableFuture.supplyAsync(this::callSlowApi);
```

If your app is also using `parallelStream()` elsewhere, both will **share** the same pool → contention.

## Better: provide an explicit (bounded) pool

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

## Spring Boot best practice for `@Async`

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

# 5) How Java “provides defaults”

- **Common pool**: part of `java.util.concurrent`—a singleton, lazily initialized. You **opt in** by calling APIs that use it by default.
    
- **No automatic “app pool”**: aside from the common pool and container/framework pools you explicitly (or implicitly) enable, **Java does not create a general-purpose executor for you**.
    

---

# 6) Quick answers to common questions

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

## Bottom line

- The **global common FJP** exists and is convenient—but it’s a **shared, limited resource**. Don’t rely on it for blocking or high-volume work.
    
- In a **vanilla Spring Boot app**, you’ll have **server request threads** and whatever you explicitly enable (async/scheduler/reactor). The common pool is **separate** and only used if you call APIs that default to it.
    
- For production, **define your own bounded executors** (or use **virtual threads**) and **wire everything explicitly**(`CompletableFuture` with an executor, `@Async("…")`, scheduler beans). This gives you isolation, backpressure, and predictable behavior.


### Analogy

*   **Singleton Pattern:** The rule that a country can have only one "Head of State".
*   **Common Pool:** The specific, physical person who is the "President".
*   **The Connection:** The rule (Singleton) ensures there is only one President (the single instance), and that President manages the executive branch (the pool of resources).

**Conclusion:** Don't say "a common pool is a singleton." Instead, it's more accurate to say: **"The JDK's common Fork/Join pool is a critical shared resource that is implemented as a singleton."**
