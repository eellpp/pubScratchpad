### When to use inner classes in Java for helper classes

You can use inner classes in Java for helper classes when you want to logically group classes that are only used in one place. They can help encapsulate helper functionality that is specific to an outer class while keeping related code organized and hidden from external access. Here are some scenarios when inner classes are useful:

### When to Use Inner Classes for Helper Classes:

1. **Encapsulation of Helper Functionality**:
   - When the inner class is closely tied to the outer class and its functionality is specific to the outer class.
   - For example, if the helper class is only needed to assist in the internal workings of the outer class, and you don’t want to expose this functionality outside the outer class.

   ```java
   class OuterClass {
       private int value;

       // Helper inner class to perform operations on OuterClass
       private class Helper {
           void increment() {
               value++;
           }
       }
   }
   ```

2. **Access to Outer Class Members**:
   - Use inner classes when the helper class needs direct access to the outer class’s members (fields and methods), even if those members are private.
   - Inner classes have a reference to the outer class instance and can access its fields without requiring accessors.

   ```java
   class OuterClass {
       private int value = 5;

       class Helper {
           void doubleValue() {
               value *= 2;
           }
       }
   }
   ```

3. **When the Helper Class Should Not Be Exposed**:
   - If the helper class is meant to be hidden and not exposed to the rest of the application, making it an inner class ensures it is scoped within the outer class.
   - This enhances encapsulation and keeps the API clean.

   ```java
   public class OuterClass {
       // Helper inner class is private and not exposed to other classes
       private class Helper {
           void assist() {
               // helper functionality
           }
       }
   }
   ```

4. **Logical Grouping**:
   - If the helper class is only meaningful in the context of the outer class, grouping them as an inner class makes sense from a design perspective.
   - This makes the code easier to understand by keeping related functionality close together.

5. **Event Handlers or Callbacks**:
   - Inner classes are often used in GUI programming (like in Swing or Android development) for event listeners or callbacks that logically belong to the outer class.
   - The inner class can directly access the outer class’s state, which is useful for handling events.

   ```java
   class ButtonHandler {
       class ClickListener implements ActionListener {
           public void actionPerformed(ActionEvent e) {
               // handle button click event, possibly interacting with the outer class
           }
       }
   }
   ```

6. **Helper Class Is Not Reusable Elsewhere**:
   - If the helper class is tightly coupled to the outer class and is not meant to be reused in other classes, it’s a good candidate to be an inner class.
   - Keeping it inside the outer class ensures it stays specific to that class’s context.


Sure! Here’s a continuation about the **types of inner classes** and when to use them, particularly for helper classes.

### Types of Inner Classes:

1. **Non-static Inner Class (Regular Inner Class)**:
   - This type of inner class is associated with an instance of the outer class. It can access all fields and methods of the outer class, including private members.
   - **When to use**: Use a non-static inner class when the helper class needs access to the instance members (fields or methods) of the outer class. This is typically the case when the inner class is performing operations that depend on the state of the outer class.
   
   Example:
   ```java
   class OuterClass {
       private int value = 10;

       class Helper {
           void showValue() {
               System.out.println("Value: " + value); // Accesses outer class member
           }
       }
   }
   ```

2. **Static Nested Class**:
   - This class is similar to a regular inner class, but it is declared with the `static` modifier. It cannot access the instance members of the outer class unless it's provided with an instance of the outer class.
   - **When to use**: Use a static nested class when the helper class does not need to access instance members of the outer class. This can help reduce memory overhead as static nested classes do not retain an implicit reference to an outer class instance.

   Example:
   ```java
   class OuterClass {
       private static int value = 10;

       static class Helper {
           void showValue() {
               System.out.println("Value: " + value); // Accesses static member
           }
       }
   }
   ```

3. **Local Inner Class**:
   - A local inner class is defined within a method or a block of code inside the outer class. It can access the members of the outer class as well as local variables of the method, provided the local variables are effectively final.
   - **When to use**: Use a local inner class when the helper functionality is only required within the scope of a specific method. This is useful when the helper class is small and only used for a specific task.

   Example:
   ```java
   class OuterClass {
       void performTask() {
           final int localVar = 20;
           
           class Helper {
               void assist() {
                   System.out.println("Local Var: " + localVar);
               }
           }

           Helper helper = new Helper();
           helper.assist();
       }
   }
   ```

4. **Anonymous Inner Class**:
   - This is a shorthand for creating a subclass or implementing an interface within a method without explicitly defining a new class. It's typically used for short-lived, simple helper classes, especially for event handling or callbacks.
   - **When to use**: Use an anonymous inner class when you need a one-off implementation of a class or interface, and the implementation is short (usually just a method or two). It’s commonly used in event listeners or callbacks where defining a separate class would be overkill.

   Example:
   ```java
   class OuterClass {
       void performTask() {
           Runnable helper = new Runnable() {
               public void run() {
                   System.out.println("Task performed");
               }
           };
           new Thread(helper).start();
       }
   }
   ```

### Summary: When to Use Inner Classes for Helper Classes
- **Use Non-static Inner Classes**: When the helper class needs direct access to the instance fields and methods of the outer class, and it logically belongs within the outer class’s context.
- **Use Static Nested Classes**: When the helper class can operate without an instance of the outer class (i.e., it only interacts with static members) and you want to avoid the overhead of an implicit reference to the outer class.
- **Use Local Inner Classes**: When the helper class is only needed within the scope of a method and has limited functionality, keeping it localized to that method.
- **Use Anonymous Inner Classes**: When you need a quick, single-use implementation of a class or interface, typically for short-lived tasks such as event handling or callbacks.

By using inner classes strategically, you can better encapsulate your code, improve readability, and manage the complexity of your classes by grouping related functionality.

### Notes

```java
public class Foo {
       private FooHelper helper;

       // constructor & any other logic

       public void doSomeThing() {
         helper.do();
       }
       
      public class FooHelper {
        public void do() {
         // code
        }
      }

 }
```

It is a way of logically grouping classes that are only used in one place: If a class is useful to only one other class, then it is logical to embed it in that class and keep the two together. Nesting such "helper classes" makes their package more streamlined.

If no other classes need it, make it private. If it doesn't require exclusive access to the members of the outer class, make it a static nested class because then it will require less memory space.

 A static nested class doesn't have access to the members of the enclosing class (unless it is static).
 
 ### Encapsulation
 Consider two top-level classes, A and B, where B needs access to members of A that would otherwise be declared private. By hiding class B within class A, A's members can be declared private and B can access them. In addition, B itself can be hidden from the outside world.
 
 One example of this kind of design can be found in HashMap where it defines a private inner class KeySet
