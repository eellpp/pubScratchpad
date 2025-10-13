
## **1. CompletableFuture** (`java.util.concurrent.CompletableFuture`)

`CompletableFuture` was introduced in Java 8 and extends the `Future` interface. It represents a more powerful and flexible way of handling asynchronous computations.

### Features of `CompletableFuture`:
- **Non-blocking Operations**: `CompletableFuture` provides non-blocking methods to check for completion (like `thenApply`, `thenAccept`, etc.) and allows you to set up actions to be triggered upon completion.
- **Manual Completion**: `CompletableFuture` allows manual completion of the future using methods like `complete()`, `completeExceptionally()`.
- **Chaining and Combining**: You can chain multiple asynchronous computations using methods like `thenApply()`, `thenCompose()`, `thenAccept()`, etc. You can also combine multiple `CompletableFuture` instances with methods like `allOf()`, `anyOf()`.
- **Functional Programming Style**: Supports lambda expressions and method references for defining asynchronous task pipelines.
- **Exception Handling**: Built-in support for handling exceptions using methods like `exceptionally()` or `handle()`.
- **Multiple Threads**: You can easily perform asynchronous operations across different threads with `supplyAsync()` or `runAsync()`.

### Example of `CompletableFuture`:
```java
CompletableFuture<Integer> completableFuture = CompletableFuture.supplyAsync(() -> {
    // Simulate a long-running task
    sleep(1000);
    return 42;
});

// Non-blocking chaining and completion handling
completableFuture.thenApply(result -> result * 2)
                 .thenAccept(result -> System.out.println("Result: " + result));

// Optional blocking wait
completableFuture.get();
```

### **Key Differences with legacy Future interface:**

| Feature               | `Future`                            | `CompletableFuture`               |
|-----------------------|-------------------------------------|-----------------------------------|
| **Non-blocking**       | No, `get()` is blocking             | Yes, supports non-blocking methods|
| **Completion Handling**| Basic (`isDone()`, `get()`)         | Rich APIs for chaining, combining |
| **Manual Completion**  | No                                  | Yes (`complete()`, `completeExceptionally()`) |
| **Chaining**           | No                                  | Yes (`thenApply()`, `thenCompose()`) |
| **Combining Futures**  | No                                  | Yes (`allOf()`, `anyOf()`)        |
| **Exception Handling** | Limited (manual try-catch)          | Built-in exception handling (`exceptionally()`, `handle()`) |
| **Functional Style**   | No                                  | Yes, supports lambdas and method references |


In modern Java applications, `CompletableFuture` is typically preferred over `Future` because of its richer feature set, non-blocking capabilities, and ability to chain tasks together.



## CompletableFuture Uses the Common Pool

 **by default, `CompletableFuture` uses the common ForkJoinPool for asynchronous operations.**

However, this requires some important clarification about *when* and *how* it uses the common pool.


### 1. **Async Methods Without an Executor**
When you use `CompletableFuture` methods that end with `*Async` and **don't specify a custom executor**, they use the common ForkJoinPool:

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
    // This task runs in the common ForkJoinPool
    return "Hello from common pool!";
});

CompletableFuture<Void> future2 = CompletableFuture.runAsync(() -> {
    // This also runs in the common ForkJoinPool
    System.out.println("Running in common pool");
});
```

### 2. **Async Methods With a Custom Executor**
When you **explicitly provide an executor**, it uses that instead:

```java
ExecutorService customExecutor = Executors.newFixedThreadPool(4);

CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
    // This runs in our custom thread pool, NOT the common pool
    return "Hello from custom executor!";
}, customExecutor);
```

### 3. **Non-Async Operations**
Regular operations (without `Async`) execute in the thread that completes the previous stage:

```java
CompletableFuture.supplyAsync(() -> "data") // Runs in common pool
    .thenApply(result -> result.toUpperCase()) // Runs in same thread as supplyAsync
    .thenAccept(result -> System.out.println(result)); // Runs in same thread
```

### Important Considerations and Best Practices

### **Blocking Operations Warning**
**Never** perform blocking operations in the common pool:

```java
// ❌ DANGEROUS - Can stall the common pool
CompletableFuture.supplyAsync(() -> {
    try {
        Thread.sleep(5000); // Blocking call
        return someBlockingIODatabaseCall(); // Blocking I/O
    } catch (InterruptedException e) {
        throw new RuntimeException(e);
    }
}); // Uses common pool by default

// ✅ BETTER - Use custom executor for blocking tasks
ExecutorService ioExecutor = Executors.newCachedThreadPool();
CompletableFuture.supplyAsync(() -> {
    // Blocking I/O operation
    return someBlockingIODatabaseCall();
}, ioExecutor); // Explicit custom executor
```

### **Checking Which Pool is Being Used**
You can verify which thread is executing your task:

```java
CompletableFuture.supplyAsync(() -> {
    Thread currentThread = Thread.currentThread();
    System.out.println("Thread name: " + currentThread.getName());
    System.out.println("Thread is daemon: " + currentThread.isDaemon());
    System.out.println("Thread in ForkJoinPool: " + 
        (currentThread instanceof ForkJoinWorkerThread));
    return "result";
});
```

### **Common Pool Configuration**
The common pool size is determined by:
- Runtime.availableProcessors() - 1 (if not configured)
- Can be configured with: `-Djava.util.concurrent.ForkJoinPool.common.parallelism=N`

```java
// Set common pool parallelism to 16
System.setProperty("java.util.concurrent.ForkJoinPool.common.parallelism", "16");
```

### Summary

| Scenario | Thread Pool Used |
|----------|------------------|
| `supplyAsync(() -> {})` | Common ForkJoinPool |
| `runAsync(() -> {})` | Common ForkJoinPool |
| `supplyAsync(() -> {}, customExecutor)` | Custom Executor |
| `thenApply()`, `thenAccept()` (non-async) | Previous stage's thread |
| `thenApplyAsync()` | Common ForkJoinPool |

**Best Practice:** Use the common pool for CPU-intensive tasks, but provide a custom executor for I/O-bound or blocking operations to avoid stalling the common pool.

## Using Completable future for Method Chaining
`CompletableFuture` example where the `main` function accepts a list of IDs. For each ID, we perform the same three steps: fetch data, process the data, and store the data, with random sleep times for each task. The tasks are chained for each ID, and all the tasks are executed asynchronously.

```java
import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

public class CompletableFutureChainingExample {

    public static void main(String[] args) throws ExecutionException, InterruptedException {
        // List of IDs to process
        List<Integer> ids = Arrays.asList(1, 2, 3, 4, 5);

        // Process each ID asynchronously and chain tasks for each ID
        CompletableFuture<Void> allTasks = CompletableFuture.allOf(
            ids.stream()
                .map(id -> processId(id))
                .toArray(CompletableFuture[]::new)
        );

        // Wait for all tasks to complete
        allTasks.get();

        System.out.println("All IDs have been processed.");
    }

    // Chain the tasks for each ID
    private static CompletableFuture<Void> processId(int id) {
        return CompletableFuture.supplyAsync(() -> {
            // Step 1: Fetch data asynchronously with random sleep time
            String fetchedData = fetchData(id);
            return fetchedData;
        }).thenApply(fetchedData -> {
            // Step 2: Process data asynchronously with random sleep time
            return processData(fetchedData);
        }).thenAccept(processedData -> {
            // Step 3: Store data asynchronously with random sleep time
            storeData(processedData);
        }).thenRun(() -> {
            // Completion task for this ID
            System.out.println("Completed processing for ID: " + id);
        });
    }

    // Simulate fetching data with a random delay
    private static String fetchData(int id) {
        System.out.println("Fetching data for ID: " + id);
        sleepRandomTime();
        return "Data for ID " + id;
    }

    // Simulate processing data with a random delay
    private static String processData(String data) {
        System.out.println("Processing " + data);
        sleepRandomTime();
        return data.toUpperCase();
    }

    // Simulate storing data with a random delay
    private static void storeData(String processedData) {
        System.out.println("Storing " + processedData);
        sleepRandomTime();
    }

    // Helper method to sleep for a random time (1 to 3 seconds)
    private static void sleepRandomTime() {
        Random random = new Random();
        int sleepTime = 1 + random.nextInt(3); // Random sleep between 1 and 3 seconds
        try {
            TimeUnit.SECONDS.sleep(sleepTime);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
```


```bash
Fetching data for ID: 1
Fetching data for ID: 3
Fetching data for ID: 2
Fetching data for ID: 4
Fetching data for ID: 5
Processing Data for ID 1
Processing Data for ID 5
Processing Data for ID 4
Processing Data for ID 2
Storing DATA FOR ID 2
Processing Data for ID 3
Completed processing for ID: 2
Storing DATA FOR ID 1
Storing DATA FOR ID 5
Storing DATA FOR ID 4
Storing DATA FOR ID 3
Completed processing for ID: 1
Completed processing for ID: 3
Completed processing for ID: 5
Completed processing for ID: 4
All IDs have been processed.
```

### Explanation:

1. **Main Function**: 
   - The main function now accepts a list of IDs (`ids`).
   - For each ID, we call `processId(id)`, which chains the tasks for that particular ID.
   - We use `CompletableFuture.allOf()` to wait for all the `CompletableFuture` instances to complete.

2. **`processId` Method**: 
   - This method chains three asynchronous tasks (`fetchData`, `processData`, `storeData`) for each ID.
   - Each task is executed asynchronously using the `thenApply()` and `thenAccept()` methods, followed by `thenRun()` to signal the completion for that particular ID.

3. **Random Sleep**:
   - The `sleepRandomTime()` method introduces a random delay (between 1 and 3 seconds) to simulate varying processing times for each ID during the fetching, processing, and storing stages.

4. **Completion**:
   - Once all tasks for all IDs are completed, the program prints `"All IDs have been processed."`.

This approach efficiently handles multiple IDs in parallel, ensuring that each ID follows the chained tasks while allowing different sleep times for each stage.

## **3. Explanation of CompletableFuture.allOf and allTasks.get in above example**

`CompletableFuture.allOf()` and `allTasks.get()` play roles in waiting for tasks to finish, they operate in different ways and serve different purposes.

### 1. **`CompletableFuture.allOf()`**:

- **Purpose**: `CompletableFuture.allOf()` is used to combine multiple `CompletableFuture` instances into a single `CompletableFuture<Void>`. This resulting `CompletableFuture` completes when **all** of the given `CompletableFuture` instances complete.
  
- **Usage in the Example**: 
  - In the example, we use `CompletableFuture.allOf()` to combine all the `CompletableFuture` instances returned by `processId(id)` into one `CompletableFuture<Void>`.
  - This means the `CompletableFuture<Void>` created by `CompletableFuture.allOf()` will be marked as completed only when **all** the `CompletableFuture` tasks for each ID have finished.

### 2. **`allTasks.get()`**:

- **Purpose**: `allTasks.get()` is a blocking call that waits for the completion of the `CompletableFuture` on which it is called. In this case, `allTasks.get()` is called on the `CompletableFuture<Void>` returned by `CompletableFuture.allOf()`. 

- **Usage in the Example**: 
  - `allTasks.get()` is waiting for the completion of the `CompletableFuture<Void>` created by `CompletableFuture.allOf()`.
  - This means that `allTasks.get()` will block the main thread until **all** the tasks represented by the `CompletableFuture` instances passed to `CompletableFuture.allOf()` are complete.

### Key Differences:

- **`CompletableFuture.allOf()`**:
  - **Combines futures**: It does not block the thread but instead returns a new `CompletableFuture<Void>`. This `CompletableFuture` represents the combined completion of multiple futures. No actual waiting happens here unless you explicitly wait on this combined future (e.g., by calling `get()` or using `thenRun()`).

- **`allTasks.get()`**:
  - **Blocks and waits**: This is the method that blocks the main thread until the combined `CompletableFuture` (from `CompletableFuture.allOf()`) is completed. It ensures that the main program flow pauses until all asynchronous tasks are finished.

### How They Work Together in the Example:

- `CompletableFuture.allOf()` is used to **combine** all the individual `CompletableFuture` instances (one for each ID). It produces a new `CompletableFuture<Void>` that completes when **all** tasks for all IDs are complete.
- `allTasks.get()` is the **blocking call** that actually waits for the completion of this combined `CompletableFuture`. Without calling `get()`, the main thread would not block, and the program might terminate before all tasks are finished.

### Conclusion:

- `CompletableFuture.allOf()` creates a single future that represents the completion of multiple futures.
- `allTasks.get()` blocks the main thread until that combined future (from `CompletableFuture.allOf()`) is completed.

Both are related to waiting for tasks to finish, but `CompletableFuture.allOf()` by itself doesn't block; it just creates the combined future. The `get()` call is what actually blocks and waits for everything to finish.

## **4.  Difference between CompletableFuture get and join**
The primary difference between `CompletableFuture.get()` and `CompletableFuture.join()` in Java lies in their behavior when handling exceptions. Both methods are used to wait for the completion of a `CompletableFuture` and retrieve its result, but they handle exceptions differently.

### 1. **`CompletableFuture.get()`**

- **Throws Checked Exceptions**: `CompletableFuture.get()` throws checked exceptions, specifically `InterruptedException` and `ExecutionException`. This means you must handle or declare these exceptions in your code.
- **Signature**:
  ```java
  public T get() throws InterruptedException, ExecutionException
  ```
- **Usage**: When you call `get()`, the current thread is blocked until the computation is complete, and if the computation throws an exception, `ExecutionException` will wrap that exception.

#### Example:
```java
CompletableFuture<Integer> future = CompletableFuture.supplyAsync(() -> 1 / 0); // ArithmeticException

try {
    // This will throw an ExecutionException because of the division by zero
    Integer result = future.get();
} catch (InterruptedException | ExecutionException e) {
    System.out.println("Exception occurred: " + e.getMessage());
}
```
- If the computation fails (e.g., division by zero), the exception is wrapped in an `ExecutionException`, and you are required to handle it with a `try-catch` block.

### 2. **`CompletableFuture.join()`**

- **Unchecked Exceptions**: `CompletableFuture.join()` does not throw checked exceptions. Instead, if the computation encounters an exception, it throws an unchecked `CompletionException`. This makes `join()` easier to use in scenarios where you don't want to deal with checked exceptions.
- **Signature**:
  ```java
  public T join()
  ```
- **Usage**: Like `get()`, `join()` also blocks the current thread until the computation is complete, but it propagates exceptions as unchecked exceptions (specifically `CompletionException`). This removes the need for explicit exception handling but requires handling unchecked exceptions if needed.

#### Example:
```java
CompletableFuture<Integer> future = CompletableFuture.supplyAsync(() -> 1 / 0); // ArithmeticException

try {
    // This will throw a CompletionException because of the division by zero
    Integer result = future.join();
} catch (CompletionException e) {
    System.out.println("Exception occurred: " + e.getCause().getMessage());
}
```
- If the computation fails (e.g., division by zero), the exception is wrapped in a `CompletionException`, which is unchecked, so you don't need to declare it in the method signature.

### Key Differences:

| Feature                | **`CompletableFuture.get()`**                     | **`CompletableFuture.join()`**               |
|------------------------|---------------------------------------------------|---------------------------------------------|
| **Exception Handling**  | Throws checked exceptions: `InterruptedException`, `ExecutionException`. | Throws unchecked `CompletionException`. |
| **Checked Exceptions**  | Must be handled or declared.                     | No need to handle checked exceptions.       |
| **Checked vs Unchecked**| Returns wrapped exceptions as checked.           | Returns wrapped exceptions as unchecked.    |
| **Use Case**            | Use when you want explicit handling of exceptions and need to manage `InterruptedException` or `ExecutionException`. | Use when you want simpler code with unchecked exceptions and don’t need to handle checked exceptions explicitly. |

### When to Use `get()` vs `join()`:

- **Use `get()`**: When you are in a context where handling checked exceptions is required or desirable, such as in environments where you are dealing with legacy code or APIs that expect `InterruptedException` or `ExecutionException` to be explicitly managed.

- **Use `join()`**: When you prefer to work with unchecked exceptions, typically in scenarios where you want cleaner code without having to handle checked exceptions, especially in functional programming or stream pipelines. However, you must still be aware that unchecked exceptions (like `CompletionException`) may propagate and need to be handled at some point in the code.

In summary, `get()` requires you to handle checked exceptions, while `join()` simplifies code by using unchecked exceptions but provides similar functionality otherwise.
