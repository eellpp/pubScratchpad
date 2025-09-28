### If i declare a Map variable as final, can i put values into it later
yes. Because final marks the reference not the object. You can't make the reference point to another hash table. However you can add new values to it.  
int is a primitive type, not reference. Means with final you can't change the value of variable. 

### what is computeIfAbsent for map 

### What is inversion of control for Spring JDBC?

Inversion of Control in the context of Spring means that the framework controls the creation, configuration, and management of application objects and their interactions. This helps in building more modular, maintainable, and testable applications by reducing tight coupling and promoting separation of concerns.

In Spring, you define your application's components (beans) using configuration metadata, which can be XML-based or annotation-based. These configurations tell the Spring container what beans to create and how they are related to each other.

Dependency injection, an aspect of Inversion of Control (IoC), is a general concept stating that we do not create our objects manually but instead describe how they should be created. Then an IoC container will instantiate required classes if needed

### What does @Component annotation mean in spring
@Component is an annotation that allows Spring to detect our custom beans automatically.

In other words, without having to write any explicit code, Spring will:

Scan our application for classes annotated with @Component
Instantiate them and inject any specified dependencies into them
Inject them wherever needed

### What is the use of @Configuration Annotation in spring
In Spring Framework, the @Configuration annotation is used to indicate that a class defines one or more beans that should be managed by the Spring IoC container. When a class is annotated with @Configuration, it effectively becomes a configuration class, and Spring treats it as a source of bean definitions. 

Suppose you have a Spring application that manages two beans: a UserService and a EmailService. You want to configure these beans using a Java-based configuration class.

```java
public class UserService {
    private String name;

    public UserService(String name) {
        this.name = name;
    }

    public String getGreeting() {
        return "Hello from " + name;
    }
}

```

```java
public class EmailService {
    public void sendEmail(String recipient, String message) {
        System.out.println("Sending email to " + recipient + ": " + message);
    }
}

```
create a configuration class named AppConfig using the @Configuration annotation:  

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

    @Bean
    public UserService userService() {
        return new UserService("John");
    }

    @Bean
    public EmailService emailService() {
        return new EmailService();
    }
}

```

Use the configured beans in your application:   

```java
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class MainApp {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        UserService userService = context.getBean(UserService.class);
        System.out.println(userService.getGreeting());

        EmailService emailService = context.getBean(EmailService.class);
        emailService.sendEmail("example@example.com", "Hello there!");

        context.close();
    }
}


```

### What Is the Default Bean Scope in Spring Framework?
By default, a Spring Bean is initialized as a singleton.  

### What is a Singleton Pattern
The Singleton Pattern is a creational design pattern that ensures a class has only one instance and provides a global point of access to that instance  

The Singleton Pattern is commonly used to manage resources that are shared among multiple components of an application.

### Are Singleton Beans Thread-Safe?
No, singleton beans are not thread-safe

When multiple threads access and modify the same instance of a singleton bean concurrently, you need to take proper synchronization measures to ensure thread safety. 

 If a singleton bean's methods access shared resources or modify shared state, you should consider using synchronized blocks or other synchronization mechanisms to ensure that only one thread can access the critical section at a time.

 Utilize Java's concurrent libraries such as java.util.concurrent classes for managing concurrent access to shared resources. For example, using ConcurrentHashMap instead of a regular HashMap if your bean needs to store and manipulate data concurrently.

 ### what is the difference between HashMap and Concurrant HashMap in java ? When would you use one over other
 ConcurrentHashMap is beneficial in a multi-threaded environment and performs better than HashMap. It provides thread-safety, scalability, and synchronization. For the single-threaded environment, the HashMap performs slightly better than ConcurrentHashMap.

 In HashMap, if one thread is iterating the object and the other thread will try to iterate the object, it will throw a runtime exception. But, in ConcurrentHashMap, it is possible to iterate the objects simultaneously by two or more threads.

 HashMap: not thread-safe. Use it in single-threaded code or for immutable/read-only maps safely published after construction.  
 
 ConcurrentHashMap: thread-safe for concurrent reads+writes with high throughput; provides atomic per-key operations (compute*, putIfAbsent, merge) and weakly-consistent iterators.


#### If one thread is writing a key in concurrent hash map and other thread is reading the same key and third thread is updating another key in map , how will concurrent hashmap handle this case

Great scenario. Here’s how **ConcurrentHashMap (CHM)** behaves with three threads:

* **T1:** `put(k1, vNew)` (write/update key **k1**)
* **T2:** `get(k1)` (read same key **k1**)
* **T3:** `put(k2, vX)` (write/update **another** key **k2**)

---

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

---

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

---

## Practical guidance

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
### JDBC

### What does Statement.setFetchSize(nSize) method really do in SQL Server JDBC driver?   
 ### What should you take care while choosing fetch size parameter in jdbc.  
In JDBC, the setFetchSize(int) method is very important to performance and memory-management within the JVM as it controls the number of network calls from the JVM to the database and correspondingly the amount of RAM used for ResultSet processing.

The RESULT-SET is the number of rows marshalled on the DB in response to the query. The ROW-SET is the chunk of rows that are fetched out of the RESULT-SET per call from the JVM to the DB. The number of these calls and resulting RAM required for processing is dependent on the fetch-size setting.

So if the RESULT-SET has 100 rows and the fetch-size is 10, there will be 10 network calls to retrieve all of the data, using roughly 10*{row-content-size} RAM at any given time.

The default fetch-size is 10, which is rather small. In the case posted, it would appear the driver is ignoring the fetch-size setting, retrieving all data in one call (large RAM requirement, optimum minimal network calls).

What happens underneath ResultSet.next() is that it doesn't actually fetch one row at a time from the RESULT-SET. It fetches that from the (local) ROW-SET and fetches the next ROW-SET (invisibly) from the server as it becomes exhausted on the local client.


 Most of the JDBC drivers’ default fetch size is 10. In normal JDBC programming if you want to retrieve 1000 rows it requires 100 network round trips between your application and database server to transfer all data. Definitely this will impact your application response time. The reason is JDBC drivers are designed to fetch small number of rows from database to avoid any out of memory issues.   

 Type of Application: Consider the nature of your application. For interactive applications, a lower fetchSize might be preferable to provide faster initial results, while for batch processing, a larger fetchSize can improve throughput.


### Is fetch size param literally executed by jdbc driver 
The fetchSize parameter is a hint to the JDBC driver as to many rows to fetch in one go from the database. But the driver is free to ignore this and do what it sees fit. Some drivers, like the Oracle one, fetch rows in chunks, so you can read very large result sets without needing lots of memory. Other drivers just read in the whole result set in one go, and I'm guessing that's what your driver is doing.


### For Oracle database, say you have to download 5 million rows. Explain the pros and cons of approaches taken when the row size is small vs when the row size is large . The application is interactive website vs batch eod job etc. 

Great—since you’re on **Oracle + Java 17 (JDBC)**, here’s a crisp, practical playbook with trade-offs and settings for different situations.


* **Interactive/low-latency reads:** small–medium `fetchSize` (200–1,000), show first rows fast.
* **Backend/EOD huge exports (>10M rows):** larger `fetchSize` (5k–20k), stream to disk (optionally **.gz**), avoid sorting unless needed, chunk by PK for resumability.
* **Small/narrow rows:** push `fetchSize` higher (10k–20k).
* **Wide rows / LOBs:** keep `fetchSize` modest (200–1,000), stream LOBs.

---

#### Oracle specifics that matter

###### 1) Row fetching knobs

* `PreparedStatement.setFetchSize(N)`
  Tells Oracle JDBC how many rows to fetch per round trip. Fewer round trips = better throughput, but higher client memory per fetch.
* `oracle.jdbc.OraclePreparedStatement#setRowPrefetch(N)`
  Oracle’s native equivalent; either is fine. (Use via cast only if you already depend on Oracle types.)
* `connection.setReadOnly(true)`
  A hint; can enable some optimizations.
* Auto-commit can stay **on** for long reads in Oracle; no special cursor rules (unlike Postgres). You can safely keep it **on**.

**Rules of thumb**

* Narrow rows (≲ 200–300 bytes): `fetchSize = 10_000–20_000`.
* Medium rows (1–2 KB): `fetchSize = 2_000–10_000`.
* Wide rows (≥ 8 KB, or have LOBs): `fetchSize = 200–1_000`.

###### 2) Snapshot consistency & ORA-01555

Long scans read from a consistent SCN. If writers keep churning and your **UNDO** can’t retain old versions long enough, you can hit **ORA-01555: snapshot too old**.

**Mitigations (pick what fits):**

* Run exports during quieter windows (EOD).
* Increase `UNDO_RETENTION` or size.
* Make the export **faster** (bigger `fetchSize`, fewer per-row transformations, gzip to reduce I/O).
* If you chunk, consider **Flashback Query** with a captured SCN:
  `SELECT /*+ PARALLEL(n) */ ... AS OF SCN :scn WHERE id BETWEEN :lo AND :hi`
  so all chunks see the **same point-in-time** view.

###### 3) Sorting & indexing

* `ORDER BY` a **primary key** if you need determinism/resume-ability. Sorting a huge set on a non-indexed expression will spill to TEMP and slow your job.
* If you don’t need order, **skip ORDER BY** to maximize scan speed (especially with `PARALLEL`).

###### 4) LOBs & very wide rows

* Read **LOBs via streams** (`getBinaryStream` / `getCharacterStream`) and **write straight out**; avoid `getBytes()` on giant BLOBs.
* Keep `fetchSize` modest for LOB queries (200–500), because each “row” can be large.
* If possible, **avoid exporting gigantic LOBs to CSV**; use file dumps or object storage pointers.

###### 5) Parallelism

* You can parallelize on the **application side** by splitting the PK/ROWID ranges into N shards, each with its own connection and output file (later merge if truly needed).
  Example shard predicate: `WHERE id BETWEEN :lo AND :hi`.
* Or use Oracle hints: `SELECT /*+ PARALLEL(8) */ ...` for the scan itself (coordinate with your DBA; don’t hurt prod).

###### 6) CSV correctness & I/O

* Use an RFC-4180-ish escape (quotes doubled, wrap if comma/quote/CR/LF).
* **Gzip on the fly** (`.gz`)—often 3–10× smaller, significantly faster end-to-end when I/O bound.
* Use big buffers (≥ 1MB) for writer and gzip.

---

#### Scenario guide (pros/cons & settings)

###### A) Small row size (e.g., 5–10 narrow columns, no LOBs)

**Pros:** High throughput, minimal memory per row; can push fetch size high.
**Cons:** Network round trips dominate if fetch size is too small.

**Use:**

* `fetchSize = 10_000–20_000`.
* Optional `/*+ PARALLEL(8) */` if the table and system allow.
* Chunk by PK for resume and parallel workers (e.g., 1–5M rows per chunk).

**When interactive:** lower `fetchSize` (200–500) so first page returns fast.

###### B) Medium row size (1–2 KB)

**Pros:** Still streamable with good throughput.
**Cons:** Memory per batch grows; “too large” fetch size adds client pressure.

**Use:**

* `fetchSize = 2_000–10_000` (start ~5k; tune).
* Gzip output; keep transformations light.
* Consider partition-wise chunking to keep ranges aligned with storage.

**Interactive:** `fetchSize = 200–1_000`.

###### C) Wide rows (≥ 8 KB) or with LOBs (CLOB/BLOB)

**Pros:** Few round trips even with small fetch sizes.
**Cons:** Client buffering and GC pressure; CSV bloats; Excel consumers choke.

**Use:**

* `fetchSize = 200–1_000`.
* Stream LOBs; avoid building huge strings.
* Consider exporting **metadata + externalized LOBs** (files/URIs) instead of raw CSV when possible.

**Interactive:** `fetchSize = 100–300`.

###### D) Interactive ad-hoc (dashboards, tools)

**Goal:** low latency for first rows.
**Use:** `fetchSize = 200–500`; no gzip; smaller buffers; possibly server-side pagination (`ROWNUM`/`OFFSET` style) for UI.

###### E) Backend/EOD batch (10M–100M rows)

**Goal:** sustained throughput, reliability, repeatability.
**Use:**

* `fetchSize = 5_000–20_000` (tune by row width).
* **No ORDER BY** unless needed. If needed, sort by indexed PK.
* **Chunk by PK**; write one file per chunk (or append), checkpoint last PK.
* Capture an **SCN** and use `AS OF SCN` in all chunks for a consistent snapshot, or run in a quiet window to avoid ORA-01555.
* Gzip on the fly; 1–8MB buffers.
* Consider `/*+ PARALLEL(n) */` with DBA approval.

---

###### Example: Oracle-tuned exporter snippet

```java
try (PreparedStatement ps = conn.prepareStatement(
        "SELECT /*+ PARALLEL(8) */ id, col1, col2, created_at FROM big_table /* add WHERE if chunked */ ORDER BY id",
        ResultSet.TYPE_FORWARD_ONLY,
        ResultSet.CONCUR_READ_ONLY)) {

    // Tune per row width
    ps.setFetchSize(10_000); // small/narrow rows ⇒ higher; wide/LOB ⇒ 200–1000

    try (ResultSet rs = ps.executeQuery();
         OutputStream os = Files.newOutputStream(Path.of("export.csv.gz"));
         GZIPOutputStream gz = new GZIPOutputStream(os, 1 << 20);
         BufferedWriter w = new BufferedWriter(new OutputStreamWriter(gz, StandardCharsets.UTF_8), 1 << 20)) {

        writeCsv(rs, w); // your streaming CSV writer
    }
}
```

**Chunked with consistent snapshot:**

```java
// Capture SCN once:
long scn = getCurrentScn(conn); // SELECT CURRENT_SCN FROM V$DATABASE

String sql = """
  SELECT id, col1, col2, created_at
  FROM big_table AS OF SCN ?
  WHERE id > ? AND id <= ?
  ORDER BY id
""";

try (PreparedStatement ps = conn.prepareStatement(sql)) {
  ps.setLong(1, scn);
  ps.setLong(2, lastId);
  ps.setLong(3, nextId);
  ps.setFetchSize(10_000);
  // stream to file...
}
```


### How to get export a large amount of data (greater > 10 million) from database in csv format
Approach 1 : get rows in result set and store in list and return csv
Approach 2: return csv in streaming manner

read the result set and stream the results (based on each implementation) directly to the OutputStream using our CSVWriterWrapper.  

Json streaming out result set with object mapper.  
https://www.javacodegeeks.com/2018/09/streaming-jdbc-resultset-json.html

csv streaming out result set with printer writer
https://www.javacodegeeks.com/2018/12/java-streaming-jdbc-resultset-csv.html  


The flush() method of PrintWriter Class in Java is used to flush the stream. By flushing the stream, it means to clear the stream of any element that may be or maybe not inside the stream. 


### Explain how Streaming API works from http request perspective

#### 1. Normal HTTP API (non-streaming)

* Client makes a request → server processes → prepares **entire response** → sends it in one shot.
* The client only gets data **after the whole response is ready**.
* Works fine for small/fast payloads (e.g. JSON with a few KB).

---

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

---

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

---

#### 4. Why Streaming?

✅ **Lower latency** – client sees first results immediately.
✅ **Handles huge results** – don’t need to buffer everything in server RAM.
✅ **Responsive UIs** – progress updates, logs, live dashboards.
✅ **Realtime feel** – e.g. chat messages, financial ticks, event feeds.

---

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

---

#### 1) Concurrency correctness

* **Data races / corruption**: `HashMap` is **not** thread-safe (pre-JDK8 it could even loop during resize).
  **Fix**: use `ConcurrentHashMap` (CHM) or a proven cache library (Caffeine).
* **Atomic compound ops**: `if (!map.containsKey(k)) map.put(k,v)` is not atomic → duplicates, lost updates.
  **Fix**: use CHM’s atomic methods: `compute`, `computeIfAbsent`, `putIfAbsent`, `merge`.
* **Visibility/memory model**: writers update a value but readers still see stale state.
  **Fix**: store **immutable** values (or defensive copies) and publish via CHM (which has the needed happens-before); or use `volatile` fields inside value objects when mutation is unavoidable.
* **Nulls**: CHM forbids `null` keys/values; naive loaders can throw NPEs.
  **Fix**: use a **sentinel** for “cached negative” or wrap in `Optional`.

---

#### 2) Thundering herd / cache stampede

Multiple threads miss the same key and all hit the backing store.

* **Fix A (per-key single flight)**: store `CompletableFuture<V>` in the map and have all waiters join it:

  ```java
  var f = cache.computeIfAbsent(key, k ->
      CompletableFuture.supplyAsync(() -> load(k), loaderPool));
  return f.get();
  ```
* **Fix B**: use Caffeine’s `Cache<K, V>` with `CacheLoader` (built-in stampede control).

---

#### 3) Lock contention & hot keys

* Heavy work inside `computeIfAbsent` blocks other updates on **that key**; hot keys can bottleneck.
* **Fix**: keep loader fast (I/O offloaded), shard hot values, or precompute/warm.

---

#### 4) Eviction, expiry, and memory

* **No eviction** in CHM → unbounded growth → OOM or GC pressure.
* **Fix**:

  * Implement policy (TTL/Tmax, size bound). Rolling your own LRU/LFU correctly under concurrency is hard.
  * **Use Caffeine** (W-TinyLFU, size/weight based, `expireAfterWrite/Access`, `refreshAfterWrite`, `maximumSize/Weight`).
* **Large/variable values**: big entries cause fragmentation and long GC pauses.
  **Fix**: cap size by **weight**; consider **off-heap** (Ehcache 3 off-heap, Chronicle Map) if truly needed.

---

#### 5) Consistency with the source of truth

* **Stale data**: how fresh must the cache be?
  **Patterns**:

  * **Cache-aside** (read-through on miss; explicit invalidate on write).
  * **Write-through** (update cache & DB atomically).
  * **Write-behind** (buffered writes; harder to reason about).
* **Invalidation**: on multi-instance/microservices you need cross-node coherence.
  **Fix**: publish invalidations via Kafka/Redis pub-sub/JMS; version keys (e.g., `key#version`); or use a distributed cache (Redis, Hazelcast, Coherence) if strict coherence is required.

---

#### 6) Loader behavior & backpressure

* **Slow/failed loaders** can pile up waiters and exhaust threads.

  * **Fix**: timeouts, circuit-breaker, limited loader pool, bulk/batch loads.
  * **Cancellation**: propagate interrupts, handle `CompletableFuture.cancel`.
* **Negative caching**: repeated misses hammer the source.
  **Fix**: cache “not found” briefly.

---

#### 7) Value mutability & partial updates

* Putting a mutable object once and then mutating it in place causes data races and surprising reads.

  * **Fix**: treat values as **immutable snapshots** and replace with `compute`:

    ```java
    cache.compute(key, (k, old) -> recompute(old));
    ```
  * If you must mutate, guard per-entry with fine-grained locks or make fields volatile.

---

#### 8) Sizing, preallocation, and GC

* **Resizes** are costly under load.
  **Fix**: estimate cardinality and set `new ConcurrentHashMap<>(initialCapacity)` up front.
* **GC pauses** with large objects / many short-lived entries.
  **Fix**: tune eviction, use compression (JDK flags), consider ZGC/Shenandoah for large heaps.

---

#### 9) Observability & operability

* **No insight** → you won’t know hit ratio, evictions, latency, stampedes.

  * **Fix**: expose metrics (hit/miss/loads/evictions), add tracing around loaders, and log outliers.
  * Add **removal listeners** (Caffeine) to watch why entries leave.

---

#### 10) Time & clocks

* Expiry needs a clock; system clock changes can break TTL.
  **Fix**: use a **monotonic** time source if implementing yourself or rely on Caffeine’s internal clock.

---

#### 11) Security & multi-tenancy

* **Key bleed** across tenants if you don’t namespace keys.
  **Fix**: include tenant/user in the key; set per-tenant size limits to avoid noisy neighbor issues.

---

#### 12) Failure & recovery

* **Warmup**: cold cache thundering herd at startup.
  **Fix**: pre-warm critical keys, or lazy-warm with rate limits.
* **Corruption**: handle loader exceptions so you don’t poison the cache with failed futures.
  **Fix**: store successes only; on failure, remove or insert short-lived negative.

---

###### What most teams do in practice

* For a **local, in-process cache**: use **Caffeine** instead of rolling your own (`ConcurrentHashMap` + custom eviction). It solves:

  * eviction/expiry (LRU/LFU via W-TinyLFU),
  * refresh & async loading,
  * stampede control,
  * metrics & removal listeners.
* For **shared/coherent cache** across nodes: Redis/Hazelcast/Coherence with explicit invalidation + local near-cache (often Caffeine) for hot keys.

---

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


