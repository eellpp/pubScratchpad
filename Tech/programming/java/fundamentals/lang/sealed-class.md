# ✅ What Are Sealed Classes / Interfaces?

A **sealed class or interface** restricts which other classes or interfaces can extend or implement it.

Before sealed types:

* Any external class could extend yours
* Hard to guarantee safe, closed hierarchies
* Harder to reason about polymorphism
* `switch` / pattern matching could not be exhaustive

**Sealed types solve this** by letting you declare:

> “Only these specific types are allowed to extend/implement me.”

---

# 📌 Version History

| Java Version | Status                           |
| ------------ | -------------------------------- |
| **Java 15**  | Preview                          |
| **Java 16**  | 2nd Preview                      |
| **Java 17**  | **Finalized (Standard Feature)** |

So sealed classes are **fully production-ready since Java 17 (LTS)**.

---

# 🧱 Basic Syntax

```java
public sealed class Shape permits Circle, Rectangle, Square {
}
```

Each permitted subclass **must** declare exactly one of:

```
final
sealed
non-sealed
```

Example permitted types:

```java
public final class Circle extends Shape {}
public sealed class Rectangle extends Shape permits FilledRectangle, EmptyRectangle {}
public non-sealed class Square extends Shape {}
```

✔ `final`

> Cannot be extended further

✔ `sealed`

> Continues restricting further inheritance — must declare its own permits list

✔ `non-sealed`

> Removes restriction; behaves like normal open inheritance again

---

# 🔍 Example with Behavior

```java
public sealed interface Shape permits Circle, Rectangle, Square {
    double area();
}

public final class Circle implements Shape {
    double r;
    public Circle(double r) { this.r = r; }

    public double area() {
        return Math.PI * r * r;
    }
}

public final class Rectangle implements Shape {
    double w, h;
    public Rectangle(double w, double h) { this.w = w; this.h = h; }

    public double area() { return w * h; }
}

public non-sealed class Square implements Shape {
    double s;
    public Square(double s) { this.s = s; }

    public double area() { return s * s; }
}
```

---

# ⚙️ Rules You Must Follow

### 1️⃣ Subclasses must declare modifier:

* `final`
* `sealed`
* `non-sealed`

### 2️⃣ All permitted classes must:

* Be in the **same module**, OR
* If no modules, **same package**

### 3️⃣ If using `permits`, you **must list all allowed types**

Compiler enforces the closed hierarchy.

---

# 🎯 Why Sealed Types Exist

They enable **controlled inheritance** and improve:

* Security → prevent unintended subclassing
* Maintainability → known inheritance tree
* Reasoning → sealed hierarchies easier to understand
* Pattern Matching → compiler can verify exhaustiveness

---

# 🧠 Sealed Types + Pattern Matching `switch`

### (Java 21 — finalized)

Perfect match.

```java
static String describe(Shape shape) {
    return switch (shape) {
        case Circle c -> "Circle area = " + c.area();
        case Rectangle r -> "Rectangle area = " + r.area();
        case Square s -> "Square area = " + s.area();
    };
}
```

Because `Shape` is sealed, compiler knows all subtypes.
✔ **No `default` case needed**
✔ Compiler error if you miss a case
✔ Safer than traditional polymorphism dispatch

---

# 🧩 Sealed Interfaces vs Sealed Classes

Both work similarly, but some differences in spirit:

### Sealed Interface

```java
public sealed interface Vehicle permits Car, Truck, Bike {}
```

Used to:

* Define roles / capabilities
* Control API contracts

### Sealed Class

```java
public sealed class Vehicle permits Car, Truck {}
```

Used when:

* Inheritance is structural
* You want controlled OOP hierarchy

---

# 🔥 Common Real-World Use Cases

### ✔ Domain Modeling

```java
sealed interface Payment permits CardPayment, UpiPayment, NetBanking {}
final class CardPayment implements Payment {}
final class UpiPayment implements Payment {}
final class NetBanking implements Payment {}
```

Useful for:

* Finance systems
* Behavioral modeling
* Protocol message types

---

### ✔ State Machines

```java
sealed interface ConnectionState
 permits Connected, Disconnected, Connecting {}

final class Connected implements ConnectionState {}
final class Connecting implements ConnectionState {}
final class Disconnected implements ConnectionState {}
```

Now switches are safe and exhaustive.

---

### ✔ Error / Result Wrappers

```java
sealed interface Result permits Success, Failure {}

record Success(Object value) implements Result {}
record Failure(String message) implements Result {}
```

Common in:

* Functional programming inspired designs
* API responses
* async workflows
* validation systems

---

# ⚠️ When NOT to Use Sealed Classes

Avoid sealed classes if:

❌ You want extension flexibility
❌ Your library is meant for 3rd-party inheritance
❌ You don’t know future subclassing requirements
❌ You’re already using final classes everywhere (no benefit)
❌ You want unrestricted polymorphism

---

# 🧑‍💻 Best Practices

### ✔ Prefer sealing for closed domain hierarchies

When domain meaningfully has **finite types**, seal it.

### ✔ Use with pattern matching

They are designed for modern Java patterns.

### ✔ Prefer `sealed interface + record` combination

This creates extremely clean data models:

```java
sealed interface Command permits Start, Stop {}

record Start() implements Command {}
record Stop() implements Command {}
```

### ✔ Be intentional

Don’t seal “just because it exists” — seal because control matters.

---

# 🗂 Quick Summary

| Feature                | Meaning                        |
| ---------------------- | ------------------------------ |
| `sealed`               | restricts subclassing          |
| `permits`              | declares allowed subclasses    |
| `final`                | subclass cannot extend further |
| `non-sealed`           | re-opens inheritance           |
| Works Best With        | pattern matching + switch      |
| Production Ready Since | **Java 17**                    |

---

# 🎯 Final Takeaway

Sealed classes/interfaces give Java:

* safer polymorphism
* closed domain modeling
* more expressive APIs
* compiler-verified safety
* excellent synergy with switch + pattern matching

They bring Java closer to modern type-safe languages like Kotlin, Scala, and Rust — while staying Java.
