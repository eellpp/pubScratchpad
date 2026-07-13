A useful way to think about senior Java knowledge is:

> It is less about knowing more language features and more about understanding what happens around the code: JVM, operating system, network, database, deployment, concurrency, failures, and observability.

## 1. JVM and process behaviour

### Heap size is not process memory

A beginner may assume:

```text
-Xmx4g = Java process uses at most 4 GB
```

That is incorrect. The process also uses memory for:

* Metaspace
* Thread stacks
* Direct byte buffers
* JIT-compiled code cache
* JNI/native libraries
* Garbage collector structures
* Memory-mapped files
* Native allocations made by libraries

A Java process with `-Xmx4g` can easily consume considerably more than 4 GB of resident memory.

This becomes especially important in containers because the container may be killed by the operating system even though Java has not thrown `OutOfMemoryError: Java heap space`.

### Not all `OutOfMemoryError`s mean the same thing

Examples include:

```text
Java heap space
GC overhead limit exceeded
Metaspace
Direct buffer memory
Unable to create native thread
Requested array size exceeds VM limit
```

Each points to a different problem. Increasing `-Xmx` may fix one and worsen another.

### Thread count consumes memory

Every Java thread normally has a native stack. With a large `-Xss`, thousands of threads can consume significant memory.

For example, conceptually:

```text
2,000 threads × 1 MB stack ≈ 2 GB of potential native address space
```

This is one reason unbounded thread creation is dangerous even when the heap looks healthy.

### JVM warm-up affects performance

Java performance often changes after startup because of:

* Class loading
* JIT compilation
* Profile-guided optimisation
* Cache population
* Connection-pool warm-up
* Lazy framework initialisation

A five-second local benchmark immediately after startup may say very little about steady-state production performance.

## 2. Garbage collection realities

### High CPU is not always application work

The JVM may be spending substantial CPU time doing garbage collection. The application can appear busy while accomplishing little useful work.

Important signals include:

* Allocation rate
* GC frequency
* Pause duration
* Time spent in GC
* Old-generation occupancy
* Promotion failures
* Humongous allocations
* Full GC frequency

### Memory leak does not always mean an object was forgotten permanently

In managed languages, a “leak” usually means objects remain reachable longer than intended.

Common production causes include:

* Static maps
* Unbounded caches
* ThreadLocal values
* Listener registrations
* Executor queues
* Class-loader references
* Large HTTP sessions
* Metrics with unbounded labels
* Retaining full request or response objects
* Keeping exception stack traces in collections

### A low heap after Full GC does not prove the process is healthy

The problem may instead be:

* Native memory
* Direct buffers
* Too many threads
* File descriptor exhaustion
* Memory-mapped files
* JNI allocations

Heap dumps do not show every kind of process memory.

## 3. Classpath and class-loading problems

### The class present at compile time may not be the class used at runtime

A project may compile successfully but fail in production with:

```text
NoSuchMethodError
NoClassDefFoundError
ClassNotFoundException
AbstractMethodError
IncompatibleClassChangeError
```

These often indicate dependency-version or classpath conflicts rather than a coding error in the failing line.

For example, the code compiled against library version 2, but production loads version 1 first.

### Dependency convergence matters

Maven may pull multiple versions of the same transitive dependency. The selected version may depend on dependency-tree resolution rules, not necessarily on which version appears most appropriate.

Experienced developers routinely inspect:

```bash
mvn dependency:tree
```

They also understand exclusions, dependency management, shaded JARs, and split packages.

### “Works in the IDE” is weak evidence

The IDE, Maven test runner, packaged JAR, application server, Docker image, and production startup script may all construct different classpaths.

The deployable artifact must be tested in a production-like startup mode.

## 4. TLS, certificates, and security configuration

Related to your earlier `cacerts` question, production Java developers normally learn that:

### Truststore and keystore serve different purposes

* Truststore: whom the application trusts
* Keystore: the certificate and private key the application presents

### Certificate failures are often chain problems

A server certificate may look valid in a browser but fail in Java because:

* The intermediate certificate is not sent
* The internal root CA is missing
* The application uses a different JDK than expected
* A custom truststore replaces rather than supplements `cacerts`
* A proxy re-signs TLS traffic
* Hostname verification fails
* The certificate's SAN does not contain the hostname
* The certificate has expired
* System and JVM clocks differ

### Setting a custom truststore can remove public trust

When you specify:

```text
-Djavax.net.ssl.trustStore=/some/custom.jks
```

Java generally uses that store. It does not automatically merge it with the JDK's normal `cacerts`.

Therefore, a custom truststore containing only internal certificates may cause public HTTPS calls to stop working.

### The Java process may not use the JDK you think it uses

The shell's:

```bash
java -version
```

does not prove that a service uses the same Java installation.

A `systemd` unit, application server, scheduler, Docker image, or startup script may point to another JDK with a different `cacerts`.

## 5. Concurrency beyond `synchronized`

### Thread-safe collections do not make a sequence of operations atomic

This is unsafe logically:

```java
if (!map.containsKey(key)) {
    map.put(key, value);
}
```

Even when `map` is a `ConcurrentHashMap`, another thread can act between the two operations.

Use an atomic operation such as:

```java
map.putIfAbsent(key, value);
```

or:

```java
map.computeIfAbsent(key, this::loadValue);
```

### `volatile` provides visibility, not general atomicity

This is not made safe by declaring `count` volatile:

```java
count++;
```

The operation is read-modify-write and can lose updates.

### Executor queues can be more dangerous than thread counts

This common construction has an effectively unbounded queue:

```java
Executors.newFixedThreadPool(20);
```

If work arrives faster than it is processed, tasks accumulate in memory. The service may remain responsive initially and then fail much later.

Production systems often need:

* Bounded queues
* Rejection policies
* Backpressure
* Request timeouts
* Load shedding
* Queue-depth metrics

### Cancellation is cooperative

Calling:

```java
future.cancel(true);
```

does not forcibly terminate arbitrary code. It requests interruption.

The task must:

* Check interrupt status
* Use interruptible blocking calls
* Avoid swallowing `InterruptedException`
* Exit cleanly when interrupted

A common production bug is:

```java
catch (InterruptedException e) {
    log.error("Interrupted", e);
}
```

The code often needs to restore interruption:

```java
Thread.currentThread().interrupt();
```

### Deadlocks are not the only concurrency failure

Other issues include:

* Thread starvation
* Lock contention
* Livelock
* Queue buildup
* Pool exhaustion
* Unsafe publication
* Lost updates
* Duplicate processing
* Out-of-order execution
* Blocking operations inside async pipelines

## 6. Connection-pool behaviour

### A database pool does not create unlimited capacity

If a service has:

```text
200 request threads
20 database connections
```

at most about 20 database operations can actively use the pool at once. The remaining requests wait.

Increasing request threads may increase latency without increasing throughput.

### Connections must be returned on every path

Failure to close JDBC resources can exhaust the pool:

```java
try (Connection connection = dataSource.getConnection();
     PreparedStatement statement = connection.prepareStatement(sql);
     ResultSet resultSet = statement.executeQuery()) {
    ...
}
```

Closing a pooled connection usually returns it to the pool; it does not physically close the database connection.

### Pool timeout and query timeout are different

You normally need to distinguish:

* Time waiting for a pool connection
* Time establishing a physical connection
* Time executing a query
* Network socket timeout
* Transaction timeout

A single generic “timeout” setting rarely covers all of these.

### Validation matters

A connection can exist in the pool but be unusable because:

* Firewall idle timeout closed it
* Database restarted
* Network path changed
* Session was killed
* Authentication token expired

Pool validation and connection lifetime settings must match infrastructure behaviour.

## 7. Transaction boundaries

### `@Transactional` has proxy-related behaviour

In typical Spring usage, this may not activate transaction interception:

```java
public void outer() {
    inner();
}

@Transactional
public void inner() {
    ...
}
```

The self-call does not pass through the proxy.

Other practical issues include:

* Private methods are not normally proxied
* Checked and unchecked exceptions may have different rollback behaviour
* Catching an exception can prevent expected rollback
* Async execution does not automatically carry the transaction
* Database work may occur outside the intended transaction
* A long transaction can hold locks and connections for too long

### Transaction does not mean distributed atomicity

A database commit and a Kafka publish are not automatically one transaction:

```text
update database
publish message
```

Failure between the two operations can create inconsistency. This leads to patterns such as:

* Transactional outbox
* Idempotent consumers
* Deduplication
* Retry with stable operation IDs
* Reconciliation jobs

## 8. Time and date problems

### `LocalDateTime` is not a timestamp

It contains no zone or offset. The same `LocalDateTime` can refer to different instants in different locations.

Production systems often need:

* `Instant` for machine timestamps
* `ZonedDateTime` for region-based civil time
* `OffsetDateTime` when an explicit offset matters
* `LocalDate` for a calendar date
* `Duration` for elapsed time

### Default timezone is hidden global configuration

Code may behave differently across machines when it uses:

```java
ZoneId.systemDefault()
```

or legacy `Date`, `Calendar`, and formatting APIs implicitly.

A Docker container may be configured as UTC while a developer laptop uses Singapore time.

### Daylight-saving transitions break simple assumptions

Not every day has exactly 24 civil hours in every timezone. Some local times can be skipped or occur twice.

Even Singapore-based systems encounter this when processing events for other countries.

### Wall-clock time is unsuitable for measuring elapsed duration

System time can jump because of clock synchronisation. For elapsed measurements, Java generally uses a monotonic source such as:

```java
System.nanoTime()
```

rather than subtracting `currentTimeMillis()` values.

## 9. File and resource handling

### File paths are environment-dependent

Production failures arise from assumptions about:

* Current working directory
* Path separators
* Case sensitivity
* Writable directories
* Temporary directory size
* Symbolic links
* Network-mounted filesystems
* Atomic rename support
* File ownership and permissions

A path working on a case-insensitive Mac filesystem may fail on Linux.

### “Rename” on object storage is usually copy and delete

On S3-like storage, there is generally no filesystem-style atomic rename. Frameworks may simulate it through:

```text
copy object → delete original
```

This affects performance, cost, atomicity, and failure handling.

### Always close streams, including failure paths

Use try-with-resources. File descriptor leaks can cause:

```text
Too many open files
```

long before heap memory is exhausted.

## 10. Networking details

### HTTP timeout is not one timeout

Useful distinctions include:

* DNS resolution
* Connection timeout
* TLS handshake timeout
* Pool-acquisition timeout
* Request/write timeout
* Response/read timeout
* Overall operation deadline

Without correct limits, a Java thread can remain blocked far longer than expected.

### Retries can amplify an outage

Suppose 100 service instances each retry three times immediately. One downstream failure can become 400 requests.

Production retry design needs:

* Exponential backoff
* Jitter
* Maximum attempts
* Overall deadline
* Retryable-error classification
* Idempotency
* Circuit breaking
* Retry budgets

### DNS changes may not be noticed immediately

JVM and operating-system DNS caching can affect failover. The exact behaviour depends on JVM security settings, resolver configuration, and application libraries.

### Connection pools can preserve stale infrastructure assumptions

After DNS or load-balancer changes, existing keep-alive connections may continue to point to old instances until recycled.

## 11. Exception handling

### Logging and rethrowing creates duplicate logs

This pattern often causes the same exception to be logged at multiple layers:

```java
catch (Exception e) {
    log.error("Operation failed", e);
    throw e;
}
```

A better design decides which layer has enough context and responsibility to log the final failure.

### Catching `Exception` can destroy failure semantics

Different failures need different responses:

* Validation error
* Authentication failure
* Timeout
* Optimistic-lock conflict
* Non-retryable business rejection
* Temporary downstream outage
* Programming defect

Turning everything into “internal error” makes operations and retries unreliable.

### Exception messages are not stable APIs

Code should not usually determine behaviour using:

```java
if (e.getMessage().contains("duplicate")) {
    ...
}
```

Use exception types, SQL state, error codes, or structured response fields.

### Stack traces are expensive and noisy when failures are expected

Repeatedly generating and logging exceptions on a high-volume path can produce CPU and logging pressure. Expected validation outcomes may be better represented without exception-heavy control flow.

## 12. Logging and observability

### Logging can itself cause an outage

Risks include:

* Huge log volume
* Synchronous appenders
* Full disks
* Logging large payloads
* Repeated stack traces
* High-cardinality fields
* Sensitive data exposure
* Slow network log destinations

### The important question is not “Do we have logs?”

It is:

> Can we determine which request failed, where it failed, why it failed, and what state was left behind?

Useful operational context includes:

* Correlation or trace ID
* Business operation ID
* Partition or shard
* Retry attempt
* Downstream target
* Duration
* Outcome
* Error category

### Metrics cardinality can exhaust monitoring systems

This is dangerous:

```text
request_count{user_id="123456"}
```

because every user creates a new time series.

Experienced developers distinguish bounded labels such as status or endpoint from unbounded values such as request ID, email address, and full URL.

### Health checks need semantics

A service returning HTTP 200 from `/health` may still be unable to do useful work because:

* Database pool is exhausted
* Kafka consumer is stalled
* Required credentials expired
* Disk is full
* Downstream service is unavailable

Readiness, liveness, and business-function health are different concepts.

## 13. Deployment and configuration

### Environment variables are strings

Values such as:

```text
false
0
10m
10
```

must be parsed according to application rules. A typo or unexpected unit can silently create dangerous behaviour.

### Configuration precedence can be surprising

A value may come from:

* Application defaults
* Properties file
* Profile-specific file
* Environment variable
* JVM system property
* Command-line argument
* Remote configuration service
* Kubernetes ConfigMap or Secret

When debugging, experienced developers ask not only “What is configured?” but “Which source won?”

### Rolling deployments mean two versions may run simultaneously

Backward and forward compatibility matter for:

* Database schema
* Kafka messages
* REST payloads
* Cache entries
* Serialized objects
* Scheduled jobs

A deployment is rarely an instantaneous replacement of every instance.

### Startup success does not mean operational readiness

A process may be running while it is still:

* Loading caches
* Establishing connections
* Performing migrations
* Joining a Kafka consumer group
* Warming JIT code
* Downloading configuration

Traffic should not necessarily be sent immediately after the process starts.

## 14. Serialization and compatibility

### Java native serialization is usually a poor external contract

Serializing Java objects directly can create:

* Version compatibility problems
* Security risks
* Tight coupling to class names and fields
* Difficulty reading data from other languages
* Fragile `serialVersionUID` behaviour

Long-lived data and messages generally benefit from explicit schemas and versioning.

### Adding a field can still break consumers

Even with JSON, changes can fail when:

* Consumers reject unknown fields
* A field becomes required
* A number changes type
* Enum values are added
* Nullability changes
* Date format changes
* Semantic meaning changes while syntax stays the same

Compatibility is behavioural, not merely syntactic.

## 15. Caching

### A cache is another data system

It introduces questions about:

* Expiration
* Maximum size
* Eviction
* Consistency
* Stampedes
* Negative caching
* Refresh behaviour
* Serialization
* Failure fallback
* Metrics

### `computeIfAbsent` is not automatically a perfect cache loader

The loading operation may be slow, fail, recurse, or block concurrent map operations in surprising ways. Cache libraries often provide better controls for expiration, limits, asynchronous refresh, and failure handling.

### Cache keys must include all relevant dimensions

A common bug is caching by user ID while the result also depends on locale, permission, tenant, version, or request parameters.

## 16. Production performance

### The slow line may not be where time is spent

Latency often comes from waiting:

* Database pool
* Lock
* Remote API
* DNS
* Disk
* Queue
* Garbage collection
* Thread scheduling
* Connection establishment

CPU profiling alone may not explain latency.

### Average latency hides incidents

A service can have a good average while some users wait a very long time.

Production teams examine percentiles such as:

```text
p50, p95, p99, maximum
```

### Throughput and latency are related nonlinearly

As utilisation approaches system capacity, queueing delay can rise sharply. Increasing load by 10% can increase latency by far more than 10%.

### Optimisation without measurement is dangerous

Experienced Java developers use evidence from:

* Java Flight Recorder
* Thread dumps
* Heap dumps
* GC logs
* Native memory tracking
* Database execution plans
* Distributed traces
* Application metrics
* OS tools

They do not infer everything from source code.

## 17. Data-processing and batch-job realities

Especially in Spark, Kafka, and ETL environments:

### Exactly-once is usually conditional

Claims of exactly-once depend on:

* Where state is stored
* Whether the sink supports transactions
* Whether retries are idempotent
* Whether offsets and output commits are coordinated
* Whether external side effects are involved

### A retry may duplicate data

A task can complete its external write and fail before recording success. The framework retries it, producing a duplicate.

Operations should use stable IDs or idempotent writes wherever possible.

### Partial success must be designed for

A batch processing one million records may successfully process 999,000 and fail on the remainder. The design must answer:

* Retry everything or only failures?
* How are successes recorded?
* Can records be processed twice?
* How is reconciliation performed?
* How is poison data isolated?

## 18. Build and release discipline

### Reproducible builds matter

Two builds from the same source can differ because of:

* Unpinned plugin versions
* Mutable dependency versions
* Environment-dependent resources
* Build timestamps
* Different JDKs
* Generated files
* External downloads

### Source compatibility is not runtime compatibility

The following are separate questions:

* Does the code compile?
* Does bytecode run on the target JVM?
* Are libraries binary-compatible?
* Are reflective accesses allowed?
* Are required modules present?
* Does the application behave correctly under the new GC/JIT/runtime?

### The JDK used to build and the JDK used to run both matter

Tools such as Maven may use one JDK while the shell invokes another. Check:

```bash
java -version
mvn -version
```

The second command shows the JDK Maven itself is using.

## 19. Shutdown behaviour

### A process receiving `SIGTERM` needs time to stop safely

Graceful shutdown may need to:

* Stop accepting requests
* Stop polling Kafka
* Finish or cancel active work
* Commit offsets
* Return database connections
* Flush logs
* Close executors
* Release locks

If shutdown takes longer than the orchestrator's grace period, the process may receive `SIGKILL`, where no cleanup runs.

### Shutdown hooks are not guaranteed in every termination

They do not help with:

* `SIGKILL`
* Operating-system crash
* Container runtime failure
* Machine power loss
* Some severe JVM failures

Correctness must not depend entirely on shutdown cleanup.

## 20. The strongest practical indicator

Someone with genuine production experience usually asks questions like:

* What happens when this times out?
* Is the operation idempotent?
* Is the queue bounded?
* What happens during a rolling deployment?
* Which JDK is actually running the process?
* Can the dependency version differ at runtime?
* What metric tells us this is failing?
* What happens when the database restarts?
* Is this memory on-heap or off-heap?
* Who owns retrying this operation?
* What state remains after partial failure?
* Can two instances execute this simultaneously?
* How do we diagnose it without reproducing it locally?

A book-trained developer often explains the happy path correctly. An experienced production developer naturally examines the failure path, resource limits, concurrency, compatibility, and operability.

A concise summary is:

> Junior Java knowledge is primarily about writing code that works. Senior production Java knowledge is about ensuring that the code remains correct, diagnosable, bounded, and recoverable when dependencies, infrastructure, timing, data, and load behave badly.
