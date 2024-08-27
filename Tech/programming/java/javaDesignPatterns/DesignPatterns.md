
flashcards covering **all the design patterns** . Each flashcard has a simple question and answer format.

### **Creational Patterns**

| **Question**                                                             | **Answer**                                   |
|--------------------------------------------------------------------------|----------------------------------------------|
| What does the **Abstract Factory** pattern do?                            | Creates instances of several families of classes. |
| What is the **Builder** pattern used for?                                 | Separates object construction from its representation. |
| What does the **Factory Method** pattern achieve?                         | Creates an instance of several derived classes. |
| What is the purpose of the **Prototype** pattern?                         | Creates a fully initialized instance to be copied or cloned. |
| When is the **Singleton** pattern used?                                   | To ensure a class has only one instance globally. |
| What is the **Object Pool** pattern used for?                             | Reuses and manages a fixed set of instances of a class to optimize performance. |

### **Structural Patterns**

| **Question**                                                             | **Answer**                                   |
|--------------------------------------------------------------------------|----------------------------------------------|
| How does the **Adapter** pattern help in object-oriented design?          | Matches interfaces of different classes, allowing them to work together. |
| What problem does the **Bridge** pattern solve?                           | Separates an object’s interface from its implementation, allowing them to vary independently. |
| What structure does the **Composite** pattern represent?                  | A tree structure of simple and composite objects, treating them uniformly. |
| How does the **Decorator** pattern modify object behavior?                | Adds responsibilities to objects dynamically without modifying their structure. |
| What role does the **Facade** pattern play in a subsystem?                | Provides a simplified interface to a complex subsystem. |
| How does the **Flyweight** pattern improve memory usage?                  | Uses fine-grained instances shared among multiple objects to minimize memory usage. |
| What does the **Proxy** pattern represent?                                | An object that controls access to another object, potentially adding functionality like lazy loading or security. |
| What is the purpose of the **Private Class Data** pattern?                | Encapsulates private data to restrict direct access to it from outside classes. |

### **Behavioral Patterns**

| **Question**                                                             | **Answer**                                   |
|--------------------------------------------------------------------------|----------------------------------------------|
| How does the **Chain of Responsibility** pattern handle requests?         | Passes a request along a chain of handlers until one handles it. |
| How does the **Command** pattern encapsulate operations?                  | Encapsulates a command request as an object, allowing for parameterization of methods. |
| What does the **Interpreter** pattern enable in a program?                | Allows language elements to be interpreted within the program. |
| How does the **Iterator** pattern work with collections?                  | Provides a way to access elements of a collection sequentially without exposing the underlying representation. |
| What communication pattern does **Mediator** define?                      | Defines an object that centralizes complex communications and control logic between objects. |
| What problem does the **Memento** pattern solve?                          | Captures and restores an object’s internal state without violating encapsulation. |
| How does the **Observer** pattern work?                                   | Defines a one-to-many dependency between objects so that when one object changes state, its dependents are notified and updated automatically. |
| How does the **State** pattern affect an object’s behavior?               | Alters the behavior of an object when its internal state changes. |
| What does the **Strategy** pattern encapsulate?                           | Encapsulates an algorithm within a class and allows it to be swapped at runtime. |
| What does the **Template Method** pattern define?                         | Defines the skeleton of an algorithm, with steps that can be overridden by subclasses. |
| How does the **Visitor** pattern handle operations on object structures?  | Separates operations from the object structure, allowing new operations to be added without changing the structure. |

### **Concurrency Patterns**

| **Question**                                                             | **Answer**                                   |
|--------------------------------------------------------------------------|----------------------------------------------|
| What is the purpose of the **Active Object** pattern?                     | Decouples method execution from method invocation for concurrency control. |
| How does the **Monitor Object** pattern help with concurrency?            | Encapsulates shared resources and provides synchronized access to them. |
| What does the **Half-Sync/Half-Async** pattern achieve?                   | Divides the program into synchronous and asynchronous layers to simplify concurrent programming. |
| What does the **Scheduler** pattern do?                                   | Coordinates when and in what order tasks are executed. |
| What is the **Thread-Specific Storage** pattern used for?                 | Provides global access to objects that are specific to a particular thread. |

### **Architectural Patterns**

| **Question**                                                             | **Answer**                                   |
|--------------------------------------------------------------------------|----------------------------------------------|
| What is the purpose of the **MVC (Model-View-Controller)** pattern?       | Separates an application into three interconnected components: Model (data), View (UI), and Controller (business logic). |
| How does the **Microkernel** pattern work in software systems?            | Provides a minimal core system that can be extended with plug-ins. |
| What does the **Layered Architecture** pattern represent?                 | Organizes software into layers, each layer providing services to the layer above it. |

### **Additional Design Patterns**

| **Question**                                                             | **Answer**                                   |
|--------------------------------------------------------------------------|----------------------------------------------|
| What is the purpose of the **Null Object** pattern?                       | Provides an object that performs no operation as a default value instead of `null`. |
| How does the **Multiton** pattern differ from Singleton?                  | It ensures that a class only has a limited number of instances, instead of just one like Singleton. |
| What does the **Service Locator** pattern do?                             | Provides a central registry to find and return service instances. |
| How does the **Dependency Injection** pattern work?                       | Provides objects their dependencies from an external source rather than creating them internally. |

These flashcards cover a comprehensive range of design patterns, including creational, structural, behavioral, concurrency, and architectural patterns. They help in understanding the purpose and key characteristics of each pattern.

#### References
https://sourcemaking.com/design_patterns

