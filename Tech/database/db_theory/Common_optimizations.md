In addition to **pushdown filters**, modern databases and query engines use several common optimization techniques to improve query performance, reduce resource usage, and increase throughput. These optimizations are particularly important in **big data** systems where queries can operate on massive datasets. Below are some of the most common query optimization techniques:

---

### **1. Predicate Pushdown (Filter Pushdown)**
- **Description**: As explained earlier, this technique pushes filtering operations (`WHERE` conditions) down to the data source, limiting the data processed early in the query execution.
- **Benefit**: Reduces data volume and computational cost by applying filters before expensive operations like joins and aggregations.
- **Common in**: **Spark**, **Hive**, **Presto**, **BigQuery**, **ClickHouse**, **Snowflake**, **Redshift**.

---

### **2. Column Pruning**
- **Description**: In columnar databases, **column pruning** ensures that only the columns required by the query are read from the disk or data source. For example, if a query selects only a few columns, other columns are pruned from the operation.
- **Benefit**: Reduces disk I/O and memory usage by avoiding reading unnecessary columns.
- **Common in**: **ClickHouse**, **BigQuery**, **Redshift**, **Vertica**, **Snowflake**, **Spark**.

---

### **3. Partition Pruning (Partition Elimination)**
- **Description**: In partitioned tables, this technique ensures that only the relevant partitions are scanned based on query filters (usually on partition keys like dates or IDs). If a filter condition limits the data to certain partitions, other partitions are skipped entirely.
- **Benefit**: Reduces the amount of data read and processed, leading to faster query execution.
- **Common in**: **Hive**, **Spark**, **BigQuery**, **Redshift**, **Snowflake**, **Oracle**, **PostgreSQL**.

---

### **4. Join Reordering**
- **Description**: The optimizer dynamically changes the order of joins based on table sizes, cardinality, and available indexes. For example, smaller tables or tables with selective filters are joined first, reducing the size of intermediate result sets.
- **Benefit**: Reduces memory and CPU usage during join operations by minimizing the number of rows being joined.
- **Common in**: **PostgreSQL**, **MySQL**, **Oracle**, **Hive**, **Spark**, **SQL Server**, **Snowflake**.

---

### **5. Index Usage Optimization**
- **Description**: Indexes (e.g., B-trees, hash indexes) are used to speed up data retrieval. The optimizer decides when and how to use indexes instead of full table scans based on the query structure and data characteristics.
- **Benefit**: Improves query performance by accessing only a subset of the data rather than scanning the entire table.
- **Common in**: **PostgreSQL**, **MySQL**, **SQL Server**, **Oracle**, **Cassandra**, **MongoDB**.

---

### **6. Pushdown Aggregation**
- **Description**: Similar to filter pushdown, aggregation operations (e.g., `SUM()`, `COUNT()`, `GROUP BY`) are pushed down to the storage or data source level. This reduces the data sent back to the query engine for further processing.
- **Benefit**: Minimizes the amount of data processed in the query engine by pre-aggregating data closer to the source.
- **Common in**: **Hive**, **Presto**, **BigQuery**, **Spark**, **ClickHouse**, **Redshift**, **Snowflake**.

---

### **7. Early Pruning (Projection Pushdown)**
- **Description**: This technique ensures that **projections** (selecting specific columns or fields) are pushed down before other operations like joins and aggregations. The database only processes the columns needed for the final result.
- **Benefit**: Reduces memory usage and speeds up query execution by limiting the amount of data involved in the operation.
- **Common in**: **BigQuery**, **Redshift**, **ClickHouse**, **Snowflake**, **PostgreSQL**, **Spark**.

---

### **8. Predicate/Expression Simplification**
- **Description**: The optimizer simplifies complex expressions (e.g., combining multiple conditions, constants) in the query before execution. For example, it might combine `WHERE a > 10 AND a > 20` into `WHERE a > 20` to reduce unnecessary checks.
- **Benefit**: Reduces computational overhead by minimizing redundant or unnecessary operations.
- **Common in**: **PostgreSQL**, **Oracle**, **SQL Server**, **Hive**, **Spark**.

---

### **9. Late Materialization**
- **Description**: This optimization delays the process of materializing (i.e., loading into memory) intermediate results until absolutely necessary. Only when the data is needed for the final query output will it be materialized in memory.
- **Benefit**: Saves memory and I/O by avoiding premature storage of intermediate results.
- **Common in**: **BigQuery**, **Redshift**, **ClickHouse**, **Snowflake**, **Vertica**.

---

### **10. Join Pushdown**
- **Description**: Similar to filter and aggregation pushdown, join operations can be pushed down to the storage layer or distributed nodes, allowing joins to be executed closer to the data. This is especially useful in distributed databases where shuffling large datasets between nodes can be expensive.
- **Benefit**: Reduces network traffic and improves performance by minimizing the amount of data moved between nodes.
- **Common in**: **Presto**, **Hive**, **BigQuery**, **Redshift**, **Snowflake**.

---

### **11. Predicate Pushdown on External Data Sources**
- **Description**: When querying external data sources (e.g., HDFS, S3, Parquet, ORC), pushdown filters and projections can be applied to the external source itself, ensuring only the necessary rows/columns are fetched.
- **Benefit**: Reduces the amount of data loaded into memory or processed in the query engine, improving both performance and resource efficiency.
- **Common in**: **Spark**, **Hive**, **Presto**, **Trino**, **BigQuery**, **Redshift Spectrum**.

---

### **12. Data Skipping**
- **Description**: Data skipping optimizations allow the query engine to skip entire blocks, partitions, or files that do not contain relevant data based on metadata (e.g., min/max values stored with data blocks). This is particularly useful in columnar formats like Parquet or ORC.
- **Benefit**: Reduces disk I/O by only reading relevant data blocks or partitions.
- **Common in**: **ClickHouse**, **Snowflake**, **BigQuery**, **Presto**, **Trino**.

---

### **13. Adaptive Query Execution (AQE)**
- **Description**: Adaptive Query Execution dynamically changes the query execution plan based on runtime feedback. As the query progresses, the database adjusts the plan (e.g., reordering joins, repartitioning data) based on the actual data processed.
- **Benefit**: Increases the accuracy of execution plans by adjusting them in real-time based on actual data characteristics, improving performance.
- **Common in**: **Apache Spark** (from version 3.0+), **Google BigQuery**, **Snowflake**, **SQL Server** (via adaptive query processing).

---

### **14. Caching and Result Reuse**
- **Description**: Frequently executed queries or intermediate results are cached to avoid recomputation. When the same query or subquery is executed multiple times, the database can retrieve the cached result instead of re-running the query.
- **Benefit**: Significantly improves performance for repetitive queries by reducing CPU and I/O overhead.
- **Common in**: **Apache Spark**, **Presto**, **ClickHouse**, **BigQuery**, **Snowflake**.

---

### **15. Partition-Wise Joins**
- **Description**: This optimization technique breaks down large join operations by performing them at the partition level. If both tables are partitioned by the same key, joins are performed within each partition rather than across the entire dataset.
- **Benefit**: Reduces the complexity and resource consumption of join operations by limiting them to smaller, partitioned datasets.
- **Common in**: **Hive**, **Spark**, **Oracle**, **SQL Server**, **Redshift**.

---

### **Conclusion:**

These optimization techniques ensure that the **query engine** processes only the necessary data, applies operations efficiently, and minimizes resource usage (CPU, memory, I/O, network). Each optimization targets different stages of query execution (e.g., filtering, scanning, joining), and modern databases often use a combination of these techniques to handle **large-scale data** efficiently.

Choosing the right database or query engine often depends on how well it implements these optimizations, particularly in the context of specific workloads like OLTP (transactional), OLAP (analytical), real-time processing, or data warehousing.
