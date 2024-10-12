Utility classes are commonly used to group related static methods and constants. Using a static nested class within a utility class can help organize and encapsulate related functionality. Here's an example that demonstrates this concept:



```java
public final class StringUtils {
    // Private constructor to prevent instantiation
    private StringUtils() {
        throw new AssertionError("Utility class should not be instantiated");
    }

    // Static method in the main utility class
    public static boolean isNullOrEmpty(String str) {
        return str == null || str.isEmpty();
    }

    // Static nested class for case conversion utilities
    public static class CaseConverter {
        private static final char SPACE = ' ';

        // Private constructor to prevent instantiation
        private CaseConverter() {
            throw new AssertionError("Nested utility class should not be instantiated");
        }

        public static String toTitleCase(String input) {
            if (isNullOrEmpty(input)) {
                return input;
            }

            StringBuilder titleCase = new StringBuilder(input.length());
            boolean nextTitleCase = true;

            for (char c : input.toCharArray()) {
                if (Character.isSpaceChar(c)) {
                    nextTitleCase = true;
                } else if (nextTitleCase) {
                    c = Character.toTitleCase(c);
                    nextTitleCase = false;
                }
                titleCase.append(c);
            }

            return titleCase.toString();
        }

        public static String toCamelCase(String input) {
            if (isNullOrEmpty(input)) {
                return input;
            }

            StringBuilder camelCase = new StringBuilder(input.length());
            boolean nextUpperCase = false;

            for (char c : input.toCharArray()) {
                if (c == SPACE) {
                    nextUpperCase = true;
                } else if (nextUpperCase) {
                    camelCase.append(Character.toUpperCase(c));
                    nextUpperCase = false;
                } else {
                    camelCase.append(Character.toLowerCase(c));
                }
            }

            return camelCase.toString();
        }
    }

    // Another static nested class for string manipulation
    public static class StringManipulator {
        public static String reverse(String input) {
            if (isNullOrEmpty(input)) {
                return input;
            }
            return new StringBuilder(input).reverse().toString();
        }

        public static String removeWhitespace(String input) {
            if (isNullOrEmpty(input)) {
                return input;
            }
            return input.replaceAll("\\s+", "");
        }
    }

    // Main method to demonstrate usage
    public static void main(String[] args) {
        String test = "hello world";
        System.out.println("Original: " + test);
        System.out.println("Is null or empty: " + StringUtils.isNullOrEmpty(test));
        System.out.println("Title case: " + StringUtils.CaseConverter.toTitleCase(test));
        System.out.println("Camel case: " + StringUtils.CaseConverter.toCamelCase(test));
        System.out.println("Reversed: " + StringUtils.StringManipulator.reverse(test));
        System.out.println("Without whitespace: " + StringUtils.StringManipulator.removeWhitespace(test));
    }
}

```

This example demonstrates several key concepts:

1. **Main Utility Class (`StringUtils`)**:
   - Declared as `final` to prevent inheritance.
   - Has a private constructor to prevent instantiation.
   - Contains general utility methods like `isNullOrEmpty()`.

2. **Static Nested Class (`CaseConverter`)**:
   - Encapsulates related methods for case conversion.
   - Contains its own private constants (like `SPACE`).
   - Also has a private constructor to prevent instantiation.

3. **Another Static Nested Class (`StringManipulator`)**:
   - Demonstrates how multiple nested classes can be used to organize different types of utilities.
   - Contains methods for string manipulation like reversing and removing whitespace.

4. **Usage of Nested Classes**:
   - Methods from nested classes are accessed using the syntax `StringUtils.CaseConverter.toTitleCase()` or `StringUtils.StringManipulator.reverse()`.
   - This provides a clear, hierarchical organization of utility methods.

5. **Shared Functionality**:
   - The nested classes can use methods from the outer class (like `isNullOrEmpty()`), demonstrating how functionality can be shared.

6. **Demonstration in `main` Method**:
   - Shows how to use the various utility methods from both the main class and the nested classes.

Key benefits of this approach:

1. **Organization**: Related methods are grouped together in nested classes, improving code organization and readability.
2. **Encapsulation**: The nested classes can have their own private fields and methods, encapsulating related functionality.
3. **Namespace Management**: Avoids cluttering the main namespace with too many method names.
4. **Flexibility**: Allows for future expansion by adding more nested classes for different types of utilities.

This pattern is particularly useful in large projects where you have many utility methods that can be logically grouped into different categories. It provides a clean way to organize and access these utilities without creating too many separate classes.
