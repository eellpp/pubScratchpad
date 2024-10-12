The Factory Method Pattern is a creational design pattern that provides an interface for creating objects in a superclass, but allows subclasses to alter the type of objects that will be created. It's particularly useful when a class can't anticipate the type of objects it needs to create beforehand.

Let's implement a Factory Method Pattern using a static nested class. We'll create a simple example of a document creation system where we have different types of documents (Text, PDF, HTML) that can be created.



```java
// Abstract Product
interface Document {
    void open();
    void save();
}

// Concrete Products
class TextDocument implements Document {
    public void open() { System.out.println("Opening Text Document"); }
    public void save() { System.out.println("Saving Text Document"); }
}

class PDFDocument implements Document {
    public void open() { System.out.println("Opening PDF Document"); }
    public void save() { System.out.println("Saving PDF Document"); }
}

class HTMLDocument implements Document {
    public void open() { System.out.println("Opening HTML Document"); }
    public void save() { System.out.println("Saving HTML Document"); }
}

// Abstract Creator
abstract class DocumentCreator {
    // Factory Method
    public abstract Document createDocument();

    // Template method
    public void editDocument() {
        Document doc = createDocument();
        doc.open();
        // Edit the document
        doc.save();
    }

    // Static nested class for creating specific document creators
    public static class Factory {
        public static DocumentCreator getCreator(String type) {
            switch (type.toLowerCase()) {
                case "text":
                    return new TextDocumentCreator();
                case "pdf":
                    return new PDFDocumentCreator();
                case "html":
                    return new HTMLDocumentCreator();
                default:
                    throw new IllegalArgumentException("Unknown document type");
            }
        }
    }
}

// Concrete Creators
class TextDocumentCreator extends DocumentCreator {
    public Document createDocument() {
        return new TextDocument();
    }
}

class PDFDocumentCreator extends DocumentCreator {
    public Document createDocument() {
        return new PDFDocument();
    }
}

class HTMLDocumentCreator extends DocumentCreator {
    public Document createDocument() {
        return new HTMLDocument();
    }
}

// Client code
public class FactoryMethodExample {
    public static void main(String[] args) {
        DocumentCreator creator;

        // Create and edit a Text document
        creator = DocumentCreator.Factory.getCreator("text");
        creator.editDocument();

        // Create and edit a PDF document
        creator = DocumentCreator.Factory.getCreator("pdf");
        creator.editDocument();

        // Create and edit an HTML document
        creator = DocumentCreator.Factory.getCreator("html");
        creator.editDocument();
    }
}

```

Let's break down this example:

1. **Document Interface**: This is the abstract product. It declares the interface that all concrete products must implement.

2. **Concrete Documents**: `TextDocument`, `PDFDocument`, and `HTMLDocument` are concrete implementations of the `Document` interface.

3. **DocumentCreator Abstract Class**: This is the abstract creator. It declares the factory method `createDocument()` which returns a `Document` object. It also provides a template method `editDocument()` which uses the factory method.

4. **Concrete Creators**: `TextDocumentCreator`, `PDFDocumentCreator`, and `HTMLDocumentCreator` are concrete implementations of `DocumentCreator`. Each overrides the `createDocument()` method to return the specific type of document.

5. **Static Nested Factory Class**: Inside `DocumentCreator`, we have a static nested class `Factory` which provides a method to get the appropriate creator based on the document type. This demonstrates the use of a static nested class in the Factory Method Pattern.

6. **Client Code**: In the `main` method, we demonstrate how to use the factory to create different types of documents and edit them.

Key points about this implementation:

- The Factory Method Pattern allows the class to defer instantiation to subclasses.
- The static nested `Factory` class provides a convenient way to get the appropriate creator without needing to know the specific subclasses.
- This pattern is useful when a class can't anticipate the class of objects it must create, or when a class wants its subclasses to specify the objects it creates.
- It promotes loose coupling by eliminating the need to bind application-specific classes into the code.

This pattern is particularly useful in frameworks and libraries where the code needs to work with various types of objects without knowing their exact classes. It allows for easy extension of the code to include new types of objects without modifying existing code.
