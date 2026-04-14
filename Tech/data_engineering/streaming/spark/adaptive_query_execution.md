**official doc**:   
https://spark.apache.org/docs/latest/sql-performance-tuning.html#adaptive-query-execution

Adaptive Query Execution (AQE) is an optimization technique in Spark SQL that makes use of the runtime statistics to choose the most efficient query execution plan, which is enabled by default since Apache Spark 3.2.0. 
Spark SQL can turn on and off AQE by spark.sql.adaptive.enabled as an umbrella configuration.

This feature coalesces the post shuffle partitions based on the map output statistics when both spark.sql.adaptive.enabled and spark.sql.adaptive.coalescePartitions.enabled configurations are true. 
This feature simplifies the tuning of shuffle partition number when running queries. You do not need to set a proper shuffle partition number to fit your dataset. 
Spark can pick the proper shuffle partition number at runtime once you set a large enough initial number of shuffle partitions via spark.sql.adaptive.coalescePartitions.initialPartitionNum configuration.


Key Default AQE Configuration Settings:
```bash
Enabled: spark.sql.adaptive.enabled = true (Enabled by default in Spark 3.2.0+).
Coalesce Partitions: spark.sql.adaptive.coalescePartitions.enabled = true.
Advisory Partition Size: spark.sql.adaptive.advisoryPartitionSizeInBytes = 64MB.
Join Optimization: spark.sql.adaptive.join.enabled = true (enables broadcast join conversion).
Skewed Join Optimization: spark.sql.adaptive.skewJoin.enabled = true.
Skewed Factor: spark.sql.adaptive.skewJoin.skewedPartitionFactor = 5.
Skewed Threshold: spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes = 256MB.
```
Other Essential Defaults:
```bash
Initial Shuffle Partitions: spark.sql.shuffle.partitions = 200.
Auto Broadcast Threshold: spark.sql.autoBroadcastJoinThreshold = 10MB
```

# 🧠 Spark AQE – Practical User Guide (Spark 3.3.x)

## 1. What AQE *Actually Does* (Mental Model)

Think of AQE as:

> **“Runtime optimizer for shuffle-heavy queries”**

Instead of relying purely on static planning, Spark:

* Observes **actual data sizes at runtime**
* Adjusts execution **after shuffle stages**

### Core capabilities:

| Feature                          | What it does                              |
| -------------------------------- | ----------------------------------------- |
| **Shuffle partition coalescing** | Reduces too many small partitions         |
| **Skew handling**                | Splits large skewed partitions            |
| **Join strategy switching**      | Converts SMJ → Broadcast Join dynamically |
| **Local shuffle reader**         | Avoids unnecessary data movement          |

---

## 2. When You SHOULD Use AQE

AQE is most useful when your data is:

### ✅ Highly variable / unpredictable

* Daily partitions with uneven sizes
* Backfills vs incremental loads
* API ingestion variability

### ✅ Shuffle-heavy queries

* `groupBy`, `join`, `distinct`
* Aggregations over large datasets

### ✅ Skew-prone data

* Few keys dominating (e.g., popular users, regions)

### ✅ Multi-tenant / generic pipelines

* You cannot hardcode partition counts

---

## 3. When AQE Helps (Real Scenarios)

### Example 1: Aggregation with unknown size

```python
df.groupBy("user_id").count()
```

AQE:

* Reduces 200 shuffle partitions → maybe 20
* Improves task efficiency

---

### Example 2: Skewed join

```python
df1.join(df2, "user_id")
```

AQE:

* Detects skewed keys
* Splits large partitions
* Avoids long tail tasks

---

### Example 3: Join strategy switch

```python
large_df.join(small_df, "id")
```

AQE:

* If `small_df` is smaller than expected
* Converts to **Broadcast Join automatically**

---

## 4. What AQE DOES NOT Do (Common Misconceptions)

This is where most confusion happens 👇

### ❌ AQE does NOT control final file count

> It optimizes **shuffle partitions**, not **output files**

👉 You will still get many small files if:

* Final stage has many partitions
* Output dataset is small

---

### ❌ AQE does NOT guarantee 128 MB files

```python
spark.sql.adaptive.advisoryPartitionSizeInBytes = 128MB
```

This is:

* A **target for shuffle partition sizing**
* NOT a guarantee for output file size

---

### ❌ AQE does NOT replace repartition/coalesce

If you want:

* Fixed number of output files
* Predictable layout in S3

👉 You still need:

```python
df.repartition(n)
```

---

### ❌ AQE does NOT eliminate bad initial configs

It improves things, but:

* Very high `spark.sql.shuffle.partitions` → still impacts execution
* Bad join conditions → still bad

---

## 5. Key Configurations (Spark 3.3.x)

### 🔹 Minimal recommended setup

```python
spark.conf.set("spark.sql.adaptive.enabled", "true")
spark.conf.set("spark.sql.adaptive.coalescePartitions.enabled", "true")
```

---

### 🔹 Critical (often missed)

```python
spark.conf.set(
  "spark.sql.adaptive.coalescePartitions.parallelismFirst",
  "false"
)
```

👉 Without this:

* Spark prioritizes **parallelism**
* Ignores your 128MB target
* Keeps too many partitions

---

### 🔹 Partition sizing

```python
spark.conf.set(
  "spark.sql.adaptive.advisoryPartitionSizeInBytes",
  128 * 1024 * 1024
)
```

---

### 🔹 Shuffle baseline

```python
spark.conf.set("spark.sql.shuffle.partitions", 200)
```

👉 AQE starts from here and adjusts downward

---

## 6. AQE Execution Flow (Mental Model)

```
Stage 1 → Shuffle → AQE observes stats
                ↓
        Adjust partitioning
                ↓
Stage 2 runs with optimized partitions
                ↓
Final write → uses resulting partitions
```

⚠️ Important:

> AQE decisions happen **between stages**, not at write time

---

## 7. Why You Got Many Small Files (Your Case)

Your scenario:

* Aggregation reduces dataset size drastically
* Final dataset is small
* Still many partitions survive

Result:
👉 Many tiny files

Because:

* AQE optimized shuffle
* But did not reduce final partitions enough
* And does not enforce output layout

---

## 8. Best Practices (Production)

### ✅ Use AQE for runtime optimization

Always enable for:

* ETL pipelines
* Adhoc queries
* Multi-tenant workloads

---

### ✅ Combine AQE + explicit control

| Goal                 | Approach            |
| -------------------- | ------------------- |
| Performance          | AQE                 |
| File size / count    | `repartition()`     |
| Skew handling        | AQE                 |
| Deterministic output | Manual partitioning |

---

### ✅ Pattern for S3 writes

```python
result_df = ...

# Use AQE for processing
# Then control output explicitly

result_df \
  .repartition(8) \
  .write \
  .mode("overwrite") \
  .parquet("s3://...")
```

---

### ✅ Choose partition count based on size

| Data Size | Suggested partitions |
| --------- | -------------------- |
| < 1 GB    | 1–4                  |
| 1–10 GB   | 8–32                 |
| 10–100 GB | 32–128               |

---

## 9. Debugging AQE (Very Important)

### 🔍 Check execution plan

```python
df.explain("formatted")
```

Look for:

* `AdaptiveSparkPlan`
* `CoalescedShufflePartitions`

---

### 🔍 Spark UI

In SQL tab:

* Compare **initial plan vs final plan**
* Look at:

  * Number of partitions
  * Skew handling
  * Join type changes

---

## 10. When NOT to Rely on AQE

Avoid depending solely on AQE when:

### ❌ Output file size matters (S3, Hive tables)

👉 Use `repartition()`

---

### ❌ Very small datasets

👉 AQE adds overhead

---

### ❌ Strict SLA pipelines

👉 Deterministic behavior preferred

---

### ❌ Streaming jobs

AQE support is limited / different

---

## 11. Golden Rule

> **AQE optimizes execution, not output layout**

If you remember just one thing, remember this.

---

## 12. Recommended “Safe Default” Setup

```python
spark.conf.set("spark.sql.adaptive.enabled", "true")
spark.conf.set("spark.sql.adaptive.coalescePartitions.enabled", "true")
spark.conf.set("spark.sql.adaptive.coalescePartitions.parallelismFirst", "false")
spark.conf.set("spark.sql.adaptive.advisoryPartitionSizeInBytes", 134217728)  # 128MB
spark.conf.set("spark.sql.shuffle.partitions", 200)
```

---

## 13. Final Insight (Important for Senior DE mindset)

AQE is:

* Not a magic optimizer
* Not a replacement for understanding partitioning
* Not a file layout tool

It is:

> A **runtime correction layer** over your logical plan




