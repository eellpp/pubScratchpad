
### Generics enforce Complile time checks to avoid errors at runtime
Generics in Java provide better type safety than casting because they enforce compile-time checks, preventing class cast exceptions at runtime. With generics, the compiler ensures that only objects of the specified type can be added to a collection, eliminating the need for manual casting.

For example:

```java
List<String> list = new ArrayList<>();
list.add("Hello");  // Compile-time check
String s = list.get(0);  // No cast needed
```

Without generics, you would need to cast manually:

```java
List list = new ArrayList();
list.add("Hello");
String s = (String) list.get(0);  // Risk of ClassCastException
```

Generics help avoid such runtime risks.


In the second case, the generics List is used but at run time casting is done which can lead to run time exceptions
