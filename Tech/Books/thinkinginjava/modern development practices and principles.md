modern software development has evolved certain *guidelines or philosophies* that help developers write more maintainable, flexible, and testable code.    
These are not strict rules, but widely accepted best practices.   



##  **Modern Object-Oriented & Software Design Practices**

###  1. **Prefer Composition over Inheritance**

* Build behavior using smaller components instead of rigid class hierarchies.
* Increases flexibility and avoids fragile base class problems.

---

###  2. **Prefer Classes over Interfaces (in some contexts)**

* Use interfaces only when multiple implementations are expected.
* Avoid creating interfaces prematurely (“speculative abstraction”).
* In Java, records, sealed classes, or concrete classes are often better starting points.

---

###  3. **Program to an Interface, Not an Implementation**

* Use abstractions (e.g., Repository, Service) instead of concrete types in your code.
* Makes code testable and loosely coupled.

---

###  4. **Favor Immutability Wherever Possible**

* Immutable objects are thread-safe, easier to reason about, and reduce bugs.
* Example: `String`, `LocalDate`, Java `record`s, Kotlin `data classes`.

---

###  5. **Tell, Don’t Ask (TDA Principle)**

* Instead of querying an object’s state and making decisions outside,
  *tell the object to do the work*.

  ```java
  // Bad
  if (employee.getType().equals("Manager")) employee.approveLeave();

  // Good
  employee.approveLeave();
  ```

---

###  6. **Encapsulate What Changes (Strategy from SOLID)**

* Identify parts of the system that vary, and isolate them behind interfaces or composition.
* Example: payment strategies, sorting strategies.

---

###  7. **YAGNI – "You Aren’t Gonna Need It"**

* Don’t build abstractions or helpers until actually needed.
* Helps avoid complex, over-engineered designs.

---

###  8. **DRY – "Don't Repeat Yourself"**

* Extract repeated logic into reusable functions, classes, or modules.
* Avoid copy-paste inheritance traps.

---

###  9. **KISS – "Keep It Simple, Stupid"**

* Simple code > Clever code.
* Small methods, readable logic, low cyclomatic complexity.

---

###  10. **Prefer Dependency Injection Over New()**

* Avoid manually creating dependencies inside classes.

  ```java
  // Bad
  private final Service s = new Service();

  // Good
  public Controller(Service s) { this.s = s; }
  ```

* Increases testability & flexibility (e.g., Spring, Dagger, Guice).

---

###  11. **Use Composition + Behavior Interfaces Instead of Flags/Enums**

* Instead of writing `if (type == ADMIN) {...}`, define different classes implementing the behavior.
* Avoids "switch over type" anti-pattern.

---

###  12. **Fail Fast & Early**

* Validate arguments, throw exceptions early.
* Easier debugging.

---

###  13. **Design for Testability**

* Small classes, injected dependencies, no static global state.
* Use mocks/fakes in testing.

---

###  14. **Prefer Sealed Classes over Deep Inheritance Hierarchies (Java 17+)**

* Use `sealed`, `permits` to control extension and model domain objects safely.

---

###  15. **Prefer Records/Data Classes for Simple Data Carriers**

* Immutable, compact representation of DTOs or value objects.

  ```java
  public record User(String name, String email) {}
  ```

---

###  16. **Avoid Static State and Globals**

* Static code is hard to test, mock, and extend.
* Use DI and instance management instead.

---

###  17. **Prefer Aggregates & Domain Services (DDD Practices)**

* Group related entities and value objects into cohesive domain models.
* Keep business logic inside domain → not in controllers or utility classes.

---

##  **Summary Table**

| Practice                  | Why?                          |
| ------------------------- | ----------------------------- |
| Composition > Inheritance | Flexibility, less coupling    |
| Classes over Interfaces   | Avoid unnecessary abstraction |
| Program to Interfaces     | Decoupling, testability       |
| Immutability              | Thread-safe, predictable      |
| Tell Don't Ask            | Better encapsulation          |
| YAGNI, KISS, DRY          | Reduce complexity, waste      |
| Dependency Injection      | Testability, modularity       |
| Sealed Classes, Records   | Modern Java simplifications   |
| Avoid Static State        | Easier to test and maintain   |

