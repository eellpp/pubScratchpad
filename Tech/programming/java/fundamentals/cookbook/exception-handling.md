
Here are the key concepts for **Exception Handling** in Java:

 flashcards based on the key concepts from the document on **Exception Handling in Java**:

### Flashcards on Exception Handling

| **Question**                                                              | **Answer**                                   |
|---------------------------------------------------------------------------|----------------------------------------------|
| What are the three main types of exceptions in Java?                       | Checked, Unchecked (Runtime), Errors         |
| What keyword is used to explicitly throw an exception in Java?             | `throw`                                      |
| What is the purpose of the `finally` block in exception handling?          | To execute code after `try-catch`, regardless of exceptions |
| What is a checked exception?                                               | An exception that must be declared or handled (e.g., `IOException`) |
| Why should you avoid throwing `Throwable`, `Error`, or generic `Exception`? | It prevents proper exception handling and recovery |
| What does `try-with-resources` do?                                         | Automatically closes resources after use     |
| What is the difference between `Throwable` and `Exception`?                | `Throwable` catches everything, including `Errors`; `Exception` is for recoverable issues |
| Why is catching `RuntimeException` considered bad practice?                | It's meant for programming errors, not expected control flow |
| When should you throw an exception?                                        | When the method can't handle an issue and the caller should handle it |
| What is wrong with using `printStackTrace()` in production code?           | It's poor practice; use proper logging instead |

These flashcards summarize the essential concepts around exception handling in Java, focusing on best practices and key mechanisms.


### 1. **Types of Exceptions**
   - **Checked Exceptions**: Exceptions that must be handled either by using a `try-catch` block or by declaring them in the method signature using `throws`. These are checked at compile time (e.g., `IOException`, `SQLException`).
   - **Unchecked Exceptions (Runtime Exceptions)**: Exceptions that do not need to be explicitly handled or declared. They occur at runtime and are typically programming errors (e.g., `NullPointerException`, `ArrayIndexOutOfBoundsException`).
   - **Errors**: These represent serious issues that applications are not expected to handle (e.g., `OutOfMemoryError`, `StackOverflowError`).

### 2. **Keywords for Exception Handling**
   - **`try`**: Defines a block of code that will be tested for exceptions.
   - **`catch`**: Defines a block of code that handles the exception thrown by the `try` block.
   - **`finally`**: Defines a block of code that is executed after the `try-catch` block, regardless of whether an exception occurred or not.
   - **`throw`**: Used to explicitly throw an exception.
   - **`throws`**: Declares that a method may throw an exception, enabling the calling method to handle it.

### 3. **Try-Catch Block**
   - Java's exception handling mechanism revolves around the `try-catch` block, where exceptions that occur in the `try` block are caught in the `catch` block.

   ```java
   try {
       // Code that may throw an exception
   } catch (ExceptionType e) {
       // Handle exception
   }
   ```

### 4. **Finally Block**
   - The `finally` block always executes after the `try-catch` block, regardless of whether an exception was thrown. It's typically used for resource cleanup, such as closing files or database connections.

   ```java
   try {
       // Code that may throw an exception
   } catch (ExceptionType e) {
       // Handle exception
   } finally {
       // Cleanup code
   }
   ```

### 5. **Multiple Catch Blocks**
   - You can catch different types of exceptions by using multiple `catch` blocks, each handling a specific type of exception.

   ```java
   try {
       // Code that may throw an exception
   } catch (IOException e) {
       // Handle IOException
   } catch (SQLException e) {
       // Handle SQLException
   }
   ```

### 6. **Custom Exceptions**
   - You can create your own exception classes by extending the `Exception` class for checked exceptions or `RuntimeException` for unchecked exceptions.

   ```java
   class MyCustomException extends Exception {
       public MyCustomException(String message) {
           super(message);
       }
   }
   ```

### 7. **Throwing Exceptions**
   - You can manually throw exceptions in your code using the `throw` keyword.

   ```java
   throw new MyCustomException("Error occurred");
   ```

### 8. **Exception Propagation**
   - Exceptions propagate up the call stack until they are caught by a `catch` block, or the program terminates. If a method doesn’t handle an exception, it can declare that it throws the exception using the `throws` keyword.

   ```java
   public void method() throws IOException {
       // Code that may throw IOException
   }
   ```

### 9. **Try-with-Resources**
   - Introduced in Java 7, this is a special kind of `try` block used for automatically closing resources that implement the `AutoCloseable` interface (e.g., streams, readers, etc.).

   ```java
   try (BufferedReader br = new BufferedReader(new FileReader("file.txt"))) {
       // Use the resource
   } catch (IOException e) {
       // Handle exception
   }
   ```

### 10. **Best Practices for Exception Handling**
   - **Handle exceptions at the right level**: Catch exceptions where they can be meaningfully handled or logged.
   - **Don’t catch generic exceptions**: Avoid catching `Exception` or `Throwable`, unless necessary.
   - **Use custom exceptions sparingly**: Create custom exceptions only when they provide clear value.
   - **Clean up resources**: Always release resources in a `finally` block or using try-with-resources.
   - **Document thrown exceptions**: Use Javadoc to describe exceptions thrown by methods.

These key concepts are fundamental to effectively managing exceptions in Java, ensuring that your application can gracefully handle errors and maintain stability.

### Generic exceptions Error, RuntimeException, Throwable and Exception should never be thrown




- catch (Throwable ex) { //Non-compliant code
- public void doSomething() throws Exception {...} // Non-compliant code
```java
public void foo(String bar) { 
  throw new CustomRuntimeException("My Message");    // Compliant
}
```

The primary reason why one should avoid throwing Generic Exceptions, Throwable, Error etc is that doing in this way prevents classes from catching the intended exceptions. Thus, a caller cannot examine the exception to determine why it was thrown and consequently cannot attempt recovery.

### Catching Runtime exceptions
```java
public void foo(String bar) throws Throwable { // Non-compliant
  throw new RuntimeException("My Message");    // Non-Compliant
}
```
catching RuntimeException is considered as a bad practice. RuntimeException is intended to be used for programmer errors. And, thus, throwing Generic Exceptions/Throwable would lead the developer to catch the exception at a later stage which would eventually lead to further code smells.

There are a few cases where you can catch runtime exceptions:

1) You are calling code that comes from a 3rd party where you do not have control over when they throw exception. I would argue that you should do this on a case by case basis and wrap the usage of the 3rd party code within your own classes so you can pass back non-runtime exceptions.
2) Your program cannot crash and leave a stack trace for the user to see. In this case it should go around main and around any threads and event handling code. The program should probably exit when such exception occurs as well.

### Capturing exception in log message
```java
try { 
  /* ... */ 
} catch( Exception e ) {
  SomeLogger.info( "some context message", e ); // Context message is there. Also, exception object is present
}
```
printStackTrace is not a good coding practice

### Throwable vs Exception

catch(Throwable e) vs catch(Exception e)

Thowable catches really everything even ThreadDeath which gets thrown by default to stop a thread from the now deprecated Thread.stop() method. So by catching Throwable you can be sure that you'll never leave the try block without at least going through your catch block, but you should be prepared to also handle OutOfMemoryError and InternalError or StackOverflowError.

 You should generally not do that, except perhaps at the very highest "catch all" level of a thread where you want to log or otherwise handle absolutely everything that can go wrong. It would be more typical in a framework type application (for example an application server or a testing framework) where it can be running unknown code and should not be affected by anything that goes wrong with that code, as much as possible.
 
 ### When to throw exception
 
 You should handle the exception at the lowest possible level. If method can't handle the exception properly you should throw it.
 
 In general, catch at the level where you can do something useful about it. For example, user is trying to connect to some database, and it fails in Method D.

How do you want to handle it? Perhaps by putting up a dialog saying "Sorry, cannot connect to SERVER/DB" or whatever. Is is method A, B, or C that created this SERVER/DB information (say, by reading a settings file or asking for user input) and tried the connection? That is probably the method that should handle the Exception. Or at least 1 away from the method that should handle it.

