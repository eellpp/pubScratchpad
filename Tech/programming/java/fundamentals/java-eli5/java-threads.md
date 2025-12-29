### what is runnable in java

The Runnable interface declares a single method called run(), which contains the code that will be executed when the thread starts. To create a Runnable instance, you can either implement the Runnable interface directly or use a lambda expression.  

```java
public class MyRunnable implements Runnable {
    @Override
    public void run() {
        // Code to be executed in a separate thread
        System.out.println("Hello from a separate thread!");
    }
}
```

or by lambda expression

```java
Runnable myRunnable = () -> {
    // Code to be executed in a separate thread
    System.out.println("Hello from a separate thread!");
};
```

Once you have a Runnable instance, you can pass it to a Thread object and start the thread. Here's an example:  

```java
public class Main {
    public static void main(String[] args) {
        Runnable myRunnable = new MyRunnable(); // or use a lambda expression

        Thread thread = new Thread(myRunnable);
        thread.start(); // Start the thread
    }
}
```

When the thread starts, it will execute the run() method of the Runnable instance in a separate thread of execution.

Using the Runnable interface allows you to separate the code that needs to run in a separate thread from the code in the main thread. This can be useful for tasks that require concurrent or parallel processing, such as background tasks, handling multiple connections, or performing time-consuming operations without blocking the main thread.  

