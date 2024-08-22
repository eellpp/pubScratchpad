Here is a basic example of a thread pool of size 5 that creates tasks returning a boolean status. The example demonstrates submitting all tasks, triggering their execution, and waiting for the results of all tasks. If any task throws an exception, the execution will stop, and all threads will perform cleanup and close the app.

```java
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

public class ThreadPoolExample {
    public static void main(String[] args) {
        // Create a thread pool with 5 threads
        ExecutorService executorService = Executors.newFixedThreadPool(5);

        // Create a list to store Future objects representing task results
        List<Future<Boolean>> futureList = new ArrayList<>();

        try {
            // Submit all tasks to the thread pool
            for (int i = 0; i < 10; i++) {
                final int taskId = i;
                Callable<Boolean> task = () -> {
                    try {
                        // Simulate task processing
                        System.out.println("Task " + taskId + " is processing.");
                        TimeUnit.SECONDS.sleep(2); // Simulate some work

                        // Simulate a condition that could throw an exception
                        if (taskId == 5) {
                            throw new RuntimeException("Task " + taskId + " encountered an error!");
                        }

                        // Return the task status as true if successful
                        return true;
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                        System.err.println("Task " + taskId + " was interrupted.");
                        return false;
                    }
                };

                // Submit the task and add its Future to the list
                futureList.add(executorService.submit(task));
            }

            // Wait for the results of all tasks
            for (Future<Boolean> future : futureList) {
                try {
                    // Get the result of the task (blocking call)
                    Boolean result = future.get();
                    System.out.println("Task completed with result: " + result);
                } catch (ExecutionException e) {
                    // Handle the exception thrown by the task
                    System.err.println("Exception in task: " + e.getCause());
                    // Stop the execution of all threads and initiate cleanup
                    cleanup(executorService);
                    return;
                }
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.err.println("Main thread was interrupted.");
        } finally {
            // Ensure the executor service is shut down in any case
            cleanup(executorService);
        }
    }

    // Cleanup method to shut down the thread pool
    private static void cleanup(ExecutorService executorService) {
        System.out.println("Shutting down executor service...");
        executorService.shutdown();
        try {
            if (!executorService.awaitTermination(5, TimeUnit.SECONDS)) {
                System.out.println("Forcing shutdown...");
                executorService.shutdownNow();
            }
        } catch (InterruptedException e) {
            System.err.println("Cleanup interrupted.");
            executorService.shutdownNow();
        }
        System.out.println("Application closed.");
    }
}
```

### Explanation:

1. **Thread Pool:** A fixed thread pool of size 5 is created using `Executors.newFixedThreadPool(5)`.
2. **Task Creation:** Ten tasks are created. Each task simulates processing for 2 seconds.
3. **Exception Handling:** One task (`taskId == 5`) deliberately throws an exception to simulate a failure.
4. **Future Handling:** All tasks are submitted to the thread pool, and their `Future` objects are collected. The `get()` method is used to retrieve the result of each task.
5. **Execution Stop on Exception:** If any task throws an exception, the program catches it, shuts down the executor service, and exits the application. The cleanup is done via the `cleanup` method, which safely shuts down the thread pool.
6. **Graceful Shutdown:** The `cleanup` method attempts to shut down the executor gracefully and forces termination if the pool doesn't shut down within the timeout.

### Output:
- The program processes the tasks concurrently.
- If any task throws an exception, all threads are stopped, and the application is closed with proper cleanup.
