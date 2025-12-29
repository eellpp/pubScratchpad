# ✅ What is a Switch *Expression*?

Before Java 14, `switch` was **only a statement** — it *performed actions* but didn’t return a value.

**Since Java 14 (Finalized)**
`switch` can now also be used as an **expression that produces a value**, similar to Kotlin/Scala.

✔ Cleaner
✔ No accidental fall-through
✔ Expression form optional but powerful
✔ Works great with pattern matching and sealed hierarchies

> **Intro timeline**

* Java 12 → preview
* Java 13 → 2nd preview
* **Java 14 → Standard & stable**

---

# 1️⃣ Two Styles: Statement vs Expression

### Old (statement style)

```java
String result;
switch(value) {
    case 1: result = "one"; break;
    case 2: result = "two"; break;
    default: result = "many";
}
```

Problems:

* Must remember `break`
* Code is verbose
* Easy accidental fall-through bugs

---

### New (expression style)

```java
String result = switch (value) {
    case 1 -> "one";
    case 2 -> "two";
    default -> "many";
};
```

Notes:

* Uses **`->` arrow rules**
* No `break`
* Produces a value
* Must be **exhaustive**

---

# 2️⃣ Arrow Rules (→)

Use when each case just **returns a value or runs one expression**:

```java
String type = switch (status) {
    case 200 -> "SUCCESS";
    case 400 -> "BAD REQUEST";
    case 500 -> "ERROR";
    default -> "UNKNOWN";
};
```

Multiple labels allowed:

```java
String description = switch(code) {
    case 200, 201 -> "OK";
    case 400, 404 -> "CLIENT ERROR";
    default -> "OTHER";
};
```

---

# 3️⃣ Block Cases + `yield`

If a case needs **multiple statements**, use a block `{}` and `yield`.

```java
String result = switch(value) {
    case 1 -> "one";
    case 2 -> {
        log.info("Handling 2");
        yield "two";     // return value of this case
    }
    default -> "other";
};
```

`yield` replaces `return` inside switch expressions.

---

# 4️⃣ Switch Expressions are Exhaustive

Meaning:
➡ Every possible input must be handled.

Example:

```java
enum Color { RED, BLUE, GREEN }

String name = switch(color) {
    case RED -> "red";
    case BLUE -> "blue";
    case GREEN -> "green";
};
```

✔ **No `default` needed** because enum is known
❌ Compiler error if you miss one case

Great for catching production bugs early.

---

# 5️⃣ Fall-Through? Gone (mostly)

Classic switch had this trap:

```java
switch(x) {
    case 1:
    case 2:
        doSomething();
}
```

Arrow switches **never fall through**
Old syntax can still intentionally fall through (statement style only).

---

# 6️⃣ Return values & Side Effects

Since it’s an expression:

```java
return switch(role) {
    case ADMIN -> privileges.all();
    case USER -> privileges.limited();
    default -> privileges.none();
};
```

Or assign:

```java
var msg = switch(lang) {
    case "en" -> "Hello";
    case "fr" -> "Bonjour";
    default -> "Hi";
};
```

---

# 7️⃣ Switch + Pattern Matching (Java 21+)

> **Finalized in Java 21**
> Pattern matching lets switch match **types**, not just values.

```java
static String format(Object obj) {
    return switch (obj) {
        case Integer i -> "int: " + i;
        case String s -> "string: " + s.toUpperCase();
        case null -> "null value";
        default -> "other";
    };
}
```

Benefits:

* No more `instanceof` + cast chains
* Safer exhaustive logic
* Works brilliantly with sealed types

---

# 8️⃣ Switch + Sealed Hierarchies (Perfect Pair)

Assume:

```java
sealed interface Shape permits Circle, Rectangle, Square {}

record Circle(double r) implements Shape {}
record Rectangle(double w, double h) implements Shape {}
record Square(double s) implements Shape {}
```

Now:

```java
double area = switch (shape) {
    case Circle c -> Math.PI * c.r() * c.r();
    case Rectangle r -> r.w() * r.h();
    case Square s -> s.s() * s.s();
};
```

✔ Compiler enforces exhaustiveness
✔ No chance of missing subtype

---

# 9️⃣ Handling `null`

Normally `switch(value)` throws NPE if `value == null`.

Pattern matching switch (Java 21) allows explicit handling:

```java
String r = switch (value) {
    case null -> "null!";
    default -> value.toString();
};
```

---

# 🔟 Common Real-World Use Cases

### ✔ Status / Result Mapping

```java
HttpStatus status = ...
String msg = switch(status) {
    case OK -> "Success";
    case NOT_FOUND -> "Missing";
    case INTERNAL_SERVER_ERROR -> "Server error";
};
```

---

### ✔ Business Rules

```java
double discount = switch(customer.type()) {
    case GOLD -> 0.30;
    case SILVER -> 0.20;
    case REGULAR -> 0.05;
};
```

---

### ✔ Logging Levels

```java
LogLevel l = ...
String text = switch(l) {
    case INFO -> "Information";
    case WARN -> "Warning";
    case ERROR -> "Critical!";
};
```

---

### ✔ Replace if-else ladders

Before:

```java
if(a == 1) ...
else if(a == 2) ...
else if(a == 3) ...
```

After:

```java
var result = switch(a) {
    case 1 -> ...
    case 2 -> ...
    case 3 -> ...
    default -> ...
};
```

---

# ⚠️ When NOT to use switch expressions

Avoid when:

❌ extremely complex logic per case
❌ heavy side effects + state updates
❌ performance-critical numeric loops (no difference but clarity matters)
❌ if you need intentional fall-through logic

Prefer readability over cleverness.

---

# 🧠 Best Practices

✔ Prefer arrow syntax `case X ->`
✔ Prefer expressions instead of statements when meaningful
✔ Make enums exhaustive (no default if possible)
✔ Use `yield` only when you really need a block
✔ Use with **sealed types + pattern matching** where applicable
✔ Avoid mixing complex side-effects inside cases

---

# 🗂 Version Summary

| Version     | Feature                                           |
| ----------- | ------------------------------------------------- |
| Java 12     | Switch expressions (preview)                      |
| Java 13     | Enhanced preview                                  |
| **Java 14** | **Switch expressions finalized**                  |
| Java 17     | Recommended in LTS production                     |
| Java 21     | Pattern-matching switch finalized, null supported |

---

# 🎯 Summary

Switch expressions:

* Make switch safer
* Eliminate fall-through bugs
* Reduce boilerplate
* Enable functional style
* Work fantastically with enums, sealed types, pattern matching

They are now a **first-class control + expression tool** in modern Java.

