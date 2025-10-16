**What are the various datetime types in hive?**
- Date 
- TIME 
- TIMESTAMP (java.sql.Timestamp) 

# Timestamp Issue
For timestamp column the incoming data is assumed to UTC and hive converts to servers timezone when reading it (and does not provide the raw data as it is )

Hive stores timestamp as java.sql.Timestamp which stores values as offset from 1970    
Thus, hive TIMESTAMP has no timezone: It represents an instant (usually stored/handled as UTC) but displays per session TZ.

- If incoming data is in NY timezone (or any other non UTC) timezone this would cause issue. Since UTC assumption is invalid.
- Each reader will gets its own local time shifted value when reading (instead of raw data)

## 1. How Hive stores and interprets `TIMESTAMP`

* **Storage**: Hive’s `TIMESTAMP` type is meant to represent an **absolute instant in time**. Internally (ORC/Parquet), most engines write it normalized to **UTC**, even if you load data in another timezone.
* **Display**: When you `SELECT` from Hive, it renders that instant according to the **session time zone** (by default, the HiveServer2 JVM’s system timezone).
* **Result**: The same stored value will *print differently* depending on who queries it, since the rendering depends on the reader’s session TZ.

---

## 2. Why “raw value” is lost

* When you ingest a bare string like `2023-01-01 04:06:19.323` into a `TIMESTAMP` column:

  * Hive parses it as if it were **in the current session time zone** (e.g. EST).
  * It immediately converts that to a UTC instant.
  * From then on, you’ve lost the knowledge that the original string was “04:06 EST”. You only have the instant.
* When another reader connects (say in Singapore), Hive takes that instant and shows it in *their* session time zone. They’ll see `2023-01-01 17:06:19.323`, not the raw text.

So yes — you don’t get back what you ingested. You get a “shifted” rendering.

---

## 3. Why this bites people

1. **Analyst expectation**: People often expect `SELECT *` to show exactly what was loaded from CSV. But TIMESTAMP silently normalizes.
   → The New York analyst sees `04:06`, the Singapore analyst sees `17:06`.
2. **Partitioning**: If you partition by date derived from `TIMESTAMP`, users in different zones may think rows belong to “wrong” days.
3. **ETL cross-loads**: If Spark writes to Parquet in UTC but Hive reads with EST session, times can look shifted by several hours.
4. **Debugging hell**: CSV backups, logs, or audits show “raw” values, but Hive queries don’t match unless you force UTC rendering.

---

## 4. If you want the raw value

You need to avoid automatic interpretation:

* **Option A: Store as `STRING`**
  Keep the original text exactly as-is. Add a parallel `TIMESTAMP_UTC` column for normalized use.
* **Option B: Store both**
  One column for raw string (or “local wall clock”), one column converted to UTC for analytics.
* **Option C: Use `from_unixtime` / `to_utc_timestamp` explicitly**
  Parse with explicit zone conversion so it’s clear in ETL what the stored UTC instant should be.

---

## 5. Golden rule

👉 Hive `TIMESTAMP` is *not* a “raw local datetime”. It is “an instant normalized to UTC, shown in your session TZ”.
If you need the literal string or the local wall time semantics (e.g. “the shop opened at 9am local”), you **must store it separately** (e.g., as STRING + TZ column).





