# ✅ What is the Java Module System?

Introduced in **Java 9**, the Java Platform Module System (JPMS) breaks the JDK and user code into **strongly encapsulated modules**.

Before modules:

* Everything was on the classpath
* “Classpath hell” (ordering matters, collisions, duplicates)
* No strong encapsulation — reflection could access everything
* Runtime errors when dependencies missing
* JDK was a single giant monolith

With modules:

* Explicit **dependencies**
* Explicit **exports**
* Strong encapsulation by default
* Smaller runtime runtime images (`jlink`)
* Better security and maintainability

✔ Think of it as **a stricter, more powerful replacement for the classpath** (though classpath still works).

---

# 🧠 Core Concepts

## 1️⃣ A module is a logical unit of code

It contains:

* A `module-info.java` descriptor file
* Packages (normal Java code)
* A clear dependency declaration

---

## 2️⃣ `module-info.java`

At the root of your source:

```
src/
 └── com.example.app/
       ├── module-info.java
       └── com/example/app/...
```

Example:

```java
module com.example.app {
    requires com.example.service;
    exports com.example.app.api;
}
```

This tells Java:

* This module’s name is `com.example.app`
* It depends on module `com.example.service`
* Only package `com.example.app.api` is accessible to others

Anything else stays encapsulated.

---

## 3️⃣ `exports`

Controls what other modules can see.

```java
module com.example.service {
    exports com.example.service.api;
}
```

* Only `service.api` is publicly accessible
* Internal packages remain hidden

Encapsulation becomes **real**, not “convention”.

---

## 4️⃣ `requires`

Declares dependencies (instead of classpath guessing)

```java
module com.example.app {
    requires com.example.service;
}
```

If missing?
→ compile-time error
→ runtime error

So failures happen early 👍

---

## 5️⃣ `requires transitive`

Allows dependency “re-exporting”

Example:

```
App → uses API → API uses Core
```

If `app` uses API, and API uses Core, should app need to `requires core` too?

If API says:

```java
module api {
    requires transitive core;
}
```

Then `app` automatically gets `core`.

This is useful for layered designs.

---

## 6️⃣ `opens` and reflection

Default modules are **not** reflection-friendly.

Frameworks like Spring / Hibernate use reflection.
So you need:

```java
module com.example.model {
    opens com.example.model.entities;
}
```

OR globally open:

```java
open module com.example.model {
    // everything open for reflection
}
```

Use only when required — preserves security and encapsulation.

---

# 🧱 Putting It All Together — Example Project

Let’s build a 3-module application:

```
com.example.api
com.example.service
com.example.app
```

---

### com.example.api

```
src/com.example.api/module-info.java
```

```java
module com.example.api {
    exports com.example.api;
}
```

```
src/com.example.api/com/example/api/GreetingService.java
```

```java
package com.example.api;

public interface GreetingService {
    String greet(String name);
}
```

---

### com.example.service

```
src/com.example.service/module-info.java
```

```java
module com.example.service {
    requires com.example.api;
    exports com.example.service;
}
```

```
src/com.example.service/com/example/service/GreetingServiceImpl.java
```

```java
package com.example.service;

import com.example.api.GreetingService;

public class GreetingServiceImpl implements GreetingService {
    public String greet(String name) {
        return "Hello, " + name;
    }
}
```

---

### com.example.app

```
src/com.example.app/module-info.java
```

```java
module com.example.app {
    requires com.example.api;
    requires com.example.service;
}
```

```
src/com.example.app/com/example/app/Main.java
```

```java
package com.example.app;

import com.example.service.GreetingServiceImpl;

public class Main {
    public static void main(String[] args) {
        var g = new GreetingServiceImpl();
        System.out.println(g.greet("World"));
    }
}
```

---

# ▶ Running a Modular App

Compile modules:

```bash
javac -d out \
 src/com.example.api/module-info.java src/com.example.api/... \
 src/com.example.service/module-info.java src/com.example.service/... \
 src/com.example.app/module-info.java src/com.example.app/...
```

Run:

```bash
java --module-path out --module com.example.app/com.example.app.Main
```

---

# 🔦 Modules & Libraries

### JDK Module Names

Not jar names — module names like:

```
java.base
java.sql
java.xml
java.logging
java.desktop
```

Every app automatically gets `java.base`.

---

### Automatic Modules

Legacy jars without module info?
Java treats them as **automatic modules**

* Works on module path
* Gets auto-generated name
* Everything exported

Good transition tool, not ideal final state.

---

### Unnamed Module

Anything still on classpath = unnamed module.
Old world still works.

---

# 🧩 JPMS with Spring, Hibernate, Jackson

Real world note:

* **Spring Boot apps are usually NOT modularized today**
* Many frameworks use reflection heavily
* JPMS works, but requires `opens`
* Most teams modularize *libraries* not *apps*

Example for Hibernate entity package:

```java
module com.example.persistence {
    requires java.persistence;
    opens com.example.persistence.entities to org.hibernate.orm.core;
}
```

---

# 🛠 Migration Strategy

### Step 1 – Do Nothing

Java still supports classpath
Old apps run fine

### Step 2 – Make app JPMS-aware without going full JPMS

* Keep classpath
* Add `module-info.java` gradually
* Test library/module impact

### Step 3 – Full modularization

* Move to module path
* Introduce exports/requires gradually
* Fix reflection issues with `opens`

---

# ⚖️ When to Use / Avoid JPMS

### ✔ Use Modules When

* Building libraries / SDKs
* Designing clear APIs
* Security sensitive applications
* Want strong encapsulation
* Want smaller runtime (embedded, IoT, containerized)
* Clean architecture enforcement matters

### ❌ Avoid (or defer) When

* Large legacy monolith
* Heavy reflection frameworks (Spring, Hibernate) and don’t want config noise
* You gain no meaningful benefit
* Team not ready to maintain module boundaries

Classpath is fine in many production systems.

---

# 🧑‍💻 Best Practices

✔ Keep module names = package root
`com.company.project.module`

✔ Export only what is public API
Do not export internal implementation

✔ Prefer `requires transitive` for API surface dependencies

✔ Use `opens` only when needed

✔ Avoid over-modularizing small applications

✔ Document module structure as **architecture**

---

# 🗂 Quick Reference

| Directive             | Meaning                |
| --------------------- | ---------------------- |
| module X              | Defines module         |
| requires A            | Depends on `A`         |
| requires transitive A | Re-export dependency   |
| exports p             | Makes package public   |
| opens p               | Allows reflection      |
| open module X         | Fully open             |
| uses / provides       | Service loader support |

---

# 🎯 Final Takeaway

JPMS gives Java:

* real encapsulation
* explicit dependencies
* safer runtime
* clearer architecture
* optimized runtimes

You *don’t need to use it everywhere*, but when used intentionally, it greatly improves large system maintainability.
