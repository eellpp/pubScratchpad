Java has several "gotchas" that can catch even seasoned developers by surprise if they aren’t aware of them. 

## Advanced

### jdbc driver getObject() 
Some DBs/drivers default to text protocol on the wire, so they naturally parse to String unless you ask for a numeric type. 

getObject() is driver-dependent. A SMALLINT can come back as a String, and if you treat that as “a 2-byte number,” you’ll get type bugs, wrong ordering, bigger payloads, and slower queries. Always use getShort() or getObject(col, Short.class), and normalize/validate at system boundaries.

Great catch. Here’s what’s going on and why it bites people.

#### What’s the gotcha?

* **SQL `SMALLINT` is 16-bit signed** (−32,768…32,767) on the database. But **JDBC doesn’t guarantee the Java type** you get back from `ResultSet.getObject(int/String)`. Depending on the driver, wire protocol (text vs binary), and settings, `getObject()` may return:

  * `Short` (what you hoped for),
  * `Integer` or `BigDecimal`,
  * **or a `String` containing the digits** (e.g., `"123"`).
* If you then assume “it’s only 2 bytes,” you’re mixing up **DB storage** with **Java object representation**. `"123"` is **3 characters** (and much more than 3 bytes in memory due to `String` overhead), so you can end up with:

  * **Bigger objects**, more GC pressure,
  * **Schema/type drift** when you pass data downstream,
  * **Bugs from lexicographic vs numeric behavior**.

#### How this causes issues

1. **ClassCastException at runtime**

   ```java
   Short s = (Short) rs.getObject("age"); // boom if it’s actually a String
   ```

2. **Silent logic errors** (no exception, wrong results)

   * Sorting or comparing as strings: `"100" < "20"` lexicographically.
   * Aggregations or validations treat numbers as text (e.g., `"05"` vs `"5"`).
   * Range filters become string comparisons if you aren’t careful.

3. **Query performance regressions**

   * Passing the value back with `setObject(i, "123")` may force **implicit casts** in SQL (string→smallint), which can **defeat indexes** and hurt plans.

4. **Data pipeline & serialization mismatches**

   * ORMs/ETL layers infer column types from runtime values; if they see a `String`, your Avro/Parquet/Kafka schema may record it as `string` instead of `int16`, breaking consumers.
   * JSON payload sizes and memory footprint increase.

5. **Locale/formatting edge cases**

   * If a driver (or your code) ever formats with locale, you can get unexpected characters (rare, but another footgun).

#### Why drivers do this

* Some DBs/drivers default to **text protocol** on the wire, so they naturally parse to `String` unless you ask for a numeric type.
* Older drivers/JDBC versions (or certain configuration flags) are looser in their mappings.
* JDBC spec only says `getObject()` returns a Java object representing the column—**it doesn’t pin it to a specific numeric class**.

#### How to defend yourself (do this!)

1. **Ask for the exact type you want**

   * Prefer primitives/getters:

     ```java
     short v = rs.getShort("age");         // canonical, fast
     boolean wasNull = rs.wasNull();
     ```
   * Or JDBC 4.1+ typed `getObject`:

     ```java
     Short v = rs.getObject("age", Short.class);
     ```

2. **If you must use raw `getObject()`, normalize defensively**

   ```java
   Object o = rs.getObject("age");
   short age;
   if (o == null) {
     // handle null
   } else if (o instanceof Number) {
     age = ((Number) o).shortValue();
   } else {
     age = Short.parseShort(o.toString().trim()); // last resort
   }
   ```

3. **Check metadata when you build generic layers**

   ```java
   int sqlType = rs.getMetaData().getColumnType(colIdx); // Types.SMALLINT?
   ```

   Use it to choose the getter (`getShort`) rather than `getObject`.

4. **Be explicit in ORMs/mappers**

   * Map `SMALLINT` to `short/Short` in JPA/Hibernate (`@Column(columnDefinition="SMALLINT")` or vendor-specific dialect hints).
   * For MySQL, review connector flags (e.g., tinyint/bit behaviors) and prefer **binary protocol** if your driver supports it.

5. **Validate at boundaries**

   * When writing back, use numeric setters:

     ```java
     ps.setShort(1, age);
     ```
   * Avoid `ps.setObject(1, "123")` for numeric columns.

6. **Test with your real driver + settings**

   * Unit/integration tests that **assert the runtime Java class** returned for each column type catch these surprises early.
.


## Basic 

1. **Autoboxing and Unboxing Pitfalls**: When Java automatically converts between primitive types (like `int`) and their wrapper classes (`Integer`), known as autoboxing/unboxing, subtle issues can arise. For instance, comparing `Integer` objects with `==` can lead to unexpected behavior due to caching and reference comparisons instead of value comparisons. The `==` operator compares references for objects, so two `Integer` objects with the same value might not be `==` unless they're within the cached range (-128 to 127)【28†source】【30†source】.

2. **Floating-Point Arithmetic**: Floating-point operations are inherently imprecise due to their binary representation, which can lead to unexpected results in arithmetic operations. Even seemingly simple calculations, like `0.1 + 0.2`, might yield a result that isn't exactly `0.3` due to rounding errors. It’s often better to use `BigDecimal` for financial calculations to avoid such issues【31†source】.

3. **Mutability of `String` and `StringBuilder` Behavior**: Java `String` objects are immutable, meaning any modification results in a new `String` object being created. This can be a performance issue in loops or repeated concatenations. Using `StringBuilder` or `StringBuffer` (for thread-safe needs) is preferable in such cases. Additionally, the `intern()` method on `String` can lead to memory leaks if not used carefully, as it places strings in a pool that is difficult to reclaim until the Java process ends【29†source】.

4. **Default Serialization Traps**: Java’s default serialization can be inefficient and can cause maintenance issues. It’s recommended to implement `Serializable` carefully, as serialization exposes private data and can lead to issues with backward compatibility if class structures change. Overriding `readObject` and `writeObject` methods is often needed to manage serialization effectively and securely【28†source】.

5. **Overuse of `Finalize()` and Garbage Collection Timing**: The `finalize()` method is not guaranteed to run in a timely manner, and it may not run at all if the object is never garbage-collected. Since Java 9, `finalize()` has been deprecated due to its unreliability. Instead, the `try-with-resources` statement is preferred for releasing resources like file streams or database connections【30†source】.

6. **Type Erasure with Generics**: Java generics use type erasure, which removes generic type information at runtime. This means that certain type checks (like checking if an object is an instance of a parameterized type) are not possible. For example, you can’t directly check if an `Object` is an instance of a generic type like `List<Integer>`. Additionally, this can cause issues with method overloading, as methods that differ only in generic parameters will cause a compile-time error【29†source】【31†source】.

7. **Concurrency and `HashMap`**: `HashMap` is not thread-safe, and using it in a concurrent setting can lead to infinite loops or data corruption. `ConcurrentHashMap` or `Collections.synchronizedMap` are better alternatives when thread safety is required. Similarly, common practices, like double-checked locking, are error-prone without `volatile`, due to Java’s memory model【32†source】【28†source】.

8. **Java ArrayLists do not shrink automatically** : 
