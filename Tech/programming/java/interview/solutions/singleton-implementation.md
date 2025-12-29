create a synchronised static method and return an object instance from it.   
synchronised insists that only thread at a time.   

## Singleton **Attempt 1 (Not Good)**

``` java
public final class ConfigService {
    private static ConfigService instance;

    private ConfigService() { }

    public static synchronized ConfigService getInstance() {
        if (instance == null) instance = new ConfigService();
        return instance;
    }
}

```
### Why `final` is Used in Singleton Pattern**

**Prevents Class Inheritance**   
The primary reason for using `final` on a singleton class is to **prevent subclassing**:

```java
public final class ConfigService { // Cannot be extended
    // ...
}

// ❌ This would cause a compilation error
class EvilSubclass extends ConfigService { // Not allowed!
    // Could create multiple instances or break singleton behavior
}
```

**Maintains Singleton Integrity**   
Without `final`, someone could:

```java
// If class wasn't final, this would be possible:
class MaliciousSubclass extends ConfigService {
    public static MaliciousSubclass createAnotherInstance() {
        // Bypass the singleton pattern
        return new MaliciousSubclass();
    }
}
```

**Problems with This Specific Singleton Implementation**

While the `final` is good, this implementation has several issues:

**2. Inefficient Synchronization**
The `synchronized` method is called every time, creating unnecessary overhead after the first initialization.


## Singleton **Attempt 2 (Not Good)**


Double-checked locking without `volatile` — subtly racy

```java
public static ConfigService getInstance() {
    if (instance == null) {                // (1) read without synchronization
        synchronized (ConfigService.class) {
            if (instance == null) {
                instance = new ConfigService();  // (2)
            }
        }
    }
    return instance;
}
```

At first glance, this looks safe because only one thread enters the `synchronized` block.
But without `volatile`, **reordering and visibility** problems occur due to the Java Memory Model.

### How it can fail

The line `instance = new ConfigService();` isn’t atomic:

1. Allocate memory.
2. **Assign the reference to `instance`.**
3. Run constructor to initialize the object.

The compiler/CPU can reorder steps 2 and 3.
So another thread (outside the synchronized block) could see a **non-null but incompletely constructed** object.

Timeline:

| Thread A                                 | Thread B                            |
| ---------------------------------------- | ----------------------------------- |
| allocates memory for ConfigService       |                                     |
| assigns reference to `instance` (step 2) | sees `instance != null`, skips sync |
| starts constructor (step 3)              | uses half-initialized object        |

➡ That’s a **data race + visibility bug** — the object escapes before it’s fully constructed.

---

###  3. Why `volatile` fixes it

If you declare:

```java
private static volatile ConfigService instance;
```

then writes to and reads from `instance` have proper **happens-before** ordering.
That prevents both reordering and stale reads, making double-checked locking safe since Java 5.


# Better Singleton Implementations

## **1. Eager Initialization (Simplest)**
```java
public final class ConfigService {
    // Created when class is loaded - thread-safe
    private static final ConfigService INSTANCE = new ConfigService();
    
    private ConfigService() { }
    
    public static ConfigService getInstance() {
        return INSTANCE; // No synchronization needed
    }
}
```

## **2. Bill Pugh Singleton (Lazy + Efficient)**
```java
public final class ConfigService {
    private ConfigService() { }
    
    // Inner helper class - lazy initialization
    private static class SingletonHelper {
        private static final ConfigService INSTANCE = new ConfigService();
    }
    
    public static ConfigService getInstance() {
        return SingletonHelper.INSTANCE; // Thread-safe & lazy
    }
}
```

## ✅ **3. Enum Singleton (Most Recommended)**
```java
public enum ConfigService {
    INSTANCE; // Guaranteed singleton by JVM
    
    // Add your methods here
    public String getConfigValue(String key) {
        return "value";
    }
}
// Usage: ConfigService.INSTANCE.getConfigValue("key");
```

## **4. Double-Checked Locking (If You Need Lazy Init)**
```java
public final class ConfigService {
    private static volatile ConfigService instance;
    
    private ConfigService() { }
    
    public static ConfigService getInstance() {
        if (instance == null) { // First check (no synchronization)
            synchronized (ConfigService.class) {
                if (instance == null) { // Second check (with synchronization)
                    instance = new ConfigService();
                }
            }
        }
        return instance;
    }
}
```

**Summary**

- **`final` class**: Prevents inheritance and maintains singleton integrity
- **Better patterns exist**: The implementation you showed has thread-safety issues
- **Recommendation**: Use **Enum** or **Bill Pugh** pattern for most singleton needs

The `final` keyword is a crucial part of a robust singleton implementation, ensuring that the singleton contract cannot be violated through inheritance.

The above class is also immutable . There is only a static getInstance method which creates the object using private constructor.   
Once the instance is created, there is no update available for it .

