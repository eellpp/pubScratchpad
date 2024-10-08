These flashcards cover the key concepts of `CompletableFuture` as discussed in the document.

| **Question**                                                     | **Answer**                       |
|------------------------------------------------------------------|----------------------------------|
| What does `CompletableFuture` extend in Java?                     | `Future`                         |
| What does `CompletableFuture` provide over `Future`?              | Non-blocking operations          |
| How does `CompletableFuture` handle exceptions?                   | With `exceptionally()` or `handle()` |
| What does `CompletableFuture.supplyAsync()` do?                   | Executes a task asynchronously   |
| How can you manually complete a `CompletableFuture`?              | Using `complete()`               |
| What method is used to chain tasks in `CompletableFuture`?        | `thenApply()`, `thenCompose()`   |
| What does `CompletableFuture.allOf()` do?                         | Combines multiple futures        |
| How does `join()` differ from `get()`?                            | `join()` throws unchecked exceptions |
| What is thrown by `get()` if the task fails?                      | `ExecutionException`             |
| What type of exception does `join()` throw?                       | `CompletionException`            |
| Can `CompletableFuture` be used with functional programming?      | Yes, supports lambdas and method references |
| How does `thenAccept()` work in `CompletableFuture`?              | It consumes the result without returning a value |
| What is `thenCompose()` used for in `CompletableFuture`?          | To chain dependent tasks         |
| What is a key feature of `CompletableFuture`?                     | Asynchronous non-blocking computation |
| How do you wait for all tasks to finish in `CompletableFuture`?   | Use `CompletableFuture.allOf()`  |
| What is the purpose of `exceptionally()` in `CompletableFuture`?  | To handle exceptions             |
| What does `thenRun()` do in `CompletableFuture`?                  | Runs a task after completion without using the result |
| What does `thenApply()` return?                                   | A transformed result             |
| What is a key advantage of `CompletableFuture` over `Future`?     | Non-blocking chaining and combination |
| How can you block until all futures are complete?                 | Use `get()` on `CompletableFuture.allOf()` |



The key difference between `CompletableFuture` and `Future` lies in their features and capabilities for handling asynchronous computations in Java. Let's explore these differences and understand when to use each.

### **1. Future** (`java.util.concurrent.Future`)

The `Future` interface was introduced in Java 5 and is part of the `java.util.concurrent` package. It represents the result of an asynchronous computation, and it provides methods to check if the computation is complete, to wait for its completion, and to retrieve the result.

#### Features of `Future`:
- **Basic Asynchronous Computation**: `Future` represents the result of a computation that may not have completed yet.
- **Blocking Operations**: You can call `future.get()` to wait for the result of the computation, but this call blocks the current thread until the computation is complete.
- **No Manual Completion**: Once a `Future` is created, it cannot be manually completed. The result must come from the computation.
- **No Chaining or Combining**: `Future` lacks methods to chain multiple asynchronous computations or to combine results of multiple futures.
- **Cancellation**: You can cancel a task using `future.cancel()`.

#### Example of `Future`:
```java
ExecutorService executor = Executors.newSingleThreadExecutor();
Future<Integer> future = executor.submit(() -> {
    // Simulate a long-running task
    Thread.sleep(1000);
    return 42;
});

// Block and wait for the result
Integer result = future.get();
System.out.println(result);
executor.shutdown();
```

### **2. CompletableFuture** (`java.util.concurrent.CompletableFuture`)

`CompletableFuture` was introduced in Java 8 and extends the `Future` interface. It represents a more powerful and flexible way of handling asynchronous computations.

#### Features of `CompletableFuture`:
- **Non-blocking Operations**: `CompletableFuture` provides non-blocking methods to check for completion (like `thenApply`, `thenAccept`, etc.) and allows you to set up actions to be triggered upon completion.
- **Manual Completion**: `CompletableFuture` allows manual completion of the future using methods like `complete()`, `completeExceptionally()`.
- **Chaining and Combining**: You can chain multiple asynchronous computations using methods like `thenApply()`, `thenCompose()`, `thenAccept()`, etc. You can also combine multiple `CompletableFuture` instances with methods like `allOf()`, `anyOf()`.
- **Functional Programming Style**: Supports lambda expressions and method references for defining asynchronous task pipelines.
- **Exception Handling**: Built-in support for handling exceptions using methods like `exceptionally()` or `handle()`.
- **Multiple Threads**: You can easily perform asynchronous operations across different threads with `supplyAsync()` or `runAsync()`.

#### Example of `CompletableFuture`:
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

### **Key Differences:**

| Feature               | `Future`                            | `CompletableFuture`               |
|-----------------------|-------------------------------------|-----------------------------------|
| **Non-blocking**       | No, `get()` is blocking             | Yes, supports non-blocking methods|
| **Completion Handling**| Basic (`isDone()`, `get()`)         | Rich APIs for chaining, combining |
| **Manual Completion**  | No                                  | Yes (`complete()`, `completeExceptionally()`) |
| **Chaining**           | No                                  | Yes (`thenApply()`, `thenCompose()`) |
| **Combining Futures**  | No                                  | Yes (`allOf()`, `anyOf()`)        |
| **Exception Handling** | Limited (manual try-catch)          | Built-in exception handling (`exceptionally()`, `handle()`) |
| **Functional Style**   | No                                  | Yes, supports lambdas and method references |

### **When to Use `Future`**:
- **Simple Use Cases**: When you need a basic asynchronous task and don't require chaining, combining, or manual completion.
- **Legacy Code**: In systems that predate Java 8 or when working with APIs that only return `Future`.
- **Blocking Tasks**: When it’s acceptable to block the current thread while waiting for a result.

### **When to Use `CompletableFuture`**:
- **Complex Asynchronous Flows**: When you need to chain multiple asynchronous tasks together, perform actions when tasks complete, or combine multiple asynchronous computations.
- **Non-blocking Behavior**: When you want to avoid blocking threads and handle asynchronous results in a non-blocking way.
- **Manual Completion**: When you need the ability to complete or fail a task manually.
- **Functional Programming**: When you prefer a more functional, declarative style of programming with lambdas and method references.
- **Error Handling**: When you need built-in exception handling for asynchronous computations.

In modern Java applications, `CompletableFuture` is typically preferred over `Future` because of its richer feature set, non-blocking capabilities, and ability to chain tasks together.

### Using Completable future for Method Chaining
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
