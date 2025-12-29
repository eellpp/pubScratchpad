
### What is JsonNode and give a crud example
In Java, JsonNode is a class provided by the Jackson library for processing JSON data. Jackson is a popular JSON parsing and serialization library for Java.

JsonNode represents a node in a JSON tree structure. It can represent different types of JSON values, such as objects, arrays, strings, numbers, booleans, and null. JsonNode provides methods to access and manipulate JSON data in a tree-like structure.

```java
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.io.File;
import java.io.IOException;

public class JsonNodeCrudExample {
    public static void main(String[] args) {
        try {
            // Read JSON from file
            ObjectMapper mapper = new ObjectMapper();
            JsonNode rootNode = mapper.readTree(new File("data.json"));

            // Create operation
            ObjectNode newObj = mapper.createObjectNode();
            newObj.put("name", "John");
            newObj.put("age", 30);
            ((ArrayNode) rootNode).add(newObj);

            // Read operation
            for (JsonNode node : rootNode) {
                String name = node.get("name").asText();
                int age = node.get("age").asInt();
                System.out.println("Name: " + name + ", Age: " + age);
            }

            // Update operation
            JsonNode firstNode = rootNode.get(0);
            ((ObjectNode) firstNode).put("age", 31);

            // Delete operation
            if (rootNode.size() > 0) {
                ((ArrayNode) rootNode).remove(0);
            }

            // Write modified JSON back to file
            mapper.writeValue(new File("data.json"), rootNode);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

```

To get value as json string you can use 
```java
// Convert the modified JsonNode to JSON string
String jsonString = mapper.writeValueAsString(jsonNode);
```

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

### Check if string in empty or null

```java
String str = ""; // or str = null;

if (str != null && !str.isEmpty()) {
    // String is not empty
} else {
    // String is either empty or null
}

```

StringUtils class from Apache Commons Lang library provides null-safe methods for string operations. It handles null input values gracefully and avoids throwing NullPointerException.  
```java
import org.apache.commons.lang3.StringUtils;

String str = null;

if (StringUtils.isNotEmpty(str)) {
    System.out.println("String is not empty.");
} else {
    System.out.println("String is either empty or null.");
}

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
