## Code organization


* When a `.java` file is compiled, it produces a separate `.class` file for each class it contains.

* Unlike other compiled languages (like C/C++), Java does **not** create object files and then link them into a single executable. Instead, a Java program is simply a collection of `.class` files.

* These `.class` files can be grouped and compressed into a **JAR (Java ARchive)** file, which the **Java interpreter (JVM)** loads and runs.

* A **library in Java** is essentially a collection of these `.class` files.

* Typically, a `.java` source file contains:

  * **One public class** (matching the filename)
  * Optional **non-public classes**

* To organize classes and indicate they belong to the same library or group, Java uses **packages**.

* The `package` statement:

  * Must be the **first non-comment line** in a `.java` file.
  * Declares that the class belongs to a specific package (e.g., `package access;`).
  * Ensures that anyone using this class must either:

    * Use its **fully qualified name** (e.g., `access.MyClass`), or
    * Use an **import statement**.

* **Naming convention:** Java package names use **all lowercase letters**, even for multi-word names.

## Public , Protected , Private 


### **Java Access Modifiers Summary**

| Modifier                 | Accessible Within Same Class | Same Package | Subclass in Other Package                             | Other Packages |
| ------------------------ | ---------------------------- | ------------ | ----------------------------------------------------- | -------------- |
| **private**              | ✅ Yes                        | ❌ No         | ❌ No                                                  | ❌ No           |
| **default** (no keyword) | ✅ Yes                        | ✅ Yes        | ❌ No                                                  | ❌ No           |
| **protected**            | ✅ Yes                        | ✅ Yes        | ✅ Yes (only via inheritance, not by object reference) | ❌ No           |
| **public**               | ✅ Yes                        | ✅ Yes        | ✅ Yes                                                 | ✅ Yes          |


### **1. `public`**

* Accessible from **anywhere** — same class, same package, different package, or subclass.
* Used when you want to expose methods or classes for general use.
* **Class-level rule**: Only one public class is allowed in a `.java` file, and the file name must match the public class name.

### **2. `private`**

* Accessible **only within the same class**.
* Not visible to subclasses, even if they are in the same package.
* Most often used for **encapsulation** of data — fields are private, and accessed via getters/setters.

**Things to note:**

* Top-level classes **cannot be declared private**.
* Private members **are not inherited**.

###  **3. `default` (Package-Private)**

* Applies when **no modifier is used**.
* Accessible **only within the same package**.
* Not accessible from other packages (even via inheritance).

**Example:**

```java
class MyClass {  // default access class
    int age;     // default access field
}
```

###  **4. `protected`**

* Accessible:
  - In the **same class**
  -  In the **same package**
  - In **subclasses in other packages**, but only through **inheritance (not object reference)**

**Example (subclass access vs object access):**

```java
package animals;

public class Animal {
    protected String name = "Lion";
}

package zoo;

import animals.Animal;

public class Lion extends Animal {
    void printName() {
        System.out.println(name); // ✅ allowed (inherited access)
    }
}

class Test {
    void test() {
        Animal a = new Animal();
        System.out.println(a.name); // ❌ Error: not allowed via object reference
    }
}
```


###  **Important Notes & Gotchas**

* **Top-level classes** can only be `public` or `default`. (Not private/protected.)
* **Private members are not inherited**, but they *do exist* in subclasses (hidden, not accessible).
* A subclass can **reduce access**, but not **increase it**:

  *  `protected → private` (allowed)
  *  `private → public` (not allowed in overriding)
* If a method in a superclass is `public`, the overriding method in a subclass **cannot be private or protected**.
* `protected` outside package works **only through inheritance**.


###  **Quick Example Showing All Access Types**

```java
package demo;

public class A {
    public int pub = 1;
    private int priv = 2;
    protected int prot = 3;
    int def = 4;  // default access
}

class B {
    void test() {
        A a = new A();
        System.out.println(a.pub);  // 
        // System.out.println(a.priv); //  private
        System.out.println(a.prot); //  same package
        System.out.println(a.def);  //  same package
    }
}
```


###  **In One Line:**

* **private** = only in the class
* **default** = class + same package
* **protected** = default + subclasses (even in other packages)
* **public** = anywhere


### Nested Classes

Here’s a clear and complete explanation of **public**, **private**, **protected**, and **default (package-private)** access in Java, along with key points to remember:



### **Java Access Modifiers Summary**

| Modifier                 | Accessible Within Same Class | Same Package | Subclass in Other Package                             | Other Packages |
| ------------------------ | ---------------------------- | ------------ | ----------------------------------------------------- | -------------- |
| **private**              | ✅ Yes                        | ❌ No         | ❌ No                                                  | ❌ No           |
| **default** (no keyword) | ✅ Yes                        | ✅ Yes        | ❌ No                                                  | ❌ No           |
| **protected**            | ✅ Yes                        | ✅ Yes        | ✅ Yes (only via inheritance, not by object reference) | ❌ No           |
| **public**               | ✅ Yes                        | ✅ Yes        | ✅ Yes                                                 | ✅ Yes          |



###  **1. `public`**

* Accessible from **anywhere** — same class, same package, different package, or subclass.
* Used when you want to expose methods or classes for general use.
* **Class-level rule**: Only one public class is allowed in a `.java` file, and the file name must match the public class name.


###  **2. `private`**

* Accessible **only within the same class**.
* Not visible to subclasses, even if they are in the same package.
* Most often used for **encapsulation** of data — fields are private, and accessed via getters/setters.

**Things to note:**

* Top-level classes **cannot be declared private**.
* Private members **are not inherited**.


###  **3. `default` (Package-Private)**

* Applies when **no modifier is used**.
* Accessible **only within the same package**.
* Not accessible from other packages (even via inheritance).

**Example:**

```java
class MyClass {  // default access class
    int age;     // default access field
}
```

---

###  **4. `protected`**

* Accessible:
  ✅ In the **same class**
  ✅ In the **same package**
  ✅ In **subclasses in other packages**, but only through **inheritance (not object reference)**

**Example (subclass access vs object access):**

```java
package animals;

public class Animal {
    protected String name = "Lion";
}

package zoo;

import animals.Animal;

public class Lion extends Animal {
    void printName() {
        System.out.println(name); // ✅ allowed (inherited access)
    }
}

class Test {
    void test() {
        Animal a = new Animal();
        System.out.println(a.name); // ❌ Error: not allowed via object reference
    }
}
```


###  **Important Notes & Gotchas**

* **Top-level classes** can only be `public` or `default`. (Not private/protected.)
* **Private members are not inherited**, but they *do exist* in subclasses (hidden, not accessible).
* A subclass can **reduce access**, but not **increase it**:

  * ✅ `protected → private` (allowed)
  * ❌ `private → public` (not allowed in overriding)
* If a method in a superclass is `public`, the overriding method in a subclass **cannot be private or protected**.
* `protected` outside package works **only through inheritance**.

###  **Quick Example Showing All Access Types**

```java
package demo;

public class A {
    public int pub = 1;
    private int priv = 2;
    protected int prot = 3;
    int def = 4;  // default access
}

class B {
    void test() {
        A a = new A();
        System.out.println(a.pub);  // ✅
        // System.out.println(a.priv); // ❌ private
        System.out.println(a.prot); // ✅ same package
        System.out.println(a.def);  // ✅ same package
    }
}
```

### **In One Line:**

* **private** = only in the class
* **default** = class + same package
* **protected** = default + subclasses (even in other packages)
* **public** = anywhere

## Anonymous class

Sure! Here's a clear and simple explanation of **Anonymous Inner Classes in Java**:

###  **Anonymous Inner Class in Java (No Name Class)**

An **anonymous inner class** is a special type of inner class that:

✔ **Does not have a name**
✔ Is created **on the spot**
✔ Is used to **override a method** or **implement an interface quickly**
✔ Is often used with **interfaces, abstract classes, or existing classes**


### 💡 **Why Use It?**

You use an anonymous inner class when:

* You **need a one-time-only use of a class**
* You want to **override methods without creating a separate class file**
* You want cleaner and shorter code when passing behavior (like in event handling or threading)

####  **Example 1: Using Interface (Runnable)**

```java
public class Test {
    public static void main(String[] args) {
        Runnable r = new Runnable() {
            @Override
            public void run() {
                System.out.println("Running in anonymous inner class");
            }
        };

        Thread t = new Thread(r);
        t.start();
    }
}
```

✔ We created a class that implements `Runnable`
✔ We didn't give it a name
✔ We override `run()` directly

####  **Example 2: Extending a Class**

```java
class Animal {
    void sound() {
        System.out.println("Animal makes sound");
    }
}

public class Test {
    public static void main(String[] args) {
        Animal a = new Animal() {
            @Override
            void sound() {
                System.out.println("Dog barks");
            }
        };

        a.sound();  // Output: Dog barks
    }
}
```

✔ A subclass of `Animal` is created anonymously
✔ The `sound()` method is overridden
✔ No need for `class Dog extends Animal { ... }`


####  **Example 3: With Abstract Class**

```java
abstract class Greeting {
    abstract void sayHello();
}

public class Test {
    public static void main(String[] args) {
        Greeting g = new Greeting() {
            void sayHello() {
                System.out.println("Hello from anonymous class");
            }
        };

        g.sayHello();
    }
}
```

✔ We provide the implementation directly for an abstract class.

###  **Things to Remember**

| Feature     | Rule                                                                        |
| ----------- | --------------------------------------------------------------------------- |
| Name        | No class name — it is "anonymous"                                           |
| Constructor | ❌ Can't define a constructor (no name = no constructor)                     |
| Use case    | Best for one-time use or short-lived implementations                        |
| Static      | ❌ Cannot be static                                                          |
| Syntax      | Always defined at the moment of object creation                             |
| Limit       | Can extend **only one class** or implement **only one interface** at a time |



###  **Syntax Pattern**

```java
ParentType obj = new ParentType() {
    // method overrides or new methods
};
```

Where `ParentType` can be:

* a class
* an abstract class
* an interface

###  **Simple Definition:**

>  An anonymous inner class is a **class without a name**, created to **override methods or implement interfaces** immediately where you need it — without creating a separate class file.




