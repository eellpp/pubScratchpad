
### Java Fx CSS Reference
https://openjfx.io/javadoc/16/javafx.graphics/javafx/scene/doc-files/cssref.html

https://www.pragmaticcoding.ca/javafx/elements/stylesheets_pseudoclasses


Certainly! JavaFX CSS (Cascading Style Sheets) is a powerful feature that allows you to style your JavaFX applications, separating the presentation from the logic. It's similar to web CSS but with some JavaFX-specific features. Let's dive into the key aspects of JavaFX CSS:



1. Basic Usage:
   - CSS can be applied to the entire scene, specific nodes, or groups of nodes.
   - You can set styles inline, in the Java code, or in external .css files.

2. Applying CSS:
   - Inline: `node.setStyle("-fx-background-color: red;");`
   - In Java: `scene.getStylesheets().add("path/to/stylesheet.css");`
   - In FXML: `<AnchorPane stylesheets="@stylesheet.css">`

3. Selectors:
   - Class Selector: `.button`
   - ID Selector: `#myButton`
   - Type Selector: `Button`

4. Properties:
   JavaFX CSS properties often start with "-fx-". For example:
   - `-fx-background-color`
   - `-fx-font-size`
   - `-fx-padding`

5. Pseudo-classes:
   JavaFX supports pseudo-classes like `:hover`, `:pressed`, `:focused`

6. Styling Specific Components:
   Different JavaFX components have specific style classes and properties.

Here's a basic example of how you might use CSS in a JavaFX application:

```java
Button button = new Button("Click me");
button.setId("myButton");
button.getStyleClass().add("important-button");

Scene scene = new Scene(button, 200, 100);
scene.getStylesheets().add("path/to/styles.css");
```

And the corresponding CSS file (styles.css):

```css
.button {
    -fx-background-color: #4CAF50;
    -fx-text-fill: white;
}

#myButton {
    -fx-font-size: 14px;
}

.important-button {
    -fx-border-color: red;
    -fx-border-width: 2px;
}

.button:hover {
    -fx-background-color: #45a049;
}
```

Now, let me provide a more comprehensive CSS example in an artifact that you can reference or modify:

```css
/* General styles */
.root {
    -fx-font-family: "Segoe UI", Helvetica, Arial, sans-serif;
    -fx-font-size: 14px;
    -fx-background-color: #f0f0f0;
}

/* Button styles */
.button {
    -fx-background-color: #4CAF50;
    -fx-text-fill: white;
    -fx-padding: 8px 16px;
    -fx-cursor: hand;
}

.button:hover {
    -fx-background-color: #45a049;
}

.button:pressed {
    -fx-background-color: #3e8e41;
}

/* Text field styles */
.text-field {
    -fx-background-color: white;
    -fx-border-color: #cccccc;
    -fx-border-radius: 4px;
    -fx-padding: 5px;
}

.text-field:focused {
    -fx-border-color: #4CAF50;
}

/* Label styles */
.label {
    -fx-text-fill: #333333;
}

/* Table view styles */
.table-view {
    -fx-background-color: white;
    -fx-table-cell-border-color: transparent;
}

.table-view .column-header {
    -fx-background-color: #f2f2f2;
}

.table-row-cell:odd {
    -fx-background-color: #f8f8f8;
}

.table-row-cell:selected {
    -fx-background-color: #bfdcf9;
}

/* Custom styles */
#main-title {
    -fx-font-size: 24px;
    -fx-font-weight: bold;
}

.important-text {
    -fx-text-fill: #ff0000;
    -fx-font-weight: bold;
}

/* Responsive design example */
@media (max-width: 600px) {
    .root {
        -fx-font-size: 12px;
    }
    
    #main-title {
        -fx-font-size: 20px;
    }
}

```

This CSS example covers various aspects of styling JavaFX applications:

1. It sets general styles for the entire application using the `.root` selector.
2. It styles common components like buttons, text fields, labels, and table views.
3. It demonstrates the use of pseudo-classes for interactive elements.
4. It shows how to use ID selectors (`#main-title`) and custom class selectors (`.important-text`).
5. It includes a basic example of responsive design using media queries.

Key points to remember when using CSS in JavaFX:

1. Specificity: Like web CSS, more specific selectors take precedence.
2. Inheritance: Some properties are inherited by child nodes.
3. Customization: You can create custom CSS properties for your own components.
4. Performance: Using CSS can be more performant than setting styles individually in Java code.
5. Theming: CSS makes it easy to implement and switch between different themes in your application.

Would you like me to explain any specific part of JavaFX CSS usage in more detail?
