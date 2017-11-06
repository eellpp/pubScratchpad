
## Spark Session vs Spark Context

Spark Session was introduced in Spark 2.
With the instroduction of DataSet and Dataframe API’s it provides the entry point to build them.
```java
val sparkSession = SparkSession.builder.
      master("local")
      .appName("spark session example")
      .getOrCreate()
```
SparkSession is essentially combination of SQLContext, HiveContext and future StreamingContext. All the API’s available on those contexts are available on spark session also. Spark session internally has a spark context for actual computation.

Introduction to spark session
https://docs.databricks.com/spark/latest/gentle-introduction/sparksession.html


## Spark RDD vs Dataset/Dataframe
DataSet was introduced in spark2
- `RDD` : The inmemory distributed dataset that spark creates for faster computation and reduce the I/O. Choose this format if the data is unstructured.
- `Dataframe` : Like RDD but for data having tabular structure. Similar to dataframe's in R, but with distributed computation and optimizations built in. Dataframe's are untyped and does not provide compile time type checks. 
DataFrame is simply a type alias of Dataset[Row]
- `DataSet` : Introduced in spark2 . Like Dataframe but with compile time type safety. 
Run time of RDD's are much slower than the dataset/dataframe counterparts. This is because spark leverages on the structured view of data to do optimizations while performing operations on data. (RDD can be 3/4x slower)
Another benefit of this new Dataset API is the reduction in memory usage. Since Spark understands the structure of data in Datasets, it can create a more optimal layout in memory when caching Datasets.

RDD Example
```java
val lines = sc.textFile("/wikipedia")
val words = lines
  .flatMap(_.split(" "))
  .filter(_ != "")
val counts = words
    .groupBy(_.toLowerCase)
    .map(w => (w._1, w._2.size))
```
Dataset Example
```java
val lines = sqlContext.read.text("/wikipedia").as[String]
val words = lines
  .flatMap(_.split(" "))
  .filter(_ != "")
 val counts = words
    .groupBy(_.toLowerCase)
    .count()
```
(Dataframe/Datasets example)https://docs.databricks.com/spark/latest/dataframes-datasets/index.html
Data Frame cheat sheet https://github.com/hhbyyh/DataFrameCheatSheet


## Dataframe vs SQL
dataframe API's provide a more granular level operations than the SQL API
```bash
## dataframe
data.groupBy('dept').avg('age')
## sql
select dept,avg(age) from data group by dept
```
RDD API's provide even more lower level operations.
SQL provides a structured view of the data while limiting the operations over it. This limited set of operations allows optimizations to be built into it. 

### Best practices
https://www.gitbook.com/book/umbertogriffo/apache-spark-best-practices-and-tuning

### Spark DO and Don't
http://www.puroguramingu.com/2016/02/26/spark-dos-donts.html

## spark partitioning
https://www.dezyre.com/article/how-data-partitioning-in-spark-helps-achieve-more-parallelism/297
you can always increase the number of partitions with rdd.coalesce(numParts, true)

### Catalyst : Spark SQL Optimizer
https://www.slideshare.net/databricks/a-deep-dive-into-spark-sqls-catalyst-optimizer-with-yin-huai


### Function references
http://www.openkb.info/2015/01/scala-on-spark-cheatsheet.html
