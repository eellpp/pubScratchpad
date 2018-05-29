

### Getting Column statistics
ColumnStat holds the statistics of a table column. 

ColumnStat is computed using ANALYZE TABLE COMPUTE STATISTICS FOR COLUMNS SQL command. We can then inspect the column stat with DESCRIBE EXTENDED command.

```java
val cols = "id, p1, p2"
val analyzeTableSQL = s"ANALYZE TABLE t1 COMPUTE STATISTICS FOR COLUMNS $cols"
scala> sql("DESC EXTENDED t1 id").show
```
Reference:
https://jaceklaskowski.gitbooks.io/mastering-spark-sql/spark-sql-ColumnStat.html

