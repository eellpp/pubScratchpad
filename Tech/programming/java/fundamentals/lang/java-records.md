# ✅ What Are Records?

A **record** is a special kind of class designed to model **data-carrier objects** (“immutable DTOs”) with:

* concise declaration
* automatically generated methods
* strong, explicit meaning of data

They are ideal for:

* DTOs
* API request/response objects
* Value objects
* Events / messages
* Return tuples

> **Version history**
> | Version | Status |
> |--------|--------|
> | Java 14 | Preview |
> | Java 15 | 2nd Preview |
> | **Java 16** | **Finalized** |
> | Java 17+ | Fully stable (LTS) |

---

# 🧱 Basic Syntax

```java
public record User(String name, int age) {}
```

This automatically generates:

```
private final String name;
private final int age;

public User(String name, int age) { ... }

public String name();
public int age();

public boolean equals(Object o);
public int hashCode();
public String toString();
```

Yes — you get all that for free.

---

# 🎯 Key Characteristics

### ✔ Records are **immutable data carriers**

* Fields are `final`
* No setters
* Canonical constructor enforces values at creation

```java
User u = new User("Bob", 30);
u.name(); // OK
// u.name = "Sam"; ❌ not allowed
```

---

# 🔍 Components vs Fields

Record header defines **components**

```java
record Point(int x, int y) {}
```

This creates **fields + accessor methods** with same name:

```java
Point p = new Point(10, 20);
p.x(); // 10
p.y(); // 20
```

There are **no getter names like getX()** — accessors = component names.

---

# ✂ Constructors

## 1️⃣ Canonical constructor

Same parameters as record components.

```java
public record User(String name, int age) {
    public User {
        if (age < 0) throw new IllegalArgumentException("Age must be positive");
        name = name.trim();
    }
}
```

This is called a **compact constructor**.

Rules:

* Parameters implicitly exist
* Must assign all fields before exit
* Great for validation & normalization

## 2️⃣ Full canonical constructor (expanded form)

```java
public record User(String name, int age) {
    public User(String name, int age) {
        if (age < 0) throw new IllegalArgumentException();
        this.name = name;
        this.age = age;
    }
}
```

Works the same, just more verbose.

---

# ⚙ Additional Members Allowed

You can still add:

* methods
* static fields
* static methods
* nested types

Example:

```java
public record Rectangle(int width, int height) {

    public int area() {
        return width * height;
    }

    public static Rectangle square(int size) {
        return new Rectangle(size, size);
    }
}
```

What you **cannot** add:

* instance fields other than those defined in header
* mutable instance variables
* setters

---

# 🔒 Immutability — What It Really Means

Record fields are **shallowly immutable**:

```java
record Order(String id, List<String> items) {}
```

* `id` cannot change
* but `items` list is still mutable

Best practice: enforce deep immutability:

```java
public record Order(String id, List<String> items) {
    public Order {
        items = List.copyOf(items);
    }
}
```

---

# 🧠 equals / hashCode / toString

Automatically implemented based on **state**, not identity.

```java
User u1 = new User("Bob", 30);
User u2 = new User("Bob", 30);

u1.equals(u2); // true
u1.hashCode() == u2.hashCode(); // true
System.out.println(u1);
// Output: User[name=Bob, age=30]
```

This makes them great for:

* caches
* maps
* sets
* logs

---

# ⚠️ Restrictions & Rules

Records:
❌ cannot extend classes
✔ implicitly `final`
✔ can implement interfaces

```java
record Event(String id) implements Serializable, Runnable { ... }
```

No subclassing records.

---

# 🔄 Records + Pattern Matching (Java 21)

Records shine with pattern matching.

```java
record Point(int x, int y) {}

static String describe(Point p) {
    return switch(p) {
        case Point(int x, int y) -> "Point at %d,%d".formatted(x,y);
    };
}
```

Record patterns:

```java
if (p instanceof Point(int x, int y)) {
    System.out.println(x + ", " + y);
}
```

Cleaner destructuring 🎉

---

# 🧬 Records + Sealed Types

Perfect combo.

```java
sealed interface Shape permits Circle, Rectangle {}

record Circle(double r) implements Shape {}
record Rectangle(double w, double h) implements Shape {}
```

Then:

```java
double area = switch(shape) {
    case Circle c -> Math.PI * c.r() * c.r();
    case Rectangle r -> r.w() * r.h();
};
```

✔ compiler enforces exhaustiveness
✔ no default needed

---

# 🗄 Serialization

Records support:

* Java Serialization
* JSON (e.g., Jackson)
* persistence frameworks

Example Jackson:

```java
record User(String name, int age) {}
```

Works automatically in modern versions of Jackson.

---

# 🏭 Builders?

Records don’t come with builders (by design), but if needed:

```java
public record User(String name, int age) {
    public static class Builder {
        private String name;
        private int age;
        public Builder name(String n) { name=n; return this; }
        public Builder age(int a) { age=a; return this; }
        public User build() { return new User(name, age); }
    }
}
```

But usually:

* use compact constructor instead
* or `withers` pattern

---

# 🔥 Real-World Use Cases

### ✔ DTOs for REST APIs

```java
public record CreateUserRequest(String name, String email) {}
```

### ✔ Kafka / messaging events

```java
public record OrderPlaced(String orderId, double amount) {}
```

### ✔ Value Objects

```java
public record Money(BigDecimal value, String currency) {}
```

### ✔ Return multiple values cleanly

Instead of:

```java
return Map.entry(x, y);
```

Do:

```java
return new Range(min, max);
```

---

# ⚠️ When NOT to Use Records

Avoid records when:

❌ you need mutable state
❌ identity matters more than value
❌ inheritance hierarchy required
❌ heavy behavior objects
❌ requires complex lifecycle

Prefer regular classes for entities like:

* JPA/Hibernate entities
* long-lived domain objects
* objects with change-tracking

---

# 🧑‍💻 Best Practices

✔ Use records for **data-first** modeling
✔ Validate in compact constructor
✔ Defend immutability for mutable types (`List.copyOf`)
✔ Prefer small, simple records
✔ Combine with sealed interfaces
✔ Use with pattern matching

---

# 🗂 Quick Summary

| Feature          | Meaning                         |
| ---------------- | ------------------------------- |
| Purpose          | concise immutable data class    |
| Fields           | final, generated                |
| Methods          | equals, hashCode, toString auto |
| Inheritance      | cannot extend classes           |
| Version          | Final since **Java 16**         |
| Works great with | pattern matching & sealed types |
| Best for         | DTOs, value objects, API data   |



#  **“records + Jackson”** guide for Java 17+

## 1. Versions & prerequisites

* **Java:** 16+ (records finalized in 16, commonly used with 17+)
* **Jackson:** **2.12+** → native support for records (no extra module needed). ([Medium][1])
* **Spring Boot:** 2.6+ / 3.x (comes with a Jackson version that supports records). ([sivalabs.in][2])

If you’re using plain Maven:

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.16.2</version> <!-- or latest stable -->
</dependency>
```

---

## 2. The simplest case: record ↔ JSON

### Java record

```java
public record UserDto(
        String name,
        int age
) {}
```

### Serialize

```java
ObjectMapper mapper = new ObjectMapper();

UserDto user = new UserDto("Alice", 30);
String json = mapper.writeValueAsString(user);
// {"name":"Alice","age":30}
```

### Deserialize

```java
UserDto restored = mapper.readValue(json, UserDto.class);
// restored.name() -> "Alice"
```

Jackson:

* Detects it’s a **record**
* Uses the **canonical constructor** (`UserDto(String, int)`)
* Binds JSON fields → record components by **name** ([GitHub][3])

---

## 3. Field naming & `@JsonProperty`

If JSON names differ from record component names, use `@JsonProperty` on **components**:

```java
public record UserDto(
        @JsonProperty("full_name") String name,
        @JsonProperty("years") int age
) {}
```

JSON:

```json
{"full_name": "Alice", "years": 30}
```

Jackson will call `new UserDto("Alice", 30)` correctly. ([Carlos Chacin][4])

You almost never need `@JsonCreator` for records, because the canonical ctor is used automatically as long as names match (or are annotated).

---

## 4. Collections & nested records

### Collections

```java
public record OrderDto(
        String id,
        List<String> items,
        double total
) {}
```

JSON:

```json
{
  "id": "ORD-1",
  "items": ["apple", "banana"],
  "total": 12.5
}
```

This works out-of-the-box.

### Nested records

```java
public record AddressDto(
        String line1,
        String city,
        String country
) {}

public record CustomerDto(
        String id,
        String name,
        AddressDto address
) {}
```

Jackson recursively uses records for nested values as normal POJOs.

---

## 5. Dates & times with `JavaTimeModule`

Records don’t change anything here; it’s standard Jackson Java-time setup. But you almost *always* want proper support for `LocalDate`, `Instant`, etc.

```java
ObjectMapper mapper = JsonMapper.builder()
        .addModule(new JavaTimeModule())
        .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS)
        .build();
```

Example:

```java
public record EventDto(
        String id,
        Instant occurredAt
) {}
```

With `JavaTimeModule`, this will serialize as an ISO-8601 string instead of a numeric timestamp. ([nixstech.com][5])

---

## 6. Validation & normalization (compact ctor)

You use the **compact constructor** to validate/normalize incoming JSON:

```java
public record UserDto(
        String name,
        int age,
        List<String> roles
) {
    public UserDto {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("name is required");
        }
        if (age < 0) {
            throw new IllegalArgumentException("age must be >= 0");
        }
        roles = List.copyOf(roles == null ? List.of() : roles); // defensive copy
        name = name.trim();
    }
}
```

Jackson will:

1. Build the arguments from JSON
2. Call that canonical constructor
3. Your checks run **on both deserialize and normal construction**

---

## 7. Ignoring fields / controlling output

### `@JsonIgnore`

If you don’t want a component to appear in JSON:

```java
public record UserDto(
        String name,
        @JsonIgnore String internalToken
) {}
```

JSON will only include `name`.

### `@JsonInclude`

To drop `null` values globally:

```java
ObjectMapper mapper = JsonMapper.builder()
        .serializationInclusion(JsonInclude.Include.NON_NULL)
        .build();
```

Or per record:

```java
@JsonInclude(JsonInclude.Include.NON_NULL)
public record UserDto(
        String name,
        String nickname // omitted if null
) {}
```

---

## 8. Spring Boot + records (REST DTOs)

With Spring Boot 3.x (which uses Jackson with record support), you can just do:

```java
public record CreateUserRequest(
        String name,
        String email
) {}

@RestController
@RequestMapping("/users")
public class UserController {

    @PostMapping
    public UserDto create(@RequestBody CreateUserRequest request) {
        // request.name(), request.email()
        return new UserDto("123", request.name(), request.email());
    }
}
```

* Request JSON → `CreateUserRequest` record
* Response record → JSON
* No extra Jackson config needed in a typical Spring Boot app ([Okta Developer][6])

---

## 9. Records + sealed interfaces + polymorphic JSON

For polymorphic JSON (inheritance), combine sealed interfaces + records + Jackson type metadata.

### Domain

```java
public sealed interface PaymentCommand permits CardPayment, UpiPayment {}

public record CardPayment(
        String cardNumber,
        String currency,
        double amount
) implements PaymentCommand {}

public record UpiPayment(
        String upiId,
        double amount
) implements PaymentCommand {}
```

### Jackson configuration with type info

Option 1: annotate the **sealed interface**:

```java
@JsonTypeInfo(
        use = JsonTypeInfo.Id.NAME,
        include = JsonTypeInfo.As.PROPERTY,
        property = "type"
)
@JsonSubTypes({
        @JsonSubTypes.Type(value = CardPayment.class, name = "card"),
        @JsonSubTypes.Type(value = UpiPayment.class, name = "upi")
})
public sealed interface PaymentCommand permits CardPayment, UpiPayment {}
```

JSON for `CardPayment`:

```json
{
  "type": "card",
  "cardNumber": "4111 1111 1111 1111",
  "currency": "INR",
  "amount": 1000.0
}
```

Deserializing:

```java
PaymentCommand cmd = mapper.readValue(json, PaymentCommand.class);
```

Jackson will instantiate the right record (CardPayment / UpiPayment) and call its canonical ctor.

---

## 10. Common pitfalls & how to avoid them

### ❌ Pitfall 1: Using older Jackson version

If your Jackson < 2.12:

* Records may not be recognized properly
* You’ll see weird deserialization errors or reflection hacks
  → **Fix:** upgrade to 2.12+ (prefer 2.15/2.16+). ([Reddit][7])

---

### ❌ Pitfall 2: Mismatched field names

If JSON field names don’t match record component names **and you don’t use `@JsonProperty`**, Jackson will either:

* Fail to construct, or
* Set default values (`0`, `null`, `false`)

Always:

* Match names exactly **or**
* Use `@JsonProperty` on each mismatched component.

---

### ❌ Pitfall 3: Mutable components

```java
public record OrderDto(
        String id,
        List<String> items
) {}
```

Caller could still mutate `items`:

```java
OrderDto order = mapper.readValue(json, OrderDto.class);
order.items().add("hacked"); // modifies underlying list
```

If you care about *deep* immutability:

```java
public record OrderDto(
        String id,
        List<String> items
) {
    public OrderDto {
        items = List.copyOf(items);
    }
}
```

---

### ❌ Pitfall 4: Framework expects no-arg ctor + setters (JPA-style)

Records don’t have:

* no-arg constructor
* setters
* non-final fields

So you should **not** use records as JPA entities etc. Use them for:

* DTOs
* API contracts
* value objects
* events

---

## 11. Recommended patterns (for production)

1. **Use records as DTOs**, not entities

   * REST request/response
   * messaging payloads
   * config objects

2. **Validate in compact ctor**

   * ensure JSON → only valid objects exist in your system

3. **Use `@JsonProperty` for any naming differences**

4. **Add `JavaTimeModule`** for all Java time types

5. **Defend against mutable nested state**

   * `List.copyOf`, `Set.copyOf`, etc.

6. **Use sealed interfaces + records + `@JsonTypeInfo`** for polymorphic APIs

---


[1]: https://medium.com/%40anurag.ydv36/java-records-jackson-the-cleanest-dto-setup-ive-ever-built-235658b4df5b?utm_source=chatgpt.com "Java Records + Jackson: The Cleanest DTO Setup I've ..."
[2]: https://www.sivalabs.in/blog/using-java-records-with-spring-boot-3/?utm_source=chatgpt.com "Using Java Records with Spring Boot 3"
[3]: https://github.com/FasterXML/jackson-databind/issues/2709?utm_source=chatgpt.com "Support for JDK 14 record types (Jackson 2.12.0) #2709"
[4]: https://carloschac.in/2021/03/04/jacksonrecords/?utm_source=chatgpt.com "Java Records with Jackson 2.12 - Carlos Chacin"
[5]: https://nixstech.com/news/migrating-a-project-from-java-11-to-java-17-a-step-by-step-guide-for-developers/?utm_source=chatgpt.com "Migrating a Project From Java 11 to Java 17: A Step-by- ..."
[6]: https://developer.okta.com/blog/2021/11/05/java-records?utm_source=chatgpt.com "Java Records: A WebFlux and Spring Data Example"
[7]: https://www.reddit.com/r/java/comments/m9duv8/now_that_records_are_official_hoping_for_expanded/?utm_source=chatgpt.com "Now that records are official, hoping for expanded support ..."

