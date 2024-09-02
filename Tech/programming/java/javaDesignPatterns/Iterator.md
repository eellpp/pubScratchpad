Below is an example of how you can apply the Iterator design pattern to a list of `Student` objects. 

### Step 1: Define the `Student` Class
First, define the `Student` class with `name`, `subject`, and `marks` fields.

```java
public class Student {
    private String name;
    private String subject;
    private int marks;

    public Student(String name, String subject, int marks) {
        this.name = name;
        this.subject = subject;
        this.marks = marks;
    }

    public String getName() {
        return name;
    }

    public String getSubject() {
        return subject;
    }

    public int getMarks() {
        return marks;
    }

    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", subject='" + subject + '\'' +
                ", marks=" + marks +
                '}';
    }
}
```

### Step 2: Create an `Iterator` Interface
Define the `Iterator` interface that will be used to traverse the `Student` collection.

```java
public interface Iterator<T> {
    boolean hasNext();
    T next();
}
```

### Step 3: Create a `Collection` Interface
Define a `Collection` interface that will provide a method to create an iterator for the `Student` collection.

```java
public interface Collection<T> {
    Iterator<T> createIterator();
}
```

### Step 4: Implement a Concrete Collection Class
Implement a concrete collection class `StudentCollection` that stores a list of `Student` objects and provides an iterator.

```java
import java.util.ArrayList;
import java.util.List;

public class StudentCollection implements Collection<Student> {
    private List<Student> students = new ArrayList<>();

    public void addStudent(Student student) {
        students.add(student);
    }

    @Override
    public Iterator<Student> createIterator() {
        return new StudentIterator();
    }

    // Inner class implementing the Iterator interface
    private class StudentIterator implements Iterator<Student> {
        private int index = 0;

        @Override
        public boolean hasNext() {
            return index < students.size();
        }

        @Override
        public Student next() {
            if (this.hasNext()) {
                return students.get(index++);
            }
            return null;
        }
    }
}
```

### Step 5: Use the Iterator to Traverse the Student Collection
Finally, use the `Iterator` to traverse through the `Student` objects.

```java
public class IteratorPatternDemo {
    public static void main(String[] args) {
        // Create a collection of students
        StudentCollection studentCollection = new StudentCollection();
        studentCollection.addStudent(new Student("Alice", "Math", 85));
        studentCollection.addStudent(new Student("Bob", "Science", 90));
        studentCollection.addStudent(new Student("Charlie", "History", 78));

        // Create an iterator for the collection
        Iterator<Student> iterator = studentCollection.createIterator();

        // Traverse the collection using the iterator
        while (iterator.hasNext()) {
            Student student = iterator.next();
            System.out.println(student);
        }
    }
}
```

### Output:
```
Student{name='Alice', subject='Math', marks=85}
Student{name='Bob', subject='Science', marks=90}
Student{name='Charlie', subject='History', marks=78}
```

### Explanation:
- **Student Class**: Represents a student with fields for `name`, `subject`, and `marks`.
- **Iterator Interface**: Defines the methods `hasNext()` and `next()` that any concrete iterator must implement.
- **Collection Interface**: Provides a method `createIterator()` to return an iterator for the collection.
- **StudentCollection Class**: Implements the `Collection` interface and provides a concrete implementation of the `Iterator` in the `StudentIterator` inner class.
- **StudentIterator Class**: Implements the `Iterator` interface and provides the logic to iterate through the list of `Student` objects.

This example demonstrates how the Iterator pattern can be applied to a collection of custom objects (`Student` objects in this case), allowing you to traverse the collection without exposing its internal 
structure.


## Advantage of Iterator over List 

Using the Iterator design pattern, as demonstrated in the previous example, provides several advantages over directly iterating over a `List<Student>` using methods like `forEach`, `for` loop, or `List`'s own `iterator()`. Below are some reasons why the Iterator pattern might be a better approach in certain scenarios:

### 1. **Encapsulation of Internal Structure**
   - **Direct List Iteration**: When you iterate directly over a `List<Student>`, the client code must be aware that the data is stored in a `List`. This exposes the internal structure of the collection to the client code.
   - **Iterator Pattern**: The Iterator pattern abstracts the underlying data structure. The client code interacts with the `Iterator` interface rather than the concrete `List` implementation, which allows the internal structure to change without affecting client code. For example, you could switch from a `List` to another collection type (like a `Set` or a custom data structure) without modifying the client code that uses the iterator.

### 2. **Custom Iteration Logic**
   - **Direct List Iteration**: Iterating directly over a `List<Student>` provides only a straightforward sequential access to elements. Custom iteration logic (e.g., skipping certain elements, filtering on-the-fly, or iterating in a specific order) requires additional code in the iteration loop.
   - **Iterator Pattern**: You can encapsulate complex iteration logic within the iterator itself. For instance, you might create an iterator that only returns students with marks above a certain threshold or iterates in a specific order (e.g., alphabetical by name). This keeps the iteration logic separate from the client code, leading to cleaner, more maintainable code.

### 3. **Uniform Access to Different Collections**
   - **Direct List Iteration**: Different collection types (`List`, `Set`, `Map`, etc.) have different ways to access and iterate through elements. If you later decide to change from a `List<Student>` to a different collection type, you'd have to refactor the iteration code.
   - **Iterator Pattern**: The Iterator pattern provides a uniform interface (`Iterator`) to access elements of a collection. This uniformity means that you can change the underlying collection type without needing to change the code that iterates over the collection, promoting flexibility and easier maintenance.

### 4. **Decoupling Client Code from Collection Implementation**
   - **Direct List Iteration**: When iterating directly over a `List<Student>`, the client code is tightly coupled to the specific collection type (`List`). Any changes to the collection type might require changes in the client code.
   - **Iterator Pattern**: The client code is decoupled from the specific implementation of the collection. It only depends on the `Iterator` interface, making the system more modular and easier to refactor or extend.

### 5. **Ability to Provide Multiple Iterators**
   - **Direct List Iteration**: If you need different ways to iterate over the same collection (e.g., forward, backward, filtered, etc.), you would have to write custom iteration code each time.
   - **Iterator Pattern**: You can easily provide multiple iterators with different behaviors by implementing different `Iterator` classes. Each iterator can encapsulate specific iteration logic, allowing the client to choose the most appropriate one for the task at hand.

### 6. **Simplifies Concurrent Access**
   - **Direct List Iteration**: Managing concurrent access (e.g., iterating over a collection while other threads are modifying it) is complex and prone to errors.
   - **Iterator Pattern**: Custom iterators can be designed to handle concurrency better, such as providing a thread-safe iterator or one that allows concurrent modifications.

### 7. **Extensibility**
   - **Direct List Iteration**: If new requirements arise, such as iterating over a collection in a non-standard way, adding this functionality might require modifying existing code.
   - **Iterator Pattern**: New iterators can be created and added without modifying existing code, adhering to the Open/Closed Principle (OCP) from SOLID principles.

### Summary:
While directly iterating over a `List<Student>` is straightforward and works well in simple cases, the Iterator pattern provides greater flexibility, better encapsulation, and cleaner, more maintainable code. It is particularly useful in complex systems where you need to abstract the underlying collection, implement custom iteration logic, or provide multiple ways to iterate over the data.
