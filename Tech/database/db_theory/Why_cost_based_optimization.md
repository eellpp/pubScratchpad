http://jackywoo.cn/why-we-need-cbo-optimizer-en/

The blog post discusses two key examples to explain why a **Cost-Based Optimizer (CBO)** is necessary in **ClickHouse**. Here's a breakdown of the examples presented in the post:

---

### **Example 1: Query with Inner Join**

The first example involves an **Inner Join** query on two tables, `t1` and `t2`:

```sql
SELECT a, b, c 
FROM t1 
INNER JOIN t2 ON t1.id = t2.id 
WHERE t1.d = 'xx';
```

#### **Scenario Description**:
- **`t1`** has 1 billion rows, and **`t2`** has 100 rows.
- Initially, the execution plan for the query results in an **output of 10 billion rows** after the inner join, which is computationally expensive and inefficient.

#### **Optimizations**:

1. **Rule-Based Equivalent Transformations**:
   - The **Filter operation** (`t1.d = 'xx'`) can be **pushed down** below the Inner Join. This reduces the number of rows processed by the join from 1 billion to 2 rows from `t1`, making the join more efficient.
   
   **Result**: The join now processes only 2 rows from `t1` and 100 rows from `t2`, instead of 1 billion + 100 rows.

2. **Choosing the Appropriate Join Algorithm**:
   - The **Inner Join** is the most performance-intensive operation in this query. Instead of using a default join strategy, selecting a more appropriate algorithm like **Hash Join** significantly reduces the computation cost.

3. **Data Distribution Properties**:
   - In distributed databases, the data distribution between nodes plays a crucial role. The example compares two distribution methods:
     - **Shuffle Distribution**: Transmitting 1 billion rows across the network.
     - **Broadcast Distribution**: Transmitting 100 * 100 rows (i.e., broadcasting small tables to all nodes).
   - **Broadcast distribution** is optimal in this case because it minimizes the total data transmitted across nodes.

#### **Key Takeaway**:
- The choice of algorithm and data distribution strategy greatly impacts the query's performance, and a **CBO** can make more informed decisions based on the size of the data and distribution characteristics.

---

### **Example 2: Aggregation Query**

The second example is a **group by aggregation** query:

```sql
SELECT a, SUM(b) 
FROM t1 
GROUP BY a;
```

#### **Scenario Description**:
- The left side shows a **single-stage aggregation** plan, where the data is aggregated at a single node after being scanned across all nodes.
- The right side shows a **two-stage aggregation** plan, where the aggregation is first performed **locally on each node**, and then the partially aggregated results are sent to a single node for final aggregation.

#### **Optimizations**:

1. **Single-Stage vs. Two-Stage Aggregation**:
   - **Single-Stage Aggregation**: All data is scanned and sent to a single node for aggregation. If there are **1 billion rows**, all 1 billion rows are transmitted over the network to the single node, creating a network bottleneck.
   - **Two-Stage Aggregation**: Each node performs **partial aggregation** first (e.g., summing values locally), and only the **aggregated results** are sent to the final node. This reduces network transmission costs from 1 billion rows to **1,000 rows**.

#### **Key Takeaway**:
- The **two-stage aggregation** approach is significantly more efficient, reducing the network cost from 1 billion rows to 1,000 rows. A CBO would be able to choose the most optimal strategy depending on the data size and characteristics.

---

### **Why We Need a CBO**

- **Omniscient Perspective**: In the above examples, the optimizations were done manually based on an omniscient understanding of the data characteristics (size, cardinality, etc.). In reality, without detailed data statistics, it's challenging to know the best execution plan.
- **Adaptability**: When the data characteristics differ (e.g., different cardinalities, sorted data, etc.), different execution plans may be more suitable. A CBO can analyze these characteristics and dynamically adjust the execution plan to achieve optimal performance.
- **Examples of CBO Decisions**:
   1. For ordered input data, a **Sort-Merge Join** might be better than a **Hash Join**.
   2. When both join tables are large, **shuffle distribution** might be better than **broadcast distribution**.

---

### **Conclusion**:

The post emphasizes that SQL defines **what** to do (e.g., join, group by) but not **how** to do it. The **execution plan** significantly impacts performance, and a **Cost-Based Optimizer (CBO)** is necessary to intelligently choose the best execution strategies based on data statistics, reducing computational costs, network I/O, and query time.

The examples illustrate how **pushing down filters**, choosing the **right join algorithm**, and selecting the **optimal aggregation strategy** can make queries more efficient. Without a CBO, these optimizations would either not occur or be difficult to apply manually.

