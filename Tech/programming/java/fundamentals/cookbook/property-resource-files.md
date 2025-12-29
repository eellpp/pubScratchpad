
### Reading from Application properties file

**flashcards** that capture the key concepts from the document 

### Flashcards on Property Resource Files

| **Question**                                                             | **Answer**                                   |
|--------------------------------------------------------------------------|----------------------------------------------|
| What class is typically used to read properties files in Java?            | `java.util.Properties`                       |
| How do you load a properties file in Java?                                | Use `Properties.load(InputStream)`           |
| What method is used to retrieve a property's value?                       | `getProperty(String key)`                    |
| How do you save properties to a file?                                     | `store(OutputStream out, String comments)`   |
| How can you load a properties file from the classpath?                    | `getClassLoader().getResourceAsStream()`     |
| How do you handle missing properties files?                               | Check for `null` on the input stream before loading |
| What method in `Properties` allows setting default values for a property? | `getProperty(String key, String defaultValue)`|
| What Spring annotation allows injecting properties into fields?           | `@Value`                                    |
| How do you write properties back to a file?                               | Use `Properties.store()`                     |
| What exception must be handled when loading properties?                   | `IOException`                               |

These flashcards capture the essence of working with property files in Java, including reading, writing, and handling them effectively.

To read from an `application.properties` file in a Java application, you can use several approaches, depending on your environment and framework. Here are some common methods:

### 1. **Using Spring Boot's `@Value` Annotation**
If you are using **Spring Boot**, the easiest way to read properties from `application.properties` is by using the `@Value` annotation.

```properties
# application.properties
app.name=MyApplication
app.version=1.0.0
```

```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class AppProperties {

    @Value("${app.name}")
    private String appName;

    @Value("${app.version}")
    private String appVersion;

    public String getAppName() {
        return appName;
    }

    public String getAppVersion() {
        return appVersion;
    }
}
```
### 2. **Using Spring Boot's `@ConfigurationProperties`**
This is another Spring Boot approach, useful for binding a group of related properties into a POJO.

```properties
# application.properties
app.name=MyApplication
app.version=1.0.0
```

```java
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "app")
public class AppConfig {
    
    private String name;
    private String version;

    // Getters and setters

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }
}
```

### 3. **Using `java.util.Properties` Class**
For non-Spring applications, you can use the `Properties` class to load and read from `application.properties`.

```properties
# application.properties
app.name=MyApplication
app.version=1.0.0
```

```java
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ApplicationProperties {

    public static void main(String[] args) {
        Properties properties = new Properties();
        
        try (InputStream input = ApplicationProperties.class.getClassLoader().getResourceAsStream("application.properties")) {
            
            if (input == null) {
                System.out.println("Sorry, unable to find application.properties");
                return;
            }

            // Load the properties file
            properties.load(input);

            // Get property values
            String appName = properties.getProperty("app.name");
            String appVersion = properties.getProperty("app.version");

            System.out.println("App Name: " + appName);
            System.out.println("App Version: " + appVersion);

        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
}
```

### 4. **Using Apache Commons Configuration**
If you prefer an external library, you can use **Apache Commons Configuration** to manage properties files.

1. Add the dependency:
```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-configuration2</artifactId>
    <version>2.7</version>
</dependency>
```

2. Read the properties:
```properties
# application.properties
app.name=MyApplication
app.version=1.0.0
```

```java
import org.apache.commons.configuration2.Configuration;
import org.apache.commons.configuration2.builder.fluent.Configurations;
import java.io.File;

public class ApacheConfigReader {

    public static void main(String[] args) {
        try {
            Configurations configs = new Configurations();
            Configuration config = configs.properties(new File("application.properties"));
            
            String appName = config.getString("app.name");
            String appVersion = config.getString("app.version");

            System.out.println("App Name: " + appName);
            System.out.println("App Version: " + appVersion);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### Summary
- **Spring Boot**: Use `@Value` or `@ConfigurationProperties` for easy binding.
- **Java SE**: Use `java.util.Properties` to manually load and read properties files.
- **Apache Commons Configuration**: For more advanced configuration management with external libraries.

These methods provide flexibility depending on your use case, with Spring Boot offering the most seamless integration for modern applications.

```java

Properties prop = new Properties();
prop.load(Classname.class.getClassLoader().getResourceAsStream("foo.properties"));
String value = prop.getProperty("key")

```

### Setting system properties with -D option
A JVM runs with a number of system properties. You can configure system properties by using the -D option, pronounced with an upper case 'D'

java -Dfile.encoding=utf-8

You can then grab the value programatically as

System.getProperty("file.encoding"); 

