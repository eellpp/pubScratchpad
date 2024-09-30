**Pushdown filters** refer to a query optimization technique where the database or query engine "pushes down" filtering operations (e.g., `WHERE` conditions) as close to the data source as possible—typically before more computationally expensive operations like joins, aggregations, or scans. The goal of pushdown filters is to reduce the amount of data processed and moved around in the query execution process, improving query performance and minimizing resource usage.

### **How Pushdown Filters Work:**

When a query includes filtering conditions (e.g., `WHERE` clauses), instead of applying the filter after scanning or joining large datasets, the optimizer pushes the filter down to limit the data that needs to be processed early on. This means that the system only processes the subset of the data that meets the filter criteria, reducing the amount of data being moved, joined, or aggregated later in the execution.

For example:

#### **Before Pushdown Filter:**
```sql
SELECT * 
FROM orders 
JOIN customers ON orders.customer_id = customers.customer_id 
WHERE customers.country = 'USA';
```
In a **non-pushdown scenario**, the **JOIN** operation between `orders` and `customers` would happen first, and then the filter (`WHERE customers.country = 'USA'`) would be applied. This would potentially process all customers, including those outside the USA, and only later remove the rows that don't meet the filter.

#### **With Pushdown Filter:**
```sql
SELECT * 
FROM orders 
JOIN (SELECT * FROM customers WHERE country = 'USA') as filtered_customers 
ON orders.customer_id = filtered_customers.customer_id;
```
With **pushdown filters**, the filter condition (`customers.country = 'USA'`) is applied **before** the join happens, so the query engine only joins `orders` with the subset of customers from the USA, reducing the size of the dataset and the complexity of the join operation.

### **Benefits of Pushdown Filters:**

1. **Reduces Data Movement**:
   - In distributed databases, pushing down filters reduces the amount of data that needs to be transferred between nodes. If the system applies the filter early on (closer to the storage or data source), only the relevant rows are sent through the network.

2. **Minimizes Intermediate Data Size**:
   - By applying filters before performing expensive operations like joins or aggregations, pushdown filters reduce the size of intermediate datasets, lowering memory and CPU usage.

3. **Improves Query Performance**:
   - Queries run faster because the database or query engine processes only the relevant data, reducing the total computational workload.

4. **Optimizes I/O**:
   - Pushing down filters to the storage layer can reduce the amount of I/O needed to retrieve data, especially in large datasets or distributed systems where accessing and moving data can be costly.

### **Where Pushdown Filters Are Commonly Used:**

- **Distributed Databases**:
  In systems like **Apache Spark**, **Presto**, **BigQuery**, **ClickHouse**, and **Apache Hive**, pushdown filters are critical for optimizing distributed queries. By applying filters early, these systems minimize the amount of data shuffled between nodes in a cluster, reducing network overhead.

- **Columnar Databases**:
  Databases like **Redshift**, **BigQuery**, and **ClickHouse**, which use columnar storage formats, can push down filters to only read the necessary columns and rows. For example, if a filter on a column is applied, these databases can read just the specific column and filter out irrelevant rows before processing the query further.

- **External Data Sources**:
  In some query engines, pushdown filters can be applied to external data sources (e.g., HDFS, S3, Parquet, or CSV files). Instead of reading the entire dataset into memory and then applying the filter, the query engine will request only the filtered data from the external source, reducing I/O and processing time.

### **Example with Distributed Database (Apache Spark):**
```sql
SELECT name, age 
FROM people 
WHERE age > 30;
```
In **Apache Spark**, instead of reading all the rows of the `people` table into memory and then filtering them, the optimizer will push the filter (`age > 30`) down to the data source level (e.g., HDFS or Parquet). This means only the rows where `age > 30` will be read and processed, reducing data movement and I/O costs.

### **Pushdown Filters in OLAP Systems (ClickHouse, Presto, etc.):**

In **OLAP (Online Analytical Processing) systems** like **ClickHouse** or **Presto**, where large datasets are often queried, pushing down filters is crucial for minimizing query execution times. These systems typically operate on **columnar storage**, so pushing down filters allows them to scan only relevant columns and rows, skipping unnecessary data early in the query processing pipeline.

### **Limitations of Pushdown Filters:**

- **Complex Filters**: Some complex filters (e.g., those involving subqueries, window functions, or complex expressions) may not be eligible for pushdown, meaning the optimizer might have to apply them later in the query pipeline.
  
- **Not Always Applicable**: In certain cases, pushdown may not provide significant benefits if the filter doesn’t significantly reduce the dataset size, or if the query optimizer determines that other strategies are more efficient.

### **Conclusion:**

Pushdown filters are a key optimization technique that improves query performance by reducing the amount of data processed early in the query execution plan. By applying filters at the storage or data source level before more expensive operations like joins and aggregations, databases can minimize CPU, memory, and I/O usage, leading to faster query execution times and more efficient resource utilization.
