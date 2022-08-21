**How to find distinct rows based on multiple columns in hive ?**
> distinct col1, col2, col3 etc

**When to use `Having` clause ?**
The **HAVING clause** is used with **GROUP BY** clause. Its purpose is to apply constraints on the group of data produced by GROUP BY clause.

> `SELECT col1 FROM t1 GROUP BY col1 HAVING SUM(col2) >` `10`

This could also be writtin in nested form as 
> `SELECT col1 FROM (SELECT col1, SUM(col2) AS col2sum FROM t1 GROUP BY col1) t2 WHERE t2.col2sum >` `10` 


**What is difference between `order by` and `sort by` ?**
[Questions](Questions.md)

**What is difference between group by and window function in SQL ?**
`GROUP BY` collapses the individual records into groups; after using GROUP BY, you cannot refer to any individual field because it is collapsed. If you want to create a report with an employee name, salary, and the top salary of the employee’s department, you can’t do it with `GROUP BY`. The individual records of each employee are collapsed by the `GROUP BY department`

`Group by` allow us to apply functions like `AVG`, `COUNT`, `MAX`, and `MIN` on a group of records while still leaving the individual records accessible. Since the individual records are not collapsed, we can create queries showing data from the individual record together with the result of the window function.

```bash
SELECT  employee_name,department,salary,max(salary) OVER(PARTITION BY department) as top_salary FROM employee
```

**What is performance of a groupby vs window function ?**
It depends on the data. More specifically here it depends on the cardinality of the  group by column. If the cardinality/uniqueness is small, the data will be small after the aggregation and the aggregated result can be broadcasted in the join. In that case, the join will be faster than the `window`.
On the other hand, if the cardinality is big and the data is large after the aggregation, so the join will be planed with `SortMergeJoin`, using `window` will be more efficient.


**What is difference between row number and rank in window query ?**

**ROW_NUMBER :** Returns a unique number for each row starting with 1. For rows that have duplicate values,numbers are arbitarily assigned.

**Rank :** Assigns a unique number for each row starting with 1,except for rows that have duplicate values,in which case the same ranking is assigned and a gap appears in the sequence for each duplicate ranking.

> ```sql
SELECT ID, Description, RANK()       OVER(PARTITION BY StyleID ORDER BY ID) as 'Rank'      FROM SubStyle
SELECT ID, Description, ROW_NUMBER() OVER(PARTITION BY StyleID ORDER BY ID) as 'RowNumber' FROM SubStyle
```

