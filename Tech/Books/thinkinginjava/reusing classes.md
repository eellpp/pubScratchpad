
# ✅ `final` – Explained in All Scenarios

The `final` keyword in Java means **"cannot be changed" — but the meaning depends on where it is used**.

---

##  1. `final` with **Variables / Fields**

### a) **Final Primitive Variable**

* Value **cannot be changed once assigned**.

```java
final int x = 10;
x = 20;   // ❌ Error — cannot modify final variable
```

### b) **Final Reference Variable**

* The **reference cannot change**, but the **object it points to *can* change**.

```java
final StringBuilder sb = new StringBuilder("Hello");
sb.append(" World"); // ✅ Allowed — object is mutable
sb = new StringBuilder("Hi"); // ❌ Error — cannot reassign reference
```

### c) **Blank Final Variable**

* Declared but assigned **later**, usually in a constructor.

```java
class Test {
    final int id; // blank final
    Test(int id) {
        this.id = id; // ✅ must assign here
    }
}
```

### d) **Static Final Variable (Constant)**

* Must be assigned **once** (during declaration or in static block).

```java
static final double PI = 3.14159;
```

---

##  2. `final` with **Method Parameters / Local Variables**

### a) **Final Method Parameter**

* You **cannot change the parameter** inside the method.

```java
void display(final int x) {
    x = 100; // ❌ Error — cannot assign a value to final parameter
}
```

### b) **Final Local Variable**

* Once assigned, it cannot be changed.
* Required for use in **anonymous inner classes & lambda expressions** (must be *final or effectively final*).

---

##  3. `final` with **Methods**

* A `final` method **cannot be overridden** in subclasses.

```java
class A {
    final void display() { System.out.println("A"); }
}
class B extends A {
    void display() { } // ❌ Error — cannot override
}
```

###  Why use final methods?

* For **security reasons**
* To **prevent breaking framework/library code**
* To **ensure behavior consistency**

---

##  4. `final` with **Class**

* A `final` class **cannot be inherited**.

```java
final class Animal { }
class Dog extends Animal { } // ❌ Error — cannot inherit from final class
```

Examples of final classes in Java:
✔ `java.lang.String`, `Math`, `Integer`, `LocalDate`

---

##  5. `final` with **Static Blocks or Constructors**

* `final` **cannot be used with constructors** — ❌ illegal.
* You can, however, initialize **final fields inside constructors**.

---

##  6. Final with **Immutable Class Design**

To make a class **truly immutable**, follow these rules:
✔ Class is `final` (cannot be extended)
✔ Fields are `private final`
✔ No setters
✔ Mutable objects should be deep copied

```java
final class Person {
    private final String name;
    private final List<String> hobbies;

    Person(String name, List<String> hobbies) {
        this.name = name;
        this.hobbies = new ArrayList<>(hobbies); // defensive copy
    }

    public List<String> getHobbies() {
        return new ArrayList<>(hobbies); // defensive copy
    }
}
```



##  **Gotchas & Important Nuances**

| Scenario                       | Gotcha                                                                  |
| ------------------------------ | ----------------------------------------------------------------------- |
| Final object reference         | Object is still mutable unless class is immutable                       |
| Blank final variables          | Must be assigned in **every constructor**                               |
| Final + static                 | Treated as **constant** if also primitive or String                     |
| Final method in abstract class | ✅ Allowed — method can't be overridden but class must still be extended |
| Final and private              | Methods are **implicitly final** (they **cannot** be overridden)        |
| Final class                    | No inheritance allowed — but still can **implement interfaces**         |
| Final local variables (lambda) | Must be **effectively final**                                           |

---

##  **Summary Table**

| Usage of `final`  | Meaning                                                 |
| ----------------- | ------------------------------------------------------- |
| `final variable`  | Value/reference **cannot change**                       |
| `final method`    | **Cannot be overridden**                                |
| `final class`     | **Cannot be extended/inherited**                        |
| `final parameter` | **Cannot be reassigned** inside the method              |
| `blank final`     | Assigned later, but **only once** (usually constructor) |


