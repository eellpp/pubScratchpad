# What “isolation” means

Isolation controls **how concurrent transactions see each other’s data**. It prevents anomalies like:

* **Dirty read**: T2 reads uncommitted changes from T1.
* **Non-repeatable read**: T2 re-reads a row and sees a different committed value because T1 committed in between.
* **Phantom read**: T2 re-runs a range query and gets extra/missing rows because T1 inserted/deleted and committed.
* **Write skew / lost updates**: concurrent writes violate invariants (esp. under snapshot isolation without row locks).

# JDBC isolation levels (standard constants)

```java
Connection.TRANSACTION_NONE
Connection.TRANSACTION_READ_UNCOMMITTED
Connection.TRANSACTION_READ_COMMITTED
Connection.TRANSACTION_REPEATABLE_READ
Connection.TRANSACTION_SERIALIZABLE
```

Typical guarantees (✔ prevented, ✖ allowed):

| Level            | Dirty Read | Non-repeatable Read | Phantoms         |
| ---------------- | ---------- | ------------------- | ---------------- |
| READ_UNCOMMITTED | ✖          | ✖                   | ✖                |
| READ_COMMITTED   | ✔          | ✖                   | ✖                |
| REPEATABLE_READ  | ✔          | ✔                   | ✖ (DB-specific*) |
| SERIALIZABLE     | ✔          | ✔                   | ✔                |

* **DB specifics**: e.g., InnoDB’s REPEATABLE READ uses **next-key locks**, preventing most phantoms on indexed ranges; PostgreSQL’s REPEATABLE READ is snapshot isolation (no dirty/non-repeatable reads, but **phantoms** can show as serialization errors only at SERIALIZABLE).

# How to use isolation in JDBC

## 1) Autocommit vs manual transactions

* JDBC default is `autoCommit=true` → every statement is its own transaction.
* For multi-statement transactions:

  ```java
  try (Connection c = ds.getConnection()) {
      c.setAutoCommit(false);
      c.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED); // pick level
      // do work (multiple statements)
      c.commit();
  } catch (SQLException e) {
      c.rollback();
  }
  ```

## 2) Setting and checking isolation support

```java
int current = c.getTransactionIsolation();
c.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

DatabaseMetaData md = c.getMetaData();
boolean supported = md.supportsTransactionIsolationLevel(
        Connection.TRANSACTION_REPEATABLE_READ);
```

If a level isn’t supported, the driver/DB may **silently upgrade/downgrade**—check with `getTransactionIsolation()` after setting.

## 3) Savepoints (partial rollbacks)

```java
c.setAutoCommit(false);
Savepoint sp = c.setSavepoint();
try {
    // step A
    // step B
} catch (SQLException e) {
    c.rollback(sp);   // undo B, keep A
}
c.commit();
```

## 4) Read-only & holdability hints

```java
c.setReadOnly(true);   // hint to DB for plan/locking optimizations
// Not a guarantee of no writes; still enforce at your code level.
```

# What each level means in practice (by popular DBs)

* **PostgreSQL**

  * Default: **READ COMMITTED**
  * `READ COMMITTED`: MVCC; each statement sees a fresh snapshot.
  * `REPEATABLE READ`: snapshot isolation for the whole transaction; prevents non-repeatable reads; write skew still possible.
  * `SERIALIZABLE`: true serializable via SSI; may throw serialization errors → **retry logic required**.

* **MySQL (InnoDB)**

  * Default: **REPEATABLE READ**.
  * Uses MVCC + **next-key locks**; at REPEATABLE READ, phantoms in many index-range cases are blocked.
  * Gap/next-key locks can reduce concurrency; be mindful of long scans in transactions.

* **Oracle**

  * Default: **READ COMMITTED**; supports `SERIALIZABLE`.
  * Doesn’t have READ_UNCOMMITTED/REPEATABLE_READ modes like others; uses consistent read (MVCC) plus locks when needed.
  * `SELECT … FOR UPDATE` for explicit write locks.

* **SQL Server**

  * Default: **READ COMMITTED** (locking) but can enable **READ_COMMITTED_SNAPSHOT** (MVCC).
  * Has **SNAPSHOT** isolation (similar to PG’s RR) and `SERIALIZABLE` (locking).

# Tools you’ll actually use

* **Pick the lowest isolation that preserves correctness.** Start with DB default (often READ COMMITTED or REPEATABLE READ).

* **Use explicit locks when needed**:

  * `SELECT ... FOR UPDATE` (PG/Oracle/MySQL) to prevent lost updates.
  * `SELECT ... WITH (UPDLOCK, ROWLOCK)` (SQL Server).

* **Optimistic concurrency**: a `version` or `updated_at` column; check before update:

  ```sql
  UPDATE account SET balance = ?, version = version + 1
  WHERE id = ? AND version = ?;
  ```

  If `rowsUpdated == 0`, someone else won → reload/retry.

* **Retry on serialization failures**: at SERIALIZABLE/SNAPSHOT levels you may get errors instead of blocking. Implement bounded retries with backoff.

* **Keep transactions short**: minimize time between `setAutoCommit(false)` and `commit()` to reduce lock contention and deadlocks.

* **Index your predicates**: range scans without indexes can escalate locks (MySQL next-key, SQL Server range locks) and tank concurrency.

* **Idempotency** for external side-effects: DB isolation doesn’t save you from duplicated API calls—use idempotency keys and unique constraints.

# Small, clear examples

## Example 1: money transfer (two updates → one transaction)

```java
try (Connection c = ds.getConnection()) {
    c.setAutoCommit(false);
    c.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);

    PreparedStatement debit = c.prepareStatement(
        "UPDATE account SET balance = balance - ? WHERE id = ?");
    PreparedStatement credit = c.prepareStatement(
        "UPDATE account SET balance = balance + ? WHERE id = ?");

    debit.setBigDecimal(1, amount);
    debit.setLong(2, fromId);
    if (debit.executeUpdate() != 1) throw new SQLException("Debit failed");

    credit.setBigDecimal(1, amount);
    credit.setLong(2, toId);
    if (credit.executeUpdate() != 1) throw new SQLException("Credit failed");

    c.commit();
} catch (SQLException e) {
    c.rollback();
    throw e;
}
```

Enhancements:

* Add `SELECT ... FOR UPDATE` on both rows first to avoid lost updates.
* Or optimistic version checks on the UPDATEs.

## Example 2: preventing phantom insert into a reserved range

At REPEATABLE READ, **some DBs** still allow phantoms unless range locks are taken. You can:

```sql
-- MySQL/PG/Oracle (syntax varies)
SELECT id FROM slots
WHERE date = ? AND room = ?
FOR UPDATE;
-- then insert the new slot safely
```

# Spring (if you use it)

```java
@Transactional(isolation = Isolation.READ_COMMITTED)
public void doWork() { ... }
```

Spring translates to JDBC calls on the underlying `Connection`. For retries on serialization failures, use `@Retryable` or manual retry loops.

# Common pitfalls

* Leaving `autoCommit=true` while expecting multi-statement atomicity.
* Setting isolation too high globally (pool-wide) and crushing throughput.
* Long-running transactions that mix user think-time with open locks.
* Assuming the same semantics across DBs at the same named level.
* Ignoring serialization exceptions at SERIALIZABLE—**you must retry**.


---

# “`SERIALIZABLE` isolation” **does not always mean “table lock.”**
The behavior depends on the database engine and its concurrency control model.


## 1. Lock-based engines (e.g., SQL Server, older DB2)

* At `SERIALIZABLE`, the engine must make concurrent transactions behave **as if they ran one after another**.
* To achieve this, the DB will:

  * Place **range locks** (not just row locks) when you scan a range with a predicate.
  * This blocks other transactions from inserting new rows into that range (preventing phantoms).
* If you do `SELECT * FROM accounts WHERE balance > 1000`, the DB will lock not only the matching rows but also the **gaps** where a new qualifying row could appear.
* This is *not* the whole table, but in practice long range scans can feel close to a table lock, since inserts/updates in wide ranges get blocked.


## 2. MVCC-based engines (PostgreSQL, Oracle, InnoDB in MySQL)

* They avoid coarse locks; instead they use **multiversion concurrency control (MVCC)** plus extra checks.
* PostgreSQL:

  * `SERIALIZABLE` uses **Serializable Snapshot Isolation (SSI)**.
  * Transactions run on snapshots (like REPEATABLE READ), but the system tracks **conflicting read/write dependencies**.
  * If conflicts would violate serializability, one transaction gets a **serialization failure** error, and you must retry.
  * So no table-wide locks, but you must handle errors and retries in your code.
* MySQL InnoDB:

  * Uses **next-key locks** (row + gap). So `SERIALIZABLE` often means blocking reads → lots of locks taken.
* Oracle:

  * Uses **consistent read snapshots**. At SERIALIZABLE, it prevents phantoms by ensuring that queries see a transaction-consistent snapshot. If a conflicting DML happens, your transaction may fail with `ORA-08177: can't serialize access`.


## 3. So does it “lock the entire table”?

* **No**, except in worst-case scenarios where:

  * Your query scans an unindexed predicate (`WHERE col LIKE '%x%'`), forcing a full table scan → the DB may escalate to table-level locks.
  * Or your DB implements SERIALIZABLE via pessimistic range/table locks (some older engines).



## 4. Practical implications for JDBC devs

* `SERIALIZABLE` is safest but reduces concurrency.
* In PostgreSQL/Oracle → expect **retries**.
* In MySQL (InnoDB) → expect **extra locking** that can feel heavy if your ranges are large or unindexed.
* In SQL Server → expect **range locks** (can escalate).
* General rule:

  * Use `READ COMMITTED` or `REPEATABLE READ` by default.
  * Use `SERIALIZABLE` **only if you truly need full consistency** (like preventing phantom insertions in reservation systems).
  * Implement retry logic for serialization failures.


Great — let’s unpack **“transactions run on snapshots”** because it’s central to understanding modern databases (Postgres, Oracle, InnoDB, etc.) and their isolation levels.

---

# 🔹 What a “snapshot” means

* When a transaction begins, the database takes a **logical view** of the data at that moment in time.
* All queries inside the transaction **read from this snapshot**, not from “live” changing rows.
* Other concurrent updates/inserts/deletes by different transactions are invisible until you commit and start a new transaction.

So:
👉 You get a **frozen picture of the database** when your transaction started (or at statement start, depending on isolation level).

---

# 🔹 How snapshots are implemented (MVCC)

* Databases that use **Multi-Version Concurrency Control (MVCC)** keep multiple versions of rows:

  * Each row has metadata: `created_by_txn_id`, `deleted_by_txn_id`.
  * A transaction only sees rows that were valid at its snapshot time.
* This means readers don’t block writers:

  * If Transaction A updates a row, Transaction B can still read the old version from before A committed.

---

# 🔹 Snapshots at different isolation levels

1. **READ COMMITTED**

   * Each *statement* gets its own fresh snapshot.
   * So if you run the same query twice in one transaction, you might see different results (non-repeatable read).
   * Example:

     ```
     T1: BEGIN
     T1: SELECT balance FROM account WHERE id=1;  -- sees 100
     T2: UPDATE account SET balance=200 WHERE id=1; COMMIT
     T1: SELECT balance FROM account WHERE id=1;  -- sees 200
     ```

     Snapshot refreshed per statement.

2. **REPEATABLE READ (Postgres/InnoDB)**

   * One snapshot is taken at **transaction start**.
   * Every SELECT in the transaction sees the same snapshot → no non-repeatable reads.
   * But in some DBs (Postgres) you can still get **phantoms**: another transaction inserts a new row that matches your range, you won’t see it.
   * MySQL InnoDB, with next-key locks, blocks those inserts, so no phantoms there.

3. **SERIALIZABLE (Postgres)**

   * Still snapshot-based.
   * But DB tracks *read/write conflicts* between snapshots.
   * If two concurrent transactions could lead to an outcome that isn’t serializable, one gets rolled back with `serialization_failure`.
   * This is **Serializable Snapshot Isolation (SSI)**.

---

# 🔹 Example: Reservation system

Suppose two customers try to book the last seat:

### With REPEATABLE READ

* Both T1 and T2 start → they each get a snapshot showing seat=available.
* Both insert bookings.
* Depending on DB, both might succeed → overbooking (write skew).

### With SERIALIZABLE (snapshot + conflict checks)

* Both T1 and T2 start with seat=available.
* Both try to book → system detects this conflict at commit.
* One transaction is aborted: must retry.
* Outcome is equivalent to “transactions ran one after the other.”

---

# 🔹 Key takeaway

* **Snapshot isolation** = “you live inside a frozen photograph of the database” for the duration of your transaction.
* It avoids locks for most reads, improves concurrency, and makes reasoning easier.
* But: anomalies like **write skew** can still happen unless the DB enforces full SERIALIZABLE with conflict detection.

---

