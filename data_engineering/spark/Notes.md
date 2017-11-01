
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


## Spark RDD vs Dataset/Dataframe
DataSet was introduced in spark2
- `RDD` : The inmemory distributed dataset that spark creates for faster computation and reduce the I/O. Choose this format if the data is unstructured.
- `Dataframe` : Like RDD but for data having tabular structure. Similar to dataframe's in R, but with distributed computation and optimizations built in. Dataframe's are untyped and does not provide compile time type checks. 
- `DataSet` : Introduced in spark2 . Like Dataframe but with compile time type safety. 
Run time of RDD's are much slower than the dataset/dataframe counterparts. This is because spark leverages on the structured view of data to do optimizations while performing operations on data. (RDD can be 3/4x slower)

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

### Catalyst : Spark SQL Optimizer

