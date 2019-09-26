

### Getting Column statistics
ColumnStat holds the statistics of a table column. 

ColumnStat is computed using ANALYZE TABLE COMPUTE STATISTICS FOR COLUMNS SQL command. We can then inspect the column stat with DESCRIBE EXTENDED command.

```java
val cols = "id, p1, p2"
val analyzeTableSQL = s"ANALYZE TABLE t1 COMPUTE STATISTICS FOR COLUMNS $cols"
scala> sql("DESC EXTENDED t1 id").show
+--------------+----------+
|info_name     |info_value|
+--------------+----------+
|col_name      |id        |
|data_type     |int       |
|comment       |NULL      |
|min           |0         |
|max           |1         |
|num_nulls     |0         |
|distinct_count|2         |
|avg_col_len   |4         |
|max_col_len   |4         |
|histogram     |NULL      | <-- no histogram (spark.sql.statistics.histogram.enabled off)
+--------------+----------+
```
Reference:
https://jaceklaskowski.gitbooks.io/mastering-spark-sql/spark-sql-ColumnStat.html

### Show Frequent values in col
finds the frequent items that show up 40% of the time for each column a,b,c:
```java
>> freq = df.stat.freqItems(["a", "b", "c"], 0.4)
>> freq.collect()[0]
>> Out[4]: Row(a_freqItems=[11, 1], b_freqItems=[2, 22], c_freqItems=[1, 3])
```
### Using pandas describe command on dataframe
https://pandas.pydata.org/pandas-docs/version/0.21/generated/pandas.DataFrame.describe.html
```java
df.describe(include='all')
```
#### Count the number of non-NA values
```java
df['preTestScore'].count()

> https://chrisalbon.com/python/data_wrangling/pandas_dataframe_descriptive_stats/
```
### using Struct


