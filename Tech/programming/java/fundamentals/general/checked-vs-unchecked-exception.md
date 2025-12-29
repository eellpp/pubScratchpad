In Java, exceptions are categorized into two main types: **checked exceptions** and **unchecked exceptions**. These categories are distinguished by how they are handled at compile time and runtime.

### 1. **Checked Exceptions**

**Checked exceptions** are exceptions that are checked at **compile-time**. The compiler forces the programmer to either handle these exceptions (using `try-catch` blocks) or declare them in the method signature (using the `throws` keyword). These exceptions are typically used for conditions that a reasonable program might want to recover from or handle in a specific way.

#### Key Characteristics:
- **Compile-time checking**: The Java compiler checks for checked exceptions. If a method can throw a checked exception, it must either handle the exception or declare it using the `throws` keyword.
- **Examples**: Common examples include `IOException`, `SQLException`, `ClassNotFoundException`.
- **Handled or declared**: You must handle these exceptions using `try-catch` blocks or propagate them using the `throws` keyword in the method signature.

#### Example:
```java
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class CheckedExceptionExample {
    public static void main(String[] args) {
        try {
            // Attempt to read a file, which can throw an IOException (checked exception)
            FileInputStream file = new FileInputStream(new File("test.txt"));
        } catch (IOException e) {
            System.out.println("An error occurred while trying to read the file: " + e.getMessage());
        }
    }
}
```
In this example, `IOException` is a checked exception, so we either need to handle it with a `try-catch` block or declare it in the method signature.

### 2. **Unchecked Exceptions**

**Unchecked exceptions** are exceptions that are not checked at compile-time. They are also known as **runtime exceptions**, as they are only checked at runtime. The compiler does not require you to handle or declare them, and they typically represent programming errors, such as logical mistakes or misuse of APIs.

#### Key Characteristics:
- **Runtime checking**: These exceptions are checked only at runtime. The compiler does not force you to handle them.
- **Examples**: Common examples include `NullPointerException`, `ArrayIndexOutOfBoundsException`, `ArithmeticException`, `IllegalArgumentException`.
- **Do not require explicit handling**: While you can catch and handle these exceptions using `try-catch` blocks, you are not required to do so.

#### Example:
```java
public class UncheckedExceptionExample {
    public static void main(String[] args) {
        String str = null;
        // Attempting to call a method on a null object, which will cause a NullPointerException (unchecked exception)
        System.out.println(str.length());
    }
}
```
In this example, `NullPointerException` is an unchecked exception. The compiler does not force you to handle it, but if it occurs at runtime, the program will crash unless you catch it.

### Summary of Key Differences:

| Feature                   | **Checked Exceptions**                                   | **Unchecked Exceptions**                     |
|---------------------------|---------------------------------------------------------|----------------------------------------------|
| **Compile-time checking**  | Checked by the compiler. Must be handled or declared.   | Not checked by the compiler.                 |
| **Handled or declared**    | Must handle with `try-catch` or declare with `throws`.  | No need to handle or declare explicitly.     |
| **When to use**            | For recoverable conditions that can be handled.         | For programming errors or conditions that are not recoverable. |
| **Common examples**        | `IOException`, `SQLException`, `FileNotFoundException`. | `NullPointerException`, `IllegalArgumentException`, `ArithmeticException`. |
| **Superclass**             | `java.lang.Exception`.                                 | `java.lang.RuntimeException` (subclass of `Exception`). |

### When to Use Checked and Unchecked Exceptions:

- **Checked Exceptions**: Use checked exceptions for conditions that are external to the program and can be reasonably expected to occur and recover from, such as input/output failures, missing files, or database issues. These are exceptions that the caller might want to handle.

- **Unchecked Exceptions**: Use unchecked exceptions for programming errors or situations that are not expected to be recovered from, such as illegal arguments, null references, or array bounds violations. These are generally considered the result of a bug in the code that should be fixed.

In general, Java encourages using checked exceptions for recoverable errors and unchecked exceptions for programming mistakes.
