## 1. What is an interface?

An **interface** is a contract: it describes *what* a type can do, not *how* it does it.

```java
public interface PaymentProcessor {
    void process(PaymentRequest request);
}
```

Any class that `implements PaymentProcessor` must provide an implementation for `process`.

Key points:

* A class can **implement multiple interfaces**.
* Interfaces support **polymorphism**: you can depend on the interface type instead of concrete classes.
* Since Java 8+, interfaces can contain behavior (default, static methods), not just abstract method declarations. ([DigitalOcean][1])

---

## 2. Members allowed in an interface (Java 17 view)

In Java 17+, an interface can contain: ([JavaTechOnline][2])

1. **Constant fields** (implicitly `public static final`)
2. **Abstract methods** (implicitly `public abstract`)
3. **Default methods** (`default`) – *Java 8*
4. **Static methods** – *Java 8*
5. **Private & private static methods** – *Java 9*
6. **Nested types** (classes, interfaces, enums, records)
7. **Sealed interfaces** (with `sealed` / `non-sealed`) – *preview Java 15/16, final Java 17*

We’ll go through these.

---

## 3. Methods in interfaces

### 3.1 Abstract methods (classic)

```java
public interface Shape {
    double area();
    double perimeter();
}
```

* Implementing classes **must** implement all abstract methods (unless they’re abstract themselves).

---

### 3.2 Default methods – **since Java 8**

> Purpose: add new behavior to interfaces **without breaking existing implementations**. ([Oracle Docs][3])

```java
public interface Shape {
    double area();

    default String describe() {
        return "Area = " + area();
    }
}
```

* Implementing classes **inherit** the default implementation.
* They **can override** it if needed.

**Conflict rule:** if a class implements multiple interfaces with the same default method:

```java
interface A {
    default void hello() { System.out.println("A"); }
}
interface B {
    default void hello() { System.out.println("B"); }
}

class C implements A, B {
    @Override
    public void hello() {
        A.super.hello(); // or B.super.hello();
    }
}
```

You must override and choose.

---

### 3.3 Static methods – **since Java 8**

```java
public interface StringUtils {
    static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
```

* Called via `StringUtils.isBlank("  ")`, not through an instance.
* Useful for **helper/util methods** closely related to the interface.

---

### 3.4 Private & private static methods – **since Java 9**

> Added so multiple default/static methods can share a common helper without exposing it publicly. ([HowToDoInJava][4])

```java
public interface HtmlRenderer {

    default String renderBold(String text) {
        return wrap("b", text);
    }

    default String renderItalic(String text) {
        return wrap("i", text);
    }

    private String wrap(String tag, String text) {   // Java 9+
        return "<" + tag + ">" + text + "</" + tag + ">";
    }

    static String renderMonospace(String text) {
        return wrapStatic("code", text);
    }

    private static String wrapStatic(String tag, String text) { // Java 9+
        return "<" + tag + ">" + text + "</" + tag + ">";
    }
}
```

* `private` and `private static` methods are **only callable inside the interface** (from default/static methods).
* They’re not visible to implementors.

---

## 4. Fields in interfaces

```java
public interface ConfigKeys {
    String BASE_URL = "https://api.example.com"; // implicitly public static final
}
```

* All fields are implicitly `public static final`.
* They must be initialized at declaration.
* In idiomatic modern code, we usually put constants into

  * a dedicated `final class` (e.g. `Config`), or
  * `enum`s,
    rather than dumping many constants into interfaces.

---

## 5. Inheritance: `extends` + multiple inheritance

### 5.1 Interfaces extending interfaces

```java
public interface Identifiable {
    long id();
}

public interface Timestamped {
    Instant createdAt();
}

public interface Entity extends Identifiable, Timestamped {
    // inherits both
}
```

* Interfaces can `extends` multiple other interfaces.
* Classes that implement `Entity` must provide all inherited methods.

### 5.2 Classes implementing multiple interfaces

```java
public class User implements Identifiable, Timestamped {
    private final long id;
    private final Instant createdAt;

    // implement both
}
```

This is how Java provides **multiple inheritance of type** (but not multiple inheritance of implementation).

---

## 6. Functional interfaces

A **functional interface** has exactly one abstract method. ([blog.masteringbackend.com][5])

```java
@FunctionalInterface
public interface Converter<F, T> {
    T convert(F from);
}
```

* Can be used with **lambdas** and **method references**:

```java
Converter<String, Integer> toInt = Integer::parseInt;
Integer x = toInt.convert("42");
```

* `@FunctionalInterface` is optional but recommended; the compiler then enforces the “single abstract method” rule.

Common JDK functional interfaces (in `java.util.function`):

* `Supplier<T>`, `Consumer<T>`, `Function<T,R>`, `Predicate<T>`, `BiFunction`, `UnaryOperator`, `BinaryOperator`, etc.

---

## 7. Sealed interfaces – **preview 15/16 → final in Java 17**

> Sealed interfaces restrict which classes can implement them, giving you **controlled inheritance**. ([Baeldung on Kotlin][6])

### 7.1 Basic example

```java
public sealed interface Shape permits Circle, Rectangle, Triangle {
    double area();
}

public final class Circle implements Shape {
    double radius;
    public double area() { return Math.PI * radius * radius; }
}

public final class Rectangle implements Shape {
    double w, h;
    public double area() { return w * h; }
}

public non-sealed class Triangle implements Shape {
    double base, height;
    public double area() { return base * height / 2.0; }
}
```

* `sealed` on the interface.
* `permits` lists the allowed implementors.
* Implementing types must be `final`, `sealed` or `non-sealed`.

This plays very nicely with **pattern matching for `switch`** (Java 17+):

```java
static String describe(Shape shape) {
    return switch (shape) {
        case Circle c    -> "Circle: " + c.area();
        case Rectangle r -> "Rectangle: " + r.area();
        case Triangle t  -> "Triangle: " + t.area();
    };
}
```

Because all subtypes are known, the compiler can **exhaustively check** the `switch`.

---

## 8. Nested types inside interfaces

You can define **nested classes, interfaces, enums, records** inside an interface.

```java
public interface HttpClient {

    Response execute(Request request);

    record Request(String url, Map<String, String> headers) {}

    record Response(int status, String body) {}
}
```

Use cases:

* Group small data carriers (`Request`, `Response`) tightly with the interface.
* Hide helper types if you declare them `private` (only allowed for classes, not interfaces).

---

## 9. Interface vs abstract class (when to use what)

### Use an **interface** when:

* You’re defining a **role/contract** that many unrelated classes can adopt.

  * e.g. `Comparable`, `Runnable`, `Serializable`, `Predicate<T>`.
* You want **multiple inheritance of behavior**:

  * A class can implement multiple interfaces but extend only one class.
* You’re exposing a **SPI/API surface**:

  * lib users implement your interface; you keep freedom to change your implementations.
* With sealed interfaces: you want a **closed polymorphic hierarchy** that still allows multiple implementing classes.

### Use an **abstract class** when:

* You need **state** (fields) and protected helpers as part of the base type.
* You want to provide **rich base behavior** with shared implementation and avoid duplication.
* You expect subclasses to be **tightly related** and often in the same module/package.

---

## 10. Version summary for interface-related features

Here’s a quick **timeline**:

| Java Version | Interface feature                                                             |
| ------------ | ----------------------------------------------------------------------------- |
| **Java 8**   | `default` methods, `static` methods, functional interfaces ([Oracle Docs][3]) |
| **Java 9**   | `private` and `private static` methods in interfaces ([HowToDoInJava][4])     |
| **Java 15**  | Sealed interfaces *(preview)* ([GeeksforGeeks][7])                            |
| **Java 16**  | Sealed types *(2nd preview)* ([hyperskill.org][8])                            |
| **Java 17**  | Sealed classes & interfaces **finalized** (JEP 409) ([Baeldung on Kotlin][6]) |

No fundamentally new interface-specific keywords were added after 17 (Java 17–25 mainly refine pattern matching, records, etc., which *work with* interfaces but don’t change the interface syntax itself).

---

## 11. Practical tips for Java 17+ projects

* Prefer **small, focused interfaces** (Single Responsibility).
* Use **default methods** for:

  * Backward compatibility
  * Convenience methods built on top of the core abstract API.
* Use **private interface methods (Java 9+)** to keep default/static method code DRY while hiding implementation details.
* Use **sealed interfaces** when:

  * You want exhaustive pattern matching over a fixed set of implementations.
  * You want to **prevent third-party libraries** from creating new implementations.
* Use `@FunctionalInterface` when the interface is meant for lambdas — it acts as good documentation and compiler check.

---

[1]: https://www.digitalocean.com/community/tutorials/java-8-interface-changes-static-method-default-method?utm_source=chatgpt.com "Java 8 Interface Changes - static method, default method"
[2]: https://javatechonline.com/java-interface/?utm_source=chatgpt.com "Master The Power Of Java Interface"
[3]: https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html?utm_source=chatgpt.com "Default Methods - Interfaces and Inheritance"
[4]: https://howtodoinjava.com/java9/java9-private-interface-methods/?utm_source=chatgpt.com "Private Methods in Interface - Java 9"
[5]: https://blog.masteringbackend.com/java-8-features-explained-default-methods-static-methods-and-functional-interfaces?utm_source=chatgpt.com "Java 8 Features Explained-Default Methods, Static ..."
[6]: https://www.baeldung.com/java-sealed-classes-interfaces?utm_source=chatgpt.com "Sealed Classes and Interfaces in Java"
[7]: https://www.geeksforgeeks.org/java/evolution-interface-java/?utm_source=chatgpt.com "Evolution of Interface in Java"
[8]: https://hyperskill.org/university/java/sealed-classes-and-interfaces-in-java?utm_source=chatgpt.com "Sealed Classes and Interfaces in Java"
