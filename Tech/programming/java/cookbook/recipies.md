
### Brace based brace-based string extrapolation
In Log4j, brace-based string extrapolation is achieved using the {} placeholders in log messages. Log4j supports a wide range of variable types and does not impose any specific limits on the count of variables that can be passed.

You can include as many placeholders as needed in your log messages and provide corresponding values for each placeholder when logging. Log4j will replace the placeholders with the actual values at runtime.

Here's an example of brace-based string extrapolation in Log4j:

```java
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class ExampleClass {
    private static final Logger LOGGER = LogManager.getLogger(ExampleClass.class);

    public void logMessage(String name, int count) {
        LOGGER.info("Processing {} with count {}", name, count);
    }
}

Note:
 SLF4J is a logging facade and does not provide its own logging implementation. Therefore, it's the actual logging implementation (e.g., Logback, Log4j) that determines the specific behavior and limitations of brace-based string extrapolation in your application.  

Why use SLF4J?   
Overall, using SLF4J as a logging facade provides a level of abstraction, flexibility, and compatibility that makes your code more portable and easier to maintain. It helps decouple your application from the specifics of a logging implementation, enabling you to switch logging frameworks with minimal code changes and take advantage of the features and optimizations provided by different logging implementations.
```

### Java data structures
arrays, list, maps,set,queue
- initialization
- various implementations

### Iterables and enumerations

### Stream operation

### Exception handling

### Generics


### OOPs and common design patterns 
- interface, abstract class
- basic : singleton, factory,facade,iterator
- decorator, observer, strategy

http://www.thedevpiece.com/design-patterns-that-every-developer-should-know/

### date time operation
- timestamp conversion
- timezone conversion

### Testing
- mock testing

### Database operation
- JDBC template
- model, view, Controller pattern
- Hibernate

### Threading
- parallel processing and concurrancy

## IO

- Buffered Reader/Writer
- scanner
- inputStreamReader

### Reading and writing files

### Reading aand writing json

### Reading properties file

### Reading resource files

### Reading csv files
csv files into into objects

### text formats : utf conversion
