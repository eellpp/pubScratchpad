### Why PostgreSQL and MySQL Struggle with On-the-Fly Aggregations

PostgreSQL and MySQL, as traditional relational databases, are highly optimized for **transactional workloads** (OLTP - Online Transaction Processing), such as managing individual records, handling reads/writes, and ensuring ACID compliance. However, when it comes to **on-the-fly aggregations** in **analytical workloads** (OLAP - Online Analytical Processing), they often struggle, especially at scale. Here are the key reasons why:

---

### 1. **Row-Based Storage Model**

Both PostgreSQL and MySQL use a **row-based storage model**, where data is stored row-by-row on disk. This is efficient for transactional queries that require fetching or updating individual rows, but it is less efficient for **aggregations** that need to scan large portions of the table and summarize data.

- **Problem:** Aggregations like `SUM()`, `COUNT()`, `AVG()`, and `GROUP BY` operations typically require reading a significant number of rows (sometimes the entire table) to perform calculations.
- **Impact:** For large datasets, this row-by-row access becomes I/O-bound and slow, as the database has to read every row to compute an aggregate, even when only a few columns are needed.

**Solution in Preaggregation Pipelines:**
- Preaggregation techniques store the aggregated data separately in a materialized view, summary table, or external data warehouse, reducing the need to scan raw data repeatedly.

---

### 2. **Lack of Columnar Storage (I/O Bottleneck)**

Modern analytical databases (like **ClickHouse**, **Google BigQuery**, and **Amazon Redshift**) use **columnar storage** instead of row-based storage. In a columnar format, values of the same column are stored together, allowing efficient access to specific columns needed for aggregations.

- **Problem:** In PostgreSQL and MySQL, the row-based storage requires the database to read all columns in each row even if only a few columns are needed for the aggregation.
- **Impact:** This leads to higher I/O overhead, as the database needs to fetch unnecessary data, slowing down aggregation queries.

**Solution in Preaggregation Pipelines:**
- Preaggregations allow aggregations to be precomputed and stored in a more optimized format (e.g., a summary table), which reduces the need for scanning raw data.

---

### 3. **Limited Parallelism and Query Optimization**

PostgreSQL and MySQL have limited capabilities when it comes to parallelizing complex aggregation queries across multiple CPU cores. While both databases have improved their parallel query execution over time, their native query optimizers and execution engines are not designed primarily for large-scale analytical queries.

- **Problem:** Aggregation queries, especially when involving `GROUP BY`, `ORDER BY`, and joins, are CPU-intensive and can take a long time to execute on large datasets, especially if they cannot fully utilize parallel processing.
- **Impact:** This leads to longer execution times, as these databases struggle to efficiently break down and parallelize large aggregation workloads.

**Solution in Preaggregation Pipelines:**
- Precomputing aggregates and storing them in summary tables reduces the complexity and need for heavy computation during query time, making it possible to fetch results quickly.

---

### 4. **No Built-In Data Partitioning for Aggregations**

While PostgreSQL and MySQL can partition data (e.g., using table partitioning), this is primarily designed to optimize **insert, update, and delete** operations. These partitions are not specifically designed for large-scale analytical queries.

- **Problem:** Without effective data partitioning for analytical queries, aggregation operations can require scanning large portions of data, increasing query execution times.
- **Impact:** Aggregation queries, especially on large datasets, result in slow performance as the database cannot efficiently scan subsets of the data based on query requirements.

**Solution in Preaggregation Pipelines:**
- Preaggregating data into smaller, query-specific partitions (e.g., daily, monthly aggregates) allows efficient querying without scanning large amounts of raw data.

---

### 5. **Aggregation in Transactional Workloads**

PostgreSQL and MySQL are primarily designed for transactional workloads, where the focus is on real-time updates, inserts, and deletions. Aggregation queries in these databases can negatively impact transactional performance due to locking, blocking, or causing contention.

- **Problem:** On-the-fly aggregation can create locks on the underlying tables, slowing down transactional operations. This is particularly problematic in OLTP environments where the database must handle both real-time updates and complex analytical queries.
- **Impact:** Performance degradation in high-concurrency environments, especially when aggregation queries are run concurrently with transactional operations.

**Solution in Preaggregation Pipelines:**
- Running preaggregation pipelines in a separate batch process minimizes the impact on live transactional workloads, ensuring the database can handle both OLTP and OLAP efficiently.

---

### 6. **Lack of Specialized Indexing for Aggregations**

PostgreSQL and MySQL use B-tree indexes by default, which are efficient for searching and filtering but are not optimized for analytical queries like aggregations and range scans. Aggregation queries often benefit from specialized indexing techniques like **bitmap indexes** or **sorted order of columns** that aren't natively supported in these databases.

- **Problem:** The lack of specialized indexing means that even with indexes, the database might still need to scan large portions of data to compute aggregations.
- **Impact:** This leads to slower queries, especially for `GROUP BY` or window functions.

**Solution in Preaggregation Pipelines:**
- Preaggregation pipelines reduce the need for specialized indexes by storing aggregated data in optimized structures for fast retrieval.

---

### 7. **Complex Joins in Aggregation Queries**

In many analytical workloads, aggregation queries involve complex joins across multiple tables (e.g., fact and dimension tables). PostgreSQL and MySQL can handle joins efficiently for small datasets, but as the dataset grows, the performance of such queries deteriorates significantly.

- **Problem:** Performing aggregations across multiple joined tables requires scanning, joining, and aggregating large amounts of data, which is resource-intensive in traditional relational databases.
- **Impact:** This results in slow queries, especially in scenarios where data is highly normalized, and large amounts of data must be joined before aggregation.

**Solution in Preaggregation Pipelines:**
- Preaggregating data into flat, denormalized tables or summary tables reduces the need for complex joins during query time, improving performance.

---

### 8. **Lack of Materialized Views for Fast Aggregations (In MySQL)**

While **PostgreSQL** supports **materialized views** (which can store precomputed results for faster querying), **MySQL** does not support materialized views natively. Materialized views allow aggregated data to be stored and refreshed periodically, reducing the need for on-the-fly aggregations.

- **Problem:** In MySQL, without materialized views, every aggregation query must compute the results from raw data every time it is executed.
- **Impact:** This leads to poor performance for frequently run aggregation queries.

**Solution in Preaggregation Pipelines:**
- Using external ETL pipelines to compute and store preaggregated results can simulate the behavior of materialized views, making aggregation queries faster.

---

### Conclusion: Why Preaggregation Pipelines Are Necessary

Given these challenges, **preaggregation pipelines** are often implemented to overcome the limitations of traditional relational databases like PostgreSQL and MySQL. Preaggregation involves computing and storing summarized, aggregated data in advance, reducing the need for complex on-the-fly queries. This is particularly useful in:

- **Data warehouses** where historical data needs to be summarized for reporting.
- **Real-time dashboards** where low-latency results are crucial.
- **High-volume analytics systems** where the cost of repeatedly scanning large datasets is prohibitive.

By using preaggregated data, queries can retrieve results from precomputed tables or views, significantly improving query performance and reducing computational overhead.
