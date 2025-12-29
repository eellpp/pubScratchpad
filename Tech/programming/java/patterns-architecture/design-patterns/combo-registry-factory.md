I want to create a factory for Currency objects where each Currency class can register itself with the factory at runtime. This approach eliminates the need for the factory to maintain a predefined list of all possible Currency classes. Clients can request an instance of a specific Currency, and the factory will check if the requested type has been registered. If it has, the factory will create and return a new instance of that Currency. 

Implementation using a combination of factory and registry pattern

The scenario you've described can be effectively handled using a combination of the **Factory Method** pattern and the **Registry** pattern. Here's how you can design it:

### 1. **Factory Method Pattern:**
   - The **Factory Method** pattern allows a class to delegate the responsibility of creating objects to subclasses or other classes. In your case, the factory will create instances of `Currency` classes.

### 2. **Registry Pattern:**
   - The **Registry** pattern is used to keep track of instances or classes, allowing them to register themselves at runtime. This pattern allows dynamic registration and retrieval of `Currency` classes, without the factory needing to know all the possible `Currency` types in advance.

### Design Implementation:

#### Currency Interface:
```java
public interface Currency {
    void process();
}
```

#### Concrete Currency:
```java
public class CurrencyA implements Currency {
    static {
        CurrencyFactory.register("CurrencyA", CurrencyA.class);
    }

    @Override
    public void process() {
        System.out.println("Processing with CurrencyA");
    }
}

public class CurrencyB implements Currency {
    static {
        CurrencyFactory.register("CurrencyB", CurrencyB.class);
    }

    @Override
    public void process() {
        System.out.println("Processing with CurrencyB");
    }
}
```

#### Currency Factory with Registry:
```java
import java.util.HashMap;
import java.util.Map;

public class CurrencyFactory {
    private static Map<String, Class<? extends Currency>> registeredPreProcessors = new HashMap<>();

    // Method to register Currency classes
    public static void register(String name, Class<? extends Currency> preProcessorClass) {
        registeredPreProcessors.put(name, preProcessorClass);
    }

    // Method to create Currency instances
    public static Currency create(String name) {
        Class<? extends Currency> preProcessorClass = registeredPreProcessors.get(name);
        if (preProcessorClass != null) {
            try {
                return preProcessorClass.getDeclaredConstructor().newInstance();
            } catch (Exception e) {
                throw new RuntimeException("Error creating instance of Currency: " + name, e);
            }
        }
        throw new IllegalArgumentException("Currency not registered: " + name);
    }
}
```

#### Usage:
```java
public class Main {
    public static void main(String[] args) {
        Currency currencyA = CurrencyFactory.create("CurrencyA");
        currencyA.process();

        Currency currencyB = CurrencyFactory.create("CurrencyB");
        currencyB.process();

        // This will throw an exception since "PreProcessorC" is not registered
        // Currency currencyB = CurrencyFactory.create("currencyC");
    }
}
```

### Explanation:

1. **Currency Interface:**
   - The `Currency` interface defines a common method `process()` that all concrete `Currency` classes must implement.

2. **Concrete Currency:**
   - `CurrencyA` and `CurrencyB` are concrete implementations of the `Currency` interface.
   - Each `Currency` class registers itself with the `CurrencyFactory` at runtime using a static block. This ensures that whenever the class is loaded, it registers itself automatically.

3. **Currency Factory:**
   - The `CurrencyFactory` uses a `Map` to keep track of registered `Currency` classes.
   - The `register` method allows `Currency` classes to register themselves with a unique name.
   - The `create` method checks if the requested `Currency` is registered. If it is, the factory creates a new instance of it using reflection and returns it to the client.

4. **Usage:**
   - Clients can request specific `Currency` instances from the factory by name. The factory will create and return the appropriate instance if it's registered.

### Design Patterns Used:

1. **Factory Method Pattern:**
   - The `create` method in the factory encapsulates the logic of object creation, which allows for easy extension and flexibility.

2. **Registry Pattern:**
   - The `CurrencyFactory` acts as a registry that stores the associations between names and `Currency` classes, allowing dynamic registration and retrieval at runtime.

### Benefits:

- **Flexibility:** New `Currency` classes can be added without modifying the factory. They just need to register themselves.
- **Decoupling:** The factory doesn’t need to know about all possible `Currency` classes ahead of time, promoting loose coupling.
- **Extensibility:** This design easily supports adding new `Currency` types without changing existing code.

This approach provides a scalable and maintainable solution for managing dynamically registered classes and creating their instances on demand.
