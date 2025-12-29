A simple, reusable CSS "framework" for JavaFX that demonstrates how to structure and organize styles for better maintainability and reusability. This example will include a basic theme, utility classes, and component styles.



```css
/* JavaFX CSS Framework */

/* 1. Theme Variables */
.root {
    /* Colors */
    -fx-primary-color: #007bff;
    -fx-primary-dark-color: derive(-fx-primary-color, -20%);
    -fx-secondary-color: #6c757d;
    -fx-success-color: #28a745;
    -fx-info-color: #17a2b8;
    -fx-warning-color: #ffc107;
    -fx-danger-color: #dc3545;
    -fx-light-color: #f8f9fa;
    -fx-dark-color: #343a40;

    /* Typography */
    -fx-font-family: "Segoe UI", Helvetica, Arial, sans-serif;
    -fx-font-size-base: 14px;
    -fx-font-size-large: 18px;
    -fx-font-size-small: 12px;

    /* Spacing */
    -fx-spacing-small: 5px;
    -fx-spacing-medium: 10px;
    -fx-spacing-large: 15px;

    /* Border */
    -fx-border-radius-base: 4px;
}

/* 2. Typography */
.text-small {
    -fx-font-size: -fx-font-size-small;
}

.text-large {
    -fx-font-size: -fx-font-size-large;
}

.text-bold {
    -fx-font-weight: bold;
}

.text-italic {
    -fx-font-style: italic;
}

/* 3. Layout Utilities */
.margin-small {
    -fx-margin: -fx-spacing-small;
}

.margin-medium {
    -fx-margin: -fx-spacing-medium;
}

.margin-large {
    -fx-margin: -fx-spacing-large;
}

.padding-small {
    -fx-padding: -fx-spacing-small;
}

.padding-medium {
    -fx-padding: -fx-spacing-medium;
}

.padding-large {
    -fx-padding: -fx-spacing-large;
}

/* 4. Flex-box like utilities */
.hbox, .vbox {
    -fx-spacing: -fx-spacing-medium;
}

.hbox {
    -fx-alignment: center-left;
}

.vbox {
    -fx-alignment: top-center;
}

/* 5. Component Styles */

/* Buttons */
.button {
    -fx-background-color: -fx-primary-color;
    -fx-text-fill: white;
    -fx-padding: 8px 16px;
    -fx-cursor: hand;
}

.button:hover {
    -fx-background-color: -fx-primary-dark-color;
}

.button.secondary {
    -fx-background-color: -fx-secondary-color;
}

.button.success {
    -fx-background-color: -fx-success-color;
}

.button.danger {
    -fx-background-color: -fx-danger-color;
}

/* Text Fields */
.text-field {
    -fx-background-color: white;
    -fx-border-color: -fx-secondary-color;
    -fx-border-radius: -fx-border-radius-base;
    -fx-padding: 5px;
}

.text-field:focused {
    -fx-border-color: -fx-primary-color;
}

/* Labels */
.label {
    -fx-text-fill: -fx-dark-color;
}

/* Table View */
.table-view {
    -fx-background-color: white;
    -fx-table-cell-border-color: transparent;
}

.table-view .column-header {
    -fx-background-color: -fx-light-color;
}

.table-row-cell:odd {
    -fx-background-color: derive(-fx-light-color, 5%);
}

.table-row-cell:selected {
    -fx-background-color: derive(-fx-primary-color, 80%);
}

/* 6. Custom Components */
.card {
    -fx-background-color: white;
    -fx-border-color: -fx-light-color;
    -fx-border-radius: -fx-border-radius-base;
    -fx-padding: -fx-spacing-medium;
    -fx-effect: dropshadow(three-pass-box, rgba(0,0,0,0.1), 10, 0, 0, 2);
}

/* 7. Responsive Design */
@media (max-width: 600px) {
    .root {
        -fx-font-size-base: 12px;
        -fx-font-size-large: 16px;
        -fx-font-size-small: 10px;
    }

    .button {
        -fx-padding: 6px 12px;
    }
}

```

Now, let me explain the key components of this simple JavaFX CSS framework:

1. Theme Variables:
   - Defined at the root level for easy customization.
   - Includes colors, typography, spacing, and border styles.

2. Typography:
   - Utility classes for text sizes and styles.

3. Layout Utilities:
   - Classes for margins and paddings.

4. Flex-box like utilities:
   - Basic styles for HBox and VBox to mimic flexbox behavior.

5. Component Styles:
   - Basic styles for common JavaFX components like buttons, text fields, labels, and table views.
   - Includes variant classes for buttons (e.g., .button.secondary).

6. Custom Components:
   - Example of a custom 'card' component.

7. Responsive Design:
   - Basic media query to adjust styles for smaller screens.

To use this framework in your JavaFX application:

1. Save the CSS as a file, e.g., "framework.css".

2. Apply it to your scene or specific nodes:

   ```java
   scene.getStylesheets().add("path/to/framework.css");
   ```

3. Use the classes in your JavaFX code:

   ```java
   Button button = new Button("Click me");
   button.getStyleClass().addAll("button", "success", "margin-small");

   VBox container = new VBox();
   container.getStyleClass().addAll("vbox", "padding-medium", "card");
   ```

This framework provides a starting point for consistent styling across your JavaFX application. You can extend it by:

- Adding more utility classes.
- Creating additional custom components.
- Expanding the responsive design capabilities.
- Adding animations or transitions.

