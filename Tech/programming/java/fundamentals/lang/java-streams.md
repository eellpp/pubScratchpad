## 1. Stream basics (mental model)

A **stream pipeline** has three parts:

```java
Source        →  Zero or more intermediate operations  →  Terminal operation
(collection)     (lazy)                                    (triggers execution)
```

Example:

```java
List<String> names = List.of("Alice", "Bob", "Alice", "Charlie");

List<String> result =
        names.stream()           // source
             .filter(n -> n.length() <= 4)   // intermediate
             .distinct()                     // intermediate
             .sorted()                       // intermediate
             .toList();                      // terminal (Java 16+)
```

---

## 2. Core operations: `filter`, `map`, `flatMap`, `distinct`, `sorted`

### 2.1 `filter` – keep only matching items

```java
List<User> users = ...;

List<User> activeAdults =
        users.stream()
             .filter(User::isActive)
             .filter(u -> u.getAge() >= 18)
             .toList();
```

### 2.2 `map` – transform each element

```java
List<User> users = ...;

List<String> emails =
        users.stream()
             .map(User::getEmail)
             .toList();
```

You can chain:

```java
List<String> normalizedEmails =
        users.stream()
             .map(User::getEmail)
             .filter(Objects::nonNull)
             .map(String::trim)
             .map(String::toLowerCase)
             .toList();
```

### 2.3 `flatMap` – “split” and flatten

Use `flatMap` when each element becomes **0..n elements** (e.g. splitting strings, flattening child lists).

**Example 1: splitting a `String` field into tags**

```java
List<Article> articles = ...;   // article.getTagsCsv() = "java,spring,streams"

Set<String> uniqueTags =
        articles.stream()
                .map(Article::getTagsCsv)            // Stream<String>
                .filter(Objects::nonNull)
                .flatMap(csv -> Arrays.stream(csv.split(",")))  // Stream<String> of tags
                .map(String::trim)
                .filter(tag -> !tag.isEmpty())
                .collect(Collectors.toSet());
```

**Example 2: flattening nested lists**

```java
class Order {
    List<OrderLine> getLines() { ... }
}

List<Order> orders = ...;

List<OrderLine> allLines =
        orders.stream()
              .flatMap(order -> order.getLines().stream())
              .toList();
```

### 2.4 `distinct` – remove duplicates

```java
List<String> names = List.of("A", "B", "A");

List<String> uniqueNames =
        names.stream()
             .distinct()
             .toList();   // ["A", "B"]
```

For complex types, `distinct()` uses `equals`/`hashCode`.

### 2.5 `sorted` – sort elements

```java
List<User> users = ...;

List<User> sortedByName =
        users.stream()
             .sorted(Comparator.comparing(User::getName))
             .toList();

List<User> sortedByAgeDescThenName =
        users.stream()
             .sorted(Comparator
                     .comparingInt(User::getAge).reversed()
                     .thenComparing(User::getName))
             .toList();
```

---

## 3. Collectors basics (`collect`, `groupingBy`, etc.)

Most “end of pipeline” logic in production is done via `collect(...)`.

Common collectors:

* `Collectors.toList()`, `toSet()`, `toMap()`
* `Collectors.groupingBy(...)`
* `Collectors.partitioningBy(...)`
* `Collectors.counting()`, `summingInt(...)`, `averagingDouble(...)`
* `Collectors.mapping(...)`
* `Collectors.joining(...)`
* `Collectors.collectingAndThen(...)`

---

## 4. Grouping & aggregations (real-world style)

Assume:

```java
enum OrderStatus { NEW, PAID, SHIPPED, CANCELLED }

class Order {
    Long id;
    Long customerId;
    OrderStatus status;
    double amount;
    LocalDateTime createdAt;

    // getters...
}
```

### 4.1 Group orders by status

```java
Map<OrderStatus, List<Order>> ordersByStatus =
        orders.stream()
              .collect(Collectors.groupingBy(Order::getStatus));
```

### 4.2 Count orders per status

```java
Map<OrderStatus, Long> countByStatus =
        orders.stream()
              .collect(Collectors.groupingBy(
                       Order::getStatus,
                       Collectors.counting()));
```

### 4.3 Total revenue per customer

```java
Map<Long, Double> revenuePerCustomer =
        orders.stream()
              .collect(Collectors.groupingBy(
                       Order::getCustomerId,
                       Collectors.summingDouble(Order::getAmount)));
```

### 4.4 Multi-level grouping: by customer, then by status

```java
Map<Long, Map<OrderStatus, List<Order>>> byCustomerThenStatus =
        orders.stream()
              .collect(Collectors.groupingBy(
                       Order::getCustomerId,
                       Collectors.groupingBy(Order::getStatus)));
```

### 4.5 Group + transform + collect list of IDs

Orders IDs per customer, only PAID:

```java
Map<Long, List<Long>> paidOrderIdsPerCustomer =
        orders.stream()
              .filter(o -> o.getStatus() == OrderStatus.PAID)
              .collect(Collectors.groupingBy(
                       Order::getCustomerId,
                       Collectors.mapping(
                           Order::getId,
                           Collectors.toList())));
```

### 4.6 Find latest order per customer

```java
Map<Long, Optional<Order>> latestOrderPerCustomer =
        orders.stream()
              .collect(Collectors.groupingBy(
                      Order::getCustomerId,
                      Collectors.maxBy(
                          Comparator.comparing(Order::getCreatedAt))));
```

If you want **non-optional** (and know it exists):

```java
Map<Long, Order> latestOrderPerCustomerNonNull =
        orders.stream()
              .collect(Collectors.toMap(
                      Order::getCustomerId,
                      o -> o,
                      (o1, o2) -> o1.getCreatedAt().isAfter(o2.getCreatedAt()) ? o1 : o2
              ));
```

---

## 5. Filtering vs `partitioningBy`

### 5.1 Simple filter

```java
List<Order> highValue =
        orders.stream()
              .filter(o -> o.getAmount() > 1000.0)
              .toList();
```

### 5.2 `partitioningBy` – useful if you need both sides

```java
Map<Boolean, List<Order>> partitioned =
        orders.stream()
              .collect(Collectors.partitioningBy(
                      o -> o.getAmount() > 1000.0));

List<Order> highValue     = partitioned.get(true);
List<Order> normalOrders  = partitioned.get(false);
```

---

## 6. Typical production patterns

### 6.1 Top N customers by revenue

```java
Map<Long, Double> revenuePerCustomer = ...;  // from earlier

List<Long> top5Customers =
        revenuePerCustomer.entrySet().stream()
             .sorted(Map.Entry.<Long, Double>comparingByValue().reversed())
             .limit(5)
             .map(Map.Entry::getKey)
             .toList();
```

### 6.2 Log processing: count occurrences by level

```java
class LogEntry {
    LogLevel level;   // INFO, WARN, ERROR...
    String message;
    Instant timestamp;
}

Map<LogLevel, Long> countByLevel =
        logs.stream()
            .collect(Collectors.groupingBy(
                     LogEntry::getLevel,
                     Collectors.counting()));
```

### 6.3 Build CSV string of IDs (e.g. for logging)

```java
String idsCsv =
        orders.stream()
              .map(o -> Long.toString(o.getId()))
              .sorted()
              .collect(Collectors.joining(","));
```

### 6.4 De-duplicating by key (e.g. unique users by email)

There’s no built-in `distinctByKey` but you can do:

```java
List<User> uniqueByEmail =
        users.stream()
             .filter(distinctByKey(User::getEmail))
             .toList();

public static <T> Predicate<T> distinctByKey(Function<? super T, ?> keyExtractor) {
    Set<Object> seen = ConcurrentHashMap.newKeySet();
    return t -> seen.add(keyExtractor.apply(t));
}
```

*(Use carefully; not ideal for parallel streams.)*

### 6.5 “Split column” style: building index maps

Index users by department:

```java
class User {
    String department;
    String name;
}

Map<String, List<User>> usersByDepartment =
        users.stream()
             .collect(Collectors.groupingBy(User::getDepartment));
```

---

## 7. Performance & when *not* to use streams

Streams are great, but not always the best choice.

### 7.1 When streams are a **good fit**

Use streams when:

1. **Declarative transformations** over collections:

   * filter/map/aggregate logic on in-memory lists, maps, sets.
2. **Moderate data sizes**:

   * up to tens/hundreds of thousands of elements is usually fine.
3. Need to **chain operations clearly**:

   * e.g. “active → high value → sort → group.”
4. You prefer **functional style**, fewer mutable variables.

Streams shine in code like:

```java
List<Order> result =
        orders.stream()
              .filter(o -> o.getStatus() == PAID)
              .filter(o -> o.getAmount() > 500)
              .sorted(Comparator.comparing(Order::getCreatedAt))
              .toList();
```

### 7.2 When to avoid or be careful

Avoid streams (or at least think twice) if:

1. **Complex, stateful logic or heavy branching**

   * Many nested `if/else`, error handling branches → traditional `for` loop is clearer.
   * If your lambdas become long, move logic to named methods or consider loops.

2. **Mutable shared state in lambdas**

   * Example: modifying shared collections or counters inside `forEach` without proper synchronization.
   * That’s especially dangerous with **parallel streams**.

3. **Very performance-sensitive hot loops**

   * For tight loops (e.g. numerical computations, micro-optimizations), classic for-loops can be faster and avoid allocations.

4. **I/O-heavy pipelines**

   * Streams don’t magically handle blocking I/O better.
   * If you’re mixing DB calls, REST calls, or file I/O inside lambdas, readability and performance can suffer.

5. **Parallel streams by default**

   * `collection.parallelStream()` looks tempting but:

     * thread-pool is shared (`ForkJoinPool.commonPool`)
     * may cause contention with other parallel operations
     * great only when:

       * data is large,
       * operations are CPU-bound,
       * independent,
       * and you’ve profiled.

In most production code: **stick to sequential streams** unless you have a strong reason and a benchmark.

---

## 8. Style tips & best practices

* **Keep lambdas small.** If they grow, extract to `private` methods.
* **Use method references** (`User::getName`) where it reads cleaner.
* **Avoid side effects** in intermediate operations (`map`, `filter` etc.).
* Prefer `toList()` (Java 16+) over `collect(toList())` when you just need a `List`.
* For grouping results that will be reused heavily, consider materializing them into immutable structures or domain objects rather than nested `Map`s scattered around.
