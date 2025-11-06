# Core Java 
## 1 Exception Handling 

### Explain  checked and unchecked exception with example

***Checked exceptions (extends Exception, not RuntimeException)** 
- The compiler forces you to handle or declare them.  
- Use when the caller can recover (retry, fallback, show message).  
- Examples: IOException, SQLException, ParseException.  

**Unchecked exceptions (extends RuntimeException)**
Use for programming errors or conditions you don’t expect callers to recover from at that site. Not enforced by the compiler.  
Examples: NullPointerException, IllegalArgumentException, ArithmeticException.  


### When would you choose to use a checked exception vs. an unchecked exception in your own code?** 

Expected Answer: This is a design philosophy question.   
- Use a Checked Exception when the caller is expected to recover from the exceptional situation. For example, if a file is not found, the caller can prompt the user for a new path. It's for anticipated, recoverable problems.
- Use an Unchecked Exception when the exception is the result of a programming error or a situation from which the caller cannot reasonably be expected to recover. For example, a null reference where an object is required, or an invalid argument passed to a method. It indicates a bug.

Use checked exceptions sparingly—only when typical callers can and should handle them (I/O, user input, business rule violations where a different action is likely).

### In Spring Jdbc are SqlException and DataAccessException checked or unchecked exception ?
https://github.com/eellpp/pubScratchpad/blob/main/Tech/programming/java/interview/solutions/jdbc_exception.md

### What is your exception handling strategy
https://github.com/eellpp/pubScratchpad/blob/main/Tech/programming/java/interview/solutions/exception_handling_strategy.md


## 2. What is a Singleton Pattern
The Singleton Pattern is a creational design pattern that ensures a class has only one instance and provides a global point of access to that instance  

The Singleton Pattern is commonly used to manage resources that are shared among multiple components of an application.

### Are Singleton Beans Thread-Safe?
No, singleton beans are not thread-safe

When multiple threads access and modify the same instance of a singleton bean concurrently, you need to take proper synchronization measures to ensure thread safety. 

 If a singleton bean's methods access shared resources or modify shared state, you should consider using synchronized blocks or other synchronization mechanisms to ensure that only one thread can access the critical section at a time.

 Utilize Java's concurrent libraries such as java.util.concurrent classes for managing concurrent access to shared resources. For example, using ConcurrentHashMap instead of a regular HashMap if your bean needs to store and manipulate data concurrently.

### how would you implement a thread safe singleton in java 
https://github.com/eellpp/pubScratchpad/blob/main/Tech/programming/java/interview/solutions/singleton_implementation.md

# Spring Boot

### 1. What is  for Spring IOC (inversion of control) 
Inversion of Control in the context of Spring means that the framework controls the creation, configuration, and management of application objects and their interactions. This helps in building more modular, maintainable, and testable applications by reducing tight coupling and promoting separation of concerns.

In Spring, you define your application's components (beans) using configuration metadata, which can be XML-based or annotation-based. These configurations tell the Spring container what beans to create and how they are related to each other.

Dependency injection, an aspect of Inversion of Control (IoC), is a general concept stating that we do not create our objects manually but instead describe how they should be created. Then an IoC container will instantiate required classes if needed

### What does @Component annotation do in spring
@Component is an annotation that allows Spring to detect our custom beans automatically.

Spring will : 
- Scan our application for classes annotated with @Component
- Instantiate them and inject any specified dependencies into them
- Inject them wherever needed

### If i declare a Map variable as final, can i put values into it later
yes. Because final marks the reference not the object. You can't make the reference point to another hash table. However you can add new values to it.  
int is a primitive type, not reference. Means with final you can't change the value of variable. 



### What is the use of @Configuration Annotation in spring
In Spring Framework, the @Configuration annotation is used to indicate that a class defines one or more beans that should be managed by the Spring IoC container. When a class is annotated with @Configuration, it effectively becomes a configuration class, and Spring treats it as a source of bean definitions. 

#### Without @Configuration (Traditional Java Approach)

```java
// Manual bean management - no Spring container help
public class ManualAppConfig {
    
    public DataSource dataSource() {
        DriverManagerDataSource ds = new DriverManagerDataSource();
        ds.setUrl("jdbc:h2:mem:testdb");
        ds.setUsername("sa");
        ds.setPassword("");
        return ds;
    }
    
    public JdbcTemplate jdbcTemplate() {
        // PROBLEM: Creates NEW instance every time - no singleton!
        return new JdbcTemplate(dataSource());
    }
    
    public UserService userService() {
        // PROBLEM: Each call creates new dependencies
        return new UserService(jdbcTemplate());
    }
    
    // Manual array configuration
    public String[] supportedCountries() {
        return new String[]{"US", "UK", "CA", "AU"};
    }
    
    public List<String> adminEmails() {
        return Arrays.asList("admin@company.com", "support@company.com");
    }
}

// Usage without Spring
public class ManualApp {
    public static void main(String[] args) {
        ManualAppConfig config = new ManualAppConfig();
        
        UserService service1 = config.userService();
        UserService service2 = config.userService();
        
        // service1 and service2 have DIFFERENT JdbcTemplate instances!
        System.out.println(service1 == service2); // false - not singleton
    }
}
```

#### With @Configuration (Spring Managed)

```java
@Configuration
public class SpringAppConfig {
    
    // String configuration
    @Value("${app.database.url:jdbc:h2:mem:defaultdb}")
    private String databaseUrl;
    
    // Bean - Spring manages as singleton
    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource ds = new DriverManagerDataSource();
        ds.setUrl(databaseUrl);
        ds.setUsername("sa");
        ds.setPassword("");
        return ds;
    }
    
    // Bean with dependency injection
    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        // Spring injects the SAME dataSource instance
        return new JdbcTemplate(dataSource);
    }
    
    @Bean
    public UserService userService(JdbcTemplate jdbcTemplate) {
        // Spring injects the SAME jdbcTemplate instance
        return new UserService(jdbcTemplate);
    }
    
    // Array configuration as bean
    @Bean
    public String[] supportedCountries() {
        return new String[]{"US", "UK", "CA", "AU"};
    }
    
    @Bean
    public List<String> adminEmails() {
        return Arrays.asList("admin@company.com", "support@company.com");
    }
    
    // Bean with array dependency
    @Bean
    public NotificationService notificationService(String[] supportedCountries) {
        // Spring injects the countries array
        return new NotificationService(supportedCountries);
    }
}

// Usage with Spring
public class SpringApp {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(SpringAppConfig.class);
        
        UserService service1 = context.getBean(UserService.class);
        UserService service2 = context.getBean(UserService.class);
        
        // service1 and service2 are THE SAME instance (singleton)
        System.out.println(service1 == service2); // true - singleton!
        
        // Access configured arrays
        String[] countries = context.getBean("supportedCountries", String[].class);
        System.out.println(Arrays.toString(countries));
    }
}
```

#### Key Benefits of @Configuration:

1. **Singleton Management**: Beans are singletons by default
2. **Dependency Injection**: Spring automatically injects dependencies
3. **Lifecycle Management**: Spring handles bean creation, initialization, destruction
4. **Consistent Instances**: All beans get the same dependency instances
5. **Configuration Reuse**: Beans can be easily shared across the application

**Without @Configuration**: You manually manage object lifecycle and dependencies
**With @Configuration**: Spring handles everything automatically with proper dependency injection and singleton management

### What Is the Default Bean Scope in Spring Framework?
By default, a Spring Bean is initialized as a singleton.  




---

### While one thread is iterating over the hashmap , another thread is is also iterating (no modification). What is the behaviour in this case
Yes — both threads can iterate the same HashMap concurrently safely, as long as no thread modifies the map (no put, remove, etc.) during or between the iterations.

### While one thread is iterating over the hashmap , another thread is modifying it. What is the behaviour in this case
ConcurrentModificationException will be thrown 

ConcurrentModificationException: This is a common runtime exception thrown when a thread detects that a collection has been structurally modified by another thread while it is iterating over it. Although typically associated with iterators, it can also occur in other scenarios where concurrent modifications are not handled.

 ### what is the difference between HashMap and Concurrant HashMap in java ? When would you use one over other
 ConcurrentHashMap is beneficial in a multi-threaded environment and performs better than HashMap. It provides thread-safety, scalability, and synchronization. For the single-threaded environment, the HashMap performs slightly better than ConcurrentHashMap.

 In HashMap, if one thread is iterating the object and the other thread will try to iterate the object, it will throw a runtime exception. But, in ConcurrentHashMap, it is possible to iterate the objects simultaneously by two or more threads.

 HashMap: not thread-safe. Use it in single-threaded code or for immutable/read-only maps safely published after construction.  
 
 ConcurrentHashMap: thread-safe for concurrent reads+writes with high throughput; provides atomic per-key operations (compute*, putIfAbsent, merge) and weakly-consistent iterators.


### If one thread is writing a key in concurrent hash map and other thread is reading the same key and third thread is updating another key in map , how will concurrent hashmap handle this case

Great scenario. Here’s how **ConcurrentHashMap (CHM)** behaves with three threads:

* **T1:** `put(k1, vNew)` (write/update key **k1**)
* **T2:** `get(k1)` (read same key **k1**)
* **T3:** `put(k2, vX)` (write/update **another** key **k2**)



#### What actually happens under the hood

##### 1) Reads are (mostly) lock-free; writes lock **only the affected bucket**

* CHM splits the table into **bins (buckets)**.
* **Writes** (`put/compute/replace/remove`) take a **short, per-bin lock** for the key’s bucket.
* **Reads** (`get`) are **lock-free** (they read volatile fields), so they don’t block other threads.

##### 2) Reading the **same key** while it’s being written

* While T1 is updating **k1**, T2’s `get(k1)`:

  * Sees **either the old value or the new value** (never a corrupted/partial value).
  * Once T1 **publishes** the new mapping (via volatile writes inside CHM), any `get(k1)` that starts **after that publish** will observe **vNew**.
  * If T1 is **inserting a brand-new key**, a concurrent `get(k1)` may return **null** until the publish happens.

> Intuition: you’ll observe a clean “before” or “after” snapshot for that key—no torn states.

##### 3) Writing a **different key** at the same time

* T3’s `put(k2, vX)` proceeds **independently** of T1’s write to **k1** **if k1 and k2 hash to different bins** (the common case).

  * They **don’t block each other** and can run in parallel.
* If **k1** and **k2** collide into the **same bin**, their updates contend on that bin’s lock, so one waits briefly.

##### 4) Memory visibility (happens-before)

* CHM uses **volatile** fields and short synchronized sections so that once a `put/replace/remove` **completes**, subsequent `get`s that start after the publish point will see that update.
* You’ll never read half-initialized nodes/values.



#### Small timelines

**Update existing key**

```
T1: put(k1, vNew)  — acquires k1’s bin lock → updates → publishes → releases
T2: get(k1)        — if before publish ⇒ sees old value; after publish ⇒ sees vNew
T3: put(k2, vX)    — runs in parallel unless k2 shares k1’s bin (hash collision)
```

**Insert new key**

```
T2: get(k1) during T1’s insert  ⇒ may see null (key not visible yet)
T2: get(k1) after publish       ⇒ sees vNew
```



##### Practical guidance

* Use **CHM** when multiple threads **read and write** concurrently.
* Prefer **atomic per-key ops** (`putIfAbsent`, `computeIfAbsent`, `compute`, `merge`) to avoid races.
* Keep values **immutable** (or replace whole values) to avoid in-place mutation races.
* If you need TTL/eviction/refresh/stampede control, use a cache library (e.g., **Caffeine**) rather than building policies on top of CHM.

**Bottom line:**
CHM lets T1 write **k1** while T2 reads **k1** safely (reader sees old or new, never corrupt) and lets T3 update **k2** in parallel (unless it hashes to the same bucket), delivering high throughput with fine-grained contention.


 ### How are concurrent hash map designed  ? How do they achieve concurrancy
 ConcurrentHashMap uses a variety of techniques to allow efficient concurrent operations:

 Segmented Structure: ConcurrentHashMap is divided into segments, each of which is effectively a separate hash table. This allows different threads to modify different segments concurrently, reducing contention.  

 Fine-Grained Locking: Instead of locking the entire map, ConcurrentHashMap uses fine-grained locking at the segment level. This means that only the relevant segment is locked during write operations, allowing other threads to continue working with other segments concurrently.   

 ### What happens when a volatile modifier is added to a variable
 When the volatile keyword is applied then then value written to the variable is immediatly available to read from another thread.   
 The volatile variable bypasses cpu caches and value is immediatly written to main memory 

### What are the adanvatages of executor service than manually creating threads

Here’s the straight answer for Java 17.

##### Why `ExecutorService` beats “new Thread(…).start()”

**1) Thread pooling (performance & stability)**

* Reuses a bounded set of threads → avoids costly creation/destruction, context‐switch storms, and “thread explosion” under load.
* Lets you **cap concurrency** (core/max pool size) and use **bounded queues** → prevents OOMs and thrashing.

**2) Separation of concerns (execution policy)**

* You submit *tasks*; the pool decides *how/when* to run them (fixed, cached, single, work-stealing, scheduled).
* You can swap/tune the policy without changing task code.

**3) Backpressure & load shedding**

* Pick queue type (e.g., `LinkedBlockingQueue`, `SynchronousQueue`) and a **RejectedExecutionHandler** (abort, caller-runs, discard) to control behavior at saturation.

**4) Futures, results, timeouts, cancellation**

* `submit(Callable)` returns a `Future`: `get(timeout)`, `cancel(true)`, check exceptions.
* With `CompletableFuture` you compose pipelines, add timeouts, combine tasks, and handle failures cleanly.

**5) Scheduling & periodic tasks**

* `ScheduledThreadPoolExecutor` does `schedule()`, `scheduleAtFixedRate()`, `scheduleWithFixedDelay()`—no ad-hoc timers.

**6) Lifecycle management**

* Graceful shutdown: `shutdown()`, `awaitTermination()`, or immediate `shutdownNow()`—much harder with loose threads.

**7) Observability & hygiene**

* Custom `ThreadFactory` for **naming**, priorities, daemon flag, and `UncaughtExceptionHandler`.
* Easier to add metrics around queue depth, active threads, task latency.

**8) Specialization**

* CPU-bound work: fixed pool sized ~ `cores`.
* I/O-bound: larger pool or separate pool per I/O type.
* Work-stealing (`ForkJoinPool`) for many small tasks (avoid blocking inside it).



##### Minimal patterns

**Fixed pool + results + timeout**

```java
var pool = Executors.newFixedThreadPool(
    Math.max(2, Runtime.getRuntime().availableProcessors()),
    r -> { var t = new Thread(r, "app-worker"); t.setDaemon(true); return t; }
);

Future<Result> f = pool.submit(() -> compute());
try {
  Result r = f.get(2, TimeUnit.SECONDS);
} catch (TimeoutException te) {
  f.cancel(true);
}
```

**Tunable `ThreadPoolExecutor` with backpressure**

```java
var queue = new ArrayBlockingQueue<Runnable>(1000);
var exec = new ThreadPoolExecutor(
    8, 16, 60, TimeUnit.SECONDS, queue,
    r -> { var t = new Thread(r, "api-%d".formatted(System.nanoTime())); t.setDaemon(true); return t; },
    new ThreadPoolExecutor.CallerRunsPolicy() // shed load gracefully
);
```

**Scheduled jobs**

```java
var sched = Executors.newScheduledThreadPool(2);
sched.scheduleAtFixedRate(this::rollup, 0, 5, TimeUnit.MINUTES);
```

**Consume many tasks as they finish**

```java
var ecs = new ExecutorCompletionService<Result>(exec);
for (Task t : tasks) ecs.submit(() -> t.call());
for (int i = 0; i < tasks.size(); i++) {
  Result r = ecs.take().get(); // next completed
}
```


##### When manual threads are OK

* A **single** long-lived background thread with a trivial, well-controlled lifecycle.
* Tiny prototypes/tests.
  (You still lose pooling, backpressure, and clean shutdown.)



##### Gotchas / tips

* Don’t block in a `ForkJoinPool` (or use `ManagedBlocker`/separate pool).
* Use **bounded** queues for services; unbounded queues hide overload until it’s too late.
* Name your threads and set `UncaughtExceptionHandler`.
* For very high concurrency and I/O heavy apps, consider splitting pools by workload.

> Note: In Java 21, **virtual threads** change the story (cheap threads, structured concurrency). On Java 17, `ExecutorService` is the right tool for robust, high-throughput task execution.

 
 ### What is factory design pattern
 The Factory Pattern in Spring helps in achieving better separation of concerns and abstraction, allowing you to decouple the creation of objects from their usage, making your code more flexible and maintainable.

 ### When would you use an abstract class in java
 Abstract class in Java is similar to interface except that it can contain default method implementation. 
 An abstract class is mostly used to provide a base for subclasses to extend and implement the abstract methods and override or use the implemented methods in abstract class.

 Abstract class in java can’t be instantiated.  
 The subclass of abstract class in java must implement all the abstract methods unless the subclass is also an abstract class.   

 Here's an example of how you can use an abstract class in Java to create a simple hierarchy of shapes.  

 ```java
 // Abstract class representing a generic shape
abstract class Shape {
    private String color;

    public Shape(String color) {
        this.color = color;
    }

    // Abstract method to calculate the area of the shape
    public abstract double calculateArea();

    // Concrete method to get the color of the shape
    public String getColor() {
        return color;
    }
}

// Concrete subclass representing a circle
class Circle extends Shape {
    private double radius;

    public Circle(String color, double radius) {
        super(color);
        this.radius = radius;
    }

    @Override
    public double calculateArea() {
        return Math.PI * radius * radius;
    }
}

// Concrete subclass representing a rectangle
class Rectangle extends Shape {
    private double width;
    private double height;

    public Rectangle(String color, double width, double height) {
        super(color);
        this.width = width;
        this.height = height;
    }

    @Override
    public double calculateArea() {
        return width * height;
    }
}

public class Main {
    public static void main(String[] args) {
        Circle circle = new Circle("Red", 5.0);
        System.out.println("Circle Area: " + circle.calculateArea());
        System.out.println("Circle Color: " + circle.getColor());

        Rectangle rectangle = new Rectangle("Blue", 4.0, 6.0);
        System.out.println("Rectangle Area: " + rectangle.calculateArea());
        System.out.println("Rectangle Color: " + rectangle.getColor());
    }
}

 
 ```

 In this example, the Shape class is an abstract class with a constructor to set the color of the shape and an abstract method calculateArea() that is meant to be overridden by subclasses. The Circle and Rectangle classes are concrete subclasses that extend the Shape class and provide implementations for the calculateArea() method.


### Explain how Streaming API works from http request perspective

#### 1. Normal HTTP API (non-streaming)

* Client makes a request → server processes → prepares **entire response** → sends it in one shot.
* The client only gets data **after the whole response is ready**.
* Works fine for small/fast payloads (e.g. JSON with a few KB).



#### 2. Streaming API

Instead of waiting for the **whole result set**, the server sends data in **chunks** as it becomes available.
The connection stays **open** while data flows.

#### How it works (technically)

1. **HTTP/1.1 chunked transfer encoding** or **HTTP/2 streaming**:

   * Response header is sent with `Transfer-Encoding: chunked`.
   * Server writes chunks of bytes (often JSON lines, CSV rows, or event messages).
   * Each chunk is immediately flushed to the socket.
   * Client reads incrementally without waiting for completion.
2. **Connection stays open**:

   * Until the server finishes producing data (or a timeout/close).
3. **Client consumption**:

   * Client library (Java, Python, JS, etc.) can read input streams as they arrive.
   * In Java, you’d use `HttpURLConnection` or `HttpClient` → `InputStream` → read line by line.



#### 3. Common Formats for Streaming APIs

* **Server-Sent Events (SSE)**

  * `Content-Type: text/event-stream`.
  * Each chunk is a message like:

    ```
    data: {"msg": "hello"}
    ```
  * Used by browsers and UIs (e.g. OpenAI streaming chat completions).
* **NDJSON (Newline-delimited JSON)**

  * Each line is a valid JSON object.
  * Example:

    ```
    {"id":1,"msg":"hello"}
    {"id":2,"msg":"world"}
    ```
  * Easy to parse line-by-line in most languages.
* **Raw binary / CSV rows**

  * For data exports, the server can push raw CSV lines or binary blobs.



#### 4. Why Streaming?

✅ **Lower latency** – client sees first results immediately.
✅ **Handles huge results** – don’t need to buffer everything in server RAM.
✅ **Responsive UIs** – progress updates, logs, live dashboards.
✅ **Realtime feel** – e.g. chat messages, financial ticks, event feeds.



#### 5. Trade-offs

* ❌ Harder to retry/resume (since mid-stream state may be lost if connection breaks).
* ❌ Parsing is incremental, not “load once and map to object”.
* ❌ Some proxies/load balancers buffer responses unless configured for streaming.
* ❌ Harder to paginate/index—client must consume whole stream sequentially.

When transferring datasets, where transfer is only successfull when full data is received, then streaming data is not prefferred. 

Use streaming for:  
- realtime feeds, large exports, progressive UX.

Avoid streaming for:  
- small atomic responses,
- compliance-critical data,
- or environments with unreliable infra.



#### 6. Example (Java 17 HTTP Client reading a streaming API)

```java
import java.net.http.*;
import java.net.URI;
import java.io.*;

public class StreamingApiClient {
    public static void main(String[] args) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create("https://api.example.com/stream"))
                .build();

        HttpResponse<InputStream> resp = client.send(req, HttpResponse.BodyHandlers.ofInputStream());

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(resp.body()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println("Got chunk: " + line);
                // parse line as JSON, CSV, etc.
            }
        }
    }
}
```


### What is a Streaming API response
Streaming Response: The server starts sending data as soon as it's available and continues to send more data in chunks or pieces. The client receives and processes this data incrementally as it arrives. This is particularly useful when the server needs time to generate or fetch data, and it allows the client to start consuming data earlier.

Traditional Response: The server generates the entire response and sends it to the client as a single unit. The client receives the entire response before it can start processing it. This is the conventional way of serving most web pages and responses.

### Reading a json delimited file in stream 
Each line is json and seperated by newline in file.
How to to provide a streaming output by reading the file from s3
// get files in loop. 
// read a file inputStream from s3. 
lines = new BuffererReader(new InputStreamReader(inputStream,StandardCharsets.UTF8)).lines().collect(collectors.joining("\n")) 
outputStream.write(lines.getBytes())   
outputStream.write("\n")  // so that there is newline seperation in stream for the reader


### How would you provide srteaming response for spring boot
Spring Boot Rest api streaming with StreamingResponseBody is the most easiest and elegant way to create a rest web service to stream content. I generally prefer to use StreamingResponseBody with ResponseEntity, so we can set the headers and HTTP status, in this way we can control the behavior of our API in a much better way.

StreamingResponseBody type is used for async request processing and content can be written directly to the response OutputStream without holding up the threads in the servlet container.


### Junit : What is the difference between @injectmocks and @mock?

@InjectMocks creates an instance of the class and injects the mocks that are created with the @Mock annotations into this instance. @Mock is used to create mocks that are needed to support the testing of the class to be tested. 

### When should we use @SpringBootTest annotation ?
The @SpringBootTest annotation is useful when we need to bootstrap the entire container. The annotation works by creating the ApplicationContext that will be utilized in our tests

This should not be used for unit tests as this would be very slow. It should be used as integration test



 ### Have you use Spring Boot
 ### Can you do scheduling in spring boot 
 ### How does a spring boot application get started?

Just like any other Java program, a Spring Boot application must have a main method. This method serves as an entry point, which invokes the SpringApplication#run method to bootstrap the application.

### what is caching 
Caching is the mechanism of storing data in a temporary storage location, either in memory or on disc, so that request to the data can be served faster.

Caching improves performance by decreasing page load times, and reduces the load on servers and databases.

In a typical caching model, when a new client request for a resource comes in, a lookup is done on the temporary storage to see if a similar request came in earlier. 

### Say in java you are keeping an in memory cache in hash map. This is multiple threaded application. What are the design challenges you have

Great topic. A plain `HashMap` in a multi-threaded app is a minefield. Here’s a clear checklist of the **design challenges** you’ll face and the typical fixes/patterns used in industry.



#### 1) Concurrency correctness

* **Data races / corruption**: `HashMap` is **not** thread-safe (pre-JDK8 it could even loop during resize).
  **Fix**: use `ConcurrentHashMap` (CHM) or a proven cache library (Caffeine).
* **Atomic compound ops**: `if (!map.containsKey(k)) map.put(k,v)` is not atomic → duplicates, lost updates.
  **Fix**: use CHM’s atomic methods: `compute`, `computeIfAbsent`, `putIfAbsent`, `merge`.
* **Visibility/memory model**: writers update a value but readers still see stale state.
  **Fix**: store **immutable** values (or defensive copies) and publish via CHM (which has the needed happens-before); or use `volatile` fields inside value objects when mutation is unavoidable.
* **Nulls**: CHM forbids `null` keys/values; naive loaders can throw NPEs.
  **Fix**: use a **sentinel** for “cached negative” or wrap in `Optional`.



#### 2) Thundering herd / cache stampede

Multiple threads miss the same key and all hit the backing store.

* **Fix A (per-key single flight)**: store `CompletableFuture<V>` in the map and have all waiters join it:

  ```java
  var f = cache.computeIfAbsent(key, k ->
      CompletableFuture.supplyAsync(() -> load(k), loaderPool));
  return f.get();
  ```
* **Fix B**: use Caffeine’s `Cache<K, V>` with `CacheLoader` (built-in stampede control).



#### 3) Lock contention & hot keys

* Heavy work inside `computeIfAbsent` blocks other updates on **that key**; hot keys can bottleneck.
* **Fix**: keep loader fast (I/O offloaded), shard hot values, or precompute/warm.



#### 4) Eviction, expiry, and memory

* **No eviction** in CHM → unbounded growth → OOM or GC pressure.
* **Fix**:

  * Implement policy (TTL/Tmax, size bound). Rolling your own LRU/LFU correctly under concurrency is hard.
  * **Use Caffeine** (W-TinyLFU, size/weight based, `expireAfterWrite/Access`, `refreshAfterWrite`, `maximumSize/Weight`).
* **Large/variable values**: big entries cause fragmentation and long GC pauses.
  **Fix**: cap size by **weight**; consider **off-heap** (Ehcache 3 off-heap, Chronicle Map) if truly needed.



#### 5) Consistency with the source of truth

* **Stale data**: how fresh must the cache be?
  **Patterns**:

  * **Cache-aside** (read-through on miss; explicit invalidate on write).
  * **Write-through** (update cache & DB atomically).
  * **Write-behind** (buffered writes; harder to reason about).
* **Invalidation**: on multi-instance/microservices you need cross-node coherence.
  **Fix**: publish invalidations via Kafka/Redis pub-sub/JMS; version keys (e.g., `key#version`); or use a distributed cache (Redis, Hazelcast, Coherence) if strict coherence is required.



#### 6) Loader behavior & backpressure

* **Slow/failed loaders** can pile up waiters and exhaust threads.

  * **Fix**: timeouts, circuit-breaker, limited loader pool, bulk/batch loads.
  * **Cancellation**: propagate interrupts, handle `CompletableFuture.cancel`.
* **Negative caching**: repeated misses hammer the source.
  **Fix**: cache “not found” briefly.



#### 7) Value mutability & partial updates

* Putting a mutable object once and then mutating it in place causes data races and surprising reads.

  * **Fix**: treat values as **immutable snapshots** and replace with `compute`:

    ```java
    cache.compute(key, (k, old) -> recompute(old));
    ```
  * If you must mutate, guard per-entry with fine-grained locks or make fields volatile.



#### 8) Sizing, preallocation, and GC

* **Resizes** are costly under load.
  **Fix**: estimate cardinality and set `new ConcurrentHashMap<>(initialCapacity)` up front.
* **GC pauses** with large objects / many short-lived entries.
  **Fix**: tune eviction, use compression (JDK flags), consider ZGC/Shenandoah for large heaps.



#### 9) Observability & operability

* **No insight** → you won’t know hit ratio, evictions, latency, stampedes.

  * **Fix**: expose metrics (hit/miss/loads/evictions), add tracing around loaders, and log outliers.
  * Add **removal listeners** (Caffeine) to watch why entries leave.



#### 10) Time & clocks

* Expiry needs a clock; system clock changes can break TTL.
  **Fix**: use a **monotonic** time source if implementing yourself or rely on Caffeine’s internal clock.



#### 11) Security & multi-tenancy

* **Key bleed** across tenants if you don’t namespace keys.
  **Fix**: include tenant/user in the key; set per-tenant size limits to avoid noisy neighbor issues.



#### 12) Failure & recovery

* **Warmup**: cold cache thundering herd at startup.
  **Fix**: pre-warm critical keys, or lazy-warm with rate limits.
* **Corruption**: handle loader exceptions so you don’t poison the cache with failed futures.
  **Fix**: store successes only; on failure, remove or insert short-lived negative.



###### What most teams do in practice

* For a **local, in-process cache**: use **Caffeine** instead of rolling your own (`ConcurrentHashMap` + custom eviction). It solves:

  * eviction/expiry (LRU/LFU via W-TinyLFU),
  * refresh & async loading,
  * stampede control,
  * metrics & removal listeners.
* For **shared/coherent cache** across nodes: Redis/Hazelcast/Coherence with explicit invalidation + local near-cache (often Caffeine) for hot keys.



###### Minimal, safe local cache (single-flight + TTL) with CHM

```java
class LocalCache<K, V> {
  private static final class Entry<V> {
    final CompletableFuture<V> future;
    final long expiresAtNanos;
    Entry(CompletableFuture<V> f, long exp) { this.future = f; this.expiresAtNanos = exp; }
  }
  private final ConcurrentHashMap<K, Entry<V>> map = new ConcurrentHashMap<>();
  private final Duration ttl;
  private final Executor loaderPool;

  LocalCache(Duration ttl, Executor loaderPool) { this.ttl = ttl; this.loaderPool = loaderPool; }

  V get(K key, Function<K, V> loader) {
    long now = System.nanoTime();
    Entry<V> e = map.compute(key, (k, old) -> {
      if (old != null && old.expiresAtNanos > now) return old;
      CompletableFuture<V> f = CompletableFuture.supplyAsync(() -> loader.apply(k), loaderPool);
      long exp = now + ttl.toNanos();
      return new Entry<>(f, exp);
    });
    try { return e.future.get(); }
    catch (Exception ex) { map.remove(key, e); throw new CompletionException(ex); }
  }
}
```

(Still, prefer **Caffeine** unless you have a strong reason not to.)


###  How  to prevent a thread from sharing its state with other threads
use ThreadLocal.  
With ThreadLocal, you're explicitly wanting to have one value per thread that reads the variable. That's typically for the sake of context. For example, a web server with some authentication layer might set a thread-local variable early in request handling so that any code within the execution of that request can access the authentication details, without needing any explicit reference to a context object. So long as all the handling is done on the one thread, and that's the only thing that thread does, you're fine.



### What is LRU cache
A Least Recently Used (LRU) Cache organizes items in order of use, allowing you to quickly identify which item hasn't been used for the longest amount of time.

The Least Recently Used (LRU) cache is a cache eviction algorithm that organizes elements in order of use. In LRU, as the name suggests, the element that hasn't been used for the longest time will be evicted from the cache.

ALgo: LRU Cache implementation in java with 
https://www.enjoyalgorithms.com/blog/implement-least-recently-used-cache

### What is difference between get and post rest API
GET and POST are two of the most commonly used HTTP methods in RESTful APIs.
In summary, GET requests are used for retrieving data from the server and are safe and idempotent, while POST requests are used for submitting data to the server to create or modify resources and are not necessarily safe or idempotent. 


## Can the POST request has parameters ? Why do when then have request body
Here are some reasons why having a request body in the POST method is beneficial:

Data Size: The URL has a length limit, and sending large sets of data as query parameters might lead to URL truncation or other issues. With the request body, you can transmit larger datasets more reliably.

Data Complexity: When you need to send structured data like JSON or XML, it's more convenient to include it in the request body rather than encoding it in query parameters.

Security: Some data, such as passwords, should not be exposed in the URL. The request body provides a more secure way to transmit sensitive information.

## JACKSON

Reference: https://jenkov.com/tutorials/java-json/jackson-objectmapper.html


### How would you convert is Json string to a Java Object ?

Using objectMapper readValue

```java
import com.fasterxml.jackson.databind.ObjectMapper;

public class Main {
    public static void main(String[] args) throws Exception {
        String json = "{\"first_name\":\"John\",\"last_name\":\"Doe\"}";

        ObjectMapper objectMapper = new ObjectMapper();
        Person person = objectMapper.readValue(json, Person.class);

        System.out.println("First Name: " + person.getFirstName());
        System.out.println("Last Name: " + person.getLastName());
    }
}

```

### How would you convert a Java Object to Json String
objectMapper.writeValue




### What is Hazelcast
distributed In-Memory Data Grid based on Java. 
The data is always stored in-memory (RAM) of the servers.This makes it extremely fast.  

Why to use it ?

### What is elastic search

what is a index in elastic search 

### What is Mapping in elastic search

ElasticSearch mappings define how documents and their fields are indexed and stored in ElasticSearch databases or ElasticSearch DBs. This defines the types and formats of the fields that appear in the documents. As a result, mapping can have a significant impact on how Elasticsearch searches for and stores data. After creating an index, we must define the mapping. An incorrect preliminary definition and mapping might lead to incorrect search results.


### What is Apache Kafka
Kafka is a messaging system built for high throughput and fault tolerance.  

A Topic is a category or feed in which records are saved and published.

A Kafka broker is a server that works as part of a Kafka cluster (in other words, a Kafka cluster is made up of a number of brokers). Multiple brokers typically work together to build a Kafka cluster, which provides load balancing, reliable redundancy, and failover. The cluster is managed and coordinated by brokers using Apache ZooKeeper. Without sacrificing performance, each broker instance can handle read and write volumes of hundreds of thousands per second (and gigabytes of messages). Each broker has its own ID and can be in charge of one or more topic log divisions.

### What do you mean by a Partition in Kafka? 

Kafka topics are separated into partitions, each of which contains records in a fixed order. A unique offset is assigned and attributed to each record in a partition. Multiple partition logs can be found in a single topic. This allows several users to read from the same topic at the same time. Topics can be parallelized via partitions, which split data into a single topic among numerous brokers.

#### Say in apache kafka I read a message and got an exception and application terminated . Will there be data loss in this case when the application reads back again

Short answer: it depends on **when the offset was committed**.

##### What Kafka guarantees

* Kafka doesn’t delete the record when you read it. Data stays until the topic’s **retention** expires.
* “Loss” here means your app **skips** processing a record because the consumer group’s **offset** already moved past it.

##### Cases

1. **Auto-commit (enable.auto.commit=true) or you commit before processing**

   * If the offset was committed after `poll()` but **before** your code finished the work, a crash means you’ll **skip** that record on restart.
   * From your app’s perspective, that’s **data loss** (at-most-once).

2. **Manual commit after successful processing**

   * If you only commit **after** the work completes, a crash before commit means Kafka will redeliver the record when you restart.
   * That’s **at-least-once** (no loss, but duplicates possible if your processing is not idempotent).

3. **Exactly-once (read → process → write)**

   * Use **transactions** (idempotent producer + transactional consumer/producer, commit offsets as part of the transaction).
   * On crash, uncommitted work and offsets are rolled back; on restart, the record is reprocessed **once** (exactly-once semantics for Kafka Streams or the classic consumer with transactions and `isolation.level=read_committed` on readers).

##### Gotchas that can make you “lose” messages on restart

* First run of a new group with `auto.offset.reset=latest`: if the app crashed before committing any offset, on restart the consumer may start at the **end** and skip earlier messages. Prefer `earliest` for brand-new groups.
* Committing large batches: if you commit per 1,000 records and crash at record 999, you’ll reprocess the whole batch on restart (not loss—**duplicates**).

##### Recommended pattern (plain Java consumer)

```java
props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
props.put(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, "100");          // small-ish batches
props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");     // for new groups

try {
  while (running) {
    ConsumerRecords<K, V> records = consumer.poll(Duration.ofMillis(500));
    // process the batch
    boolean allOk = true;
    for (ConsumerRecord<K,V> r : records) {
      try {
        process(r); // your logic; make it idempotent if possible
      } catch (Exception e) {
        allOk = false;
        // optional: send to DLQ or break to avoid committing this batch
        break;
      }
    }
    if (allOk && !records.isEmpty()) {
      consumer.commitSync(); // commit AFTER successful processing
    }
  }
} finally {
  try { consumer.commitSync(); } catch (Exception ignore) {}
  consumer.close();
}
```

##### If you also **produce** downstream (DB, another topic, S3)

* Aim for **idempotent writes** (e.g., upsert by key, dedupe keys, or use unique constraints).
* Or move to **transactions**:

  * Producer: `enable.idempotence=true`, set a `transactional.id`.
  * Wrap “process + write + sendOffsetsToTransaction” in a single transaction; readers use `isolation.level=read_committed`.


