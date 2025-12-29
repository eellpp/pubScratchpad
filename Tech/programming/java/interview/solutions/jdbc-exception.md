# In Spring `SQLException` (checked) → **translated** into `DataAccessException` (unchecked).

## 🔹 Why Spring does this

Spring **intentionally makes all data access exceptions unchecked**, i.e., they extend `RuntimeException`.

**Rationale:**

1. **Declarative transaction support:**
   If `DataAccessException` were checked, every repository or service method would need `throws` clauses or boilerplate `try/catch`. That breaks the declarative model where transactions roll back automatically on runtime exceptions.

2. **Layer decoupling:**
   Checked exceptions “leak” the persistence technology upward (e.g., `SQLException` or Hibernate’s). With unchecked, you can switch from JDBC to JPA or Mongo without changing service signatures.

3. **Cleaner business logic:**
   Business/service layers typically **can’t recover** from data access failures (network down, constraint violation, etc.). These should bubble up for centralized handling, not be force-caught.

4. **Consistent hierarchy:**
   `DataAccessException` forms a clean, **technology-agnostic hierarchy** (`DuplicateKeyException`, `DataIntegrityViolationException`, `CannotGetJdbcConnectionException`, etc.), all runtime exceptions.

---

### 🔹 Summary comparison

| Aspect               | `SQLException`        | `DataAccessException`                        |
| -------------------- | --------------------- | -------------------------------------------- |
| Type                 | Checked               | Unchecked (`RuntimeException`)               |
| Source               | JDBC API              | Spring Data Access layer                     |
| Scope                | Vendor-specific       | Vendor-neutral abstraction                   |
| Recovery expectation | Caller must handle    | Usually unrecoverable, bubble up             |
| Transaction behavior | No automatic rollback | Automatic rollback via AOP                   |
| Typical usage        | Low-level DAO code    | All Spring data frameworks (JDBC, JPA, etc.) |

---


## Plain JDBC throws checked `SQLException`

When you use raw JDBC:

```java
try (Connection con = dataSource.getConnection();
     PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=?")) {

    ps.setInt(1, 10);
    ResultSet rs = ps.executeQuery();

} catch (SQLException ex) {
    // must catch or declare
    throw new RuntimeException("DB failure", ex);
}
```

Here, `SQLException` is **checked**, vendor-specific (e.g., Oracle, Postgres) and full of internal codes.

---

## Spring’s JdbcTemplate layer catches it

Spring wraps that JDBC code inside its own template logic:

```java
// Inside JdbcTemplate.execute(...)
try {
    return action.doInStatement(stmt);
} catch (SQLException ex) {
    throw getExceptionTranslator().translate("StatementCallback", sql, ex);
}
```

So every `SQLException` is passed to a **SQLExceptionTranslator** which then converts to appropriate subclass of DataAccessException which is unchecked. 

---

### 🔹 3. Exception translation → DataAccessException hierarchy

Spring uses `SQLErrorCodeSQLExceptionTranslator` (or `SQLStateSQLExceptionTranslator`) to analyze the vendor codes and produce the right `DataAccessException` subtype.

Example translations:

| SQL State / Error Code | Vendor Example                   | Translated Exception                 |
| ---------------------- | -------------------------------- | ------------------------------------ |
| 23505                  | Postgres duplicate key           | `DuplicateKeyException`              |
| 40001                  | Deadlock / serialization failure | `DeadlockLoserDataAccessException`   |
| 08001                  | Connection failure               | `DataAccessResourceFailureException` |
| 22001                  | Data too long                    | `DataIntegrityViolationException`    |

So your code might throw:

```java
throw new DuplicateKeyException("Unique constraint violated", ex);
```

All of these extend **`DataAccessException`**, which extends **`RuntimeException`**.

If DataAccessException were checked, every repository or service method would need throws clauses or boilerplate try/catch. That breaks the declarative model where transactions roll back automatically on runtime exceptions.

---

### 🔹 4. What your code sees

At your DAO or service layer:

```java
@Repository
public class UserRepository {

    private final JdbcTemplate jdbc;

    public UserRepository(JdbcTemplate jdbc) { this.jdbc = jdbc; }

    public User findById(int id) {
        return jdbc.queryForObject("SELECT * FROM users WHERE id=?", mapper, id);
        // If something goes wrong:
        // - Duplicate key → DuplicateKeyException
        // - Connection down → DataAccessResourceFailureException
        // - SQL syntax error → BadSqlGrammarException
    }
}
```

Your service never needs to declare `throws SQLException`.
Instead, if something fails:

```java
try {
    userRepo.save(user);
} catch (DataAccessException dae) {
    // handle or log – unchecked, no boilerplate
    log.error("Database error code: {}", dae.getClass().getSimpleName(), dae);
}
```

---

## 🔹 5. Hierarchy snapshot (simplified)

```
DataAccessException (RuntimeException)
├── CleanupFailureDataAccessException
├── ConcurrencyFailureException
│   ├── DeadlockLoserDataAccessException
├── DataAccessResourceFailureException
├── DataIntegrityViolationException
│   └── DuplicateKeyException
├── DataRetrievalFailureException
├── InvalidDataAccessApiUsageException
├── TransientDataAccessResourceException
└── UncategorizedSQLException
```

Excellent question — this is a subtle but very important design decision in Spring’s philosophy.

Let’s break it down clearly:

---

## 🔹 In Good Design

✅ **Preferred:** Use unchecked exceptions (`DataAccessException`) for data access layers.
❌ **Avoid:** Throwing checked exceptions like `SQLException` or wrapping everything in custom checked wrappers.

---

### 🧭 Design Principle Summary

> *“Checked exceptions should signal conditions that the caller can meaningfully recover from.
> Data access failures are typically not one of them.”*

So — in good Spring design, `SQLException → DataAccessException` (unchecked) is **exactly the right approach**.


