### When to use inner classes in Java for helper classes

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
