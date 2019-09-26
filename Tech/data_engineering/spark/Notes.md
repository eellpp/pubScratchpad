
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
- `RDD` : The inmemory distributed dataset that spark creates for faster computation and reduce the I/O. Choose this format if the data is unstructured.
- `Dataframe` : Like RDD but for data having tabular structure. Similar to dataframe's in R, but with distributed computation and optimizations built in. Dataframe's are untyped and does not provide compile time type checks. 
DataFrame is simply a type alias of Dataset[Row]
- `DataSet` : Introduced in spark2 . Like Dataframe but with compile time type safety. 

DataSet was introduced in spark2.

Run time of RDD's are much slower than the dataset/dataframe counterparts. This is because spark leverages on the structured view of data to do optimizations while performing operations on data. (RDD can be 3/4x slower)
Another benefit of this new Dataset API is the reduction in memory usage. Since Spark understands the structure of data in Datasets, it can create a more optimal layout in memory when caching Datasets.
DataFrame is an alias to Dataset[Row]. As we mentioned before, Datasets are optimized for typed engineering tasks, for which you want types checking and object-oriented programming interface, while DataFrames are faster for interactive analytics and close to SQL style.

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


### DataSet Creation

The Dataset API has the concept of `encoders` which translate between JVM representations (objects) and Spark’s internal binary format. Spark has built-in encoders that are very advanced in that they generate byte code to interact with off-heap data and provide on-demand access to individual attributes without having to de-serialize an entire object.

Let’s say we have a case class
```java
case class FeedbackRow(manager_name: String, response_time: Double, satisfaction_level: Double)
You can create Dataset:
```
By implicit conversion
```java
// create Dataset via implicit conversions
val ds: Dataset[FeedbackRow] = dataFrame.as[FeedbackRow]
val theSameDS = spark.read.parquet("example.parquet").as[FeedbackRow]
```

By hand
```java
// create Dataset by hand
val ds1: Dataset[FeedbackRow] = dataFrame.map {
  row => FeedbackRow(row.getAs[String](0), row.getAs[Double](4), row.getAs[Double](5))
}
```
From collection
```java
import spark.implicits._

case class Person(name: String, age: Long)

val data = Seq(Person("Bob", 21), Person("Mandy", 22), Person("Julia", 19))
val ds = spark.createDataset(data)
```
From RDD
```java
val rdd = sc.textFile("data.txt")
val ds = spark.createDataset(rdd)
```

## Dataframe vs SQL API
dataframe API's provide a more granular level operations than the SQL API
```bash
## dataframe
data.groupBy('dept').avg('age')
## sql
select dept,avg(age) from data group by dept
```
RDD API's provide even more lower level operations.
SQL provides a structured view of the data while limiting the operations over it. This limited set of operations allows optimizations to be built into it. 

When you write a SQL API query the result is returned as dataframe

### encoders and Serialization

https://jaceklaskowski.gitbooks.io/mastering-apache-spark/spark-sql-Encoder.html

Encoder is the fundamental concept in the serialization and deserialization (SerDe) framework in Spark SQL 2.0. Spark SQL uses the SerDe framework for IO to make it efficient time- and space-wise.
Encoders are integral part of any Dataset[T] with a Encoder[T] that is used to serialize and deserialize the records of this dataset. Encoder[T] that handles serialization and deserialization of T to the internal representation.

Encoders know the schema of the records. This is how they offer significantly faster serialization and deserialization (comparing to the default Java or Kryo serializers).

Encoders map columns (of your dataset) to fields (of your JVM object) by name. It is by Encoders that you can bridge JVM objects to data sources (CSV, JDBC, Parquet, Avro, JSON, Cassandra, Elasticsearch, memsql) and vice versa.

### Why serialization
If you follow the map transformation with any action / transformation that requires shuffle (e.g. groupByKey), or that requires sending the data back to the driver (like collect) - then the data must be serialized (how else would it be shared across separate Java processes?).

Now, since there's very little you can do without shuffles or collecting the data - most likely, you don't really have a choice, your data must be serializable.

Spark default serialization is Java serializer. Java’s serialization framework is notoriously inefficient, consuming too much CPU, RAM and size to be a suitable large scale serialization format.
- Every task run from Driver to Worker gets serialized : Closure serialization
- Every result from every task gets serialized at some point : Result serialization
 And what’s implied is that during all closure serializations all the values used inside will get serialized as well.This is also one of the main reasons to use Broadcast variables when closures might get serialized with big values.

kryo is fast and efficient . How to change the default to kryo serializer
```java
val conf = new SparkConf()
      .set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
```
 
#### Common encoders
encoders for common Scala types and their product types are already available in implicits object.
```bash
val spark = SparkSession.builder.getOrCreate()
import spark.implicits._
```
#### Custom encoders
Import org.apache.spark.sql package to have access to the Encoders factory object.
```bash
import org.apache.spark.sql.Encoders

scala> Encoders.STRING
res2: org.apache.spark.sql.Encoder[String] = class[value[0]: string]

case class Person(id: Int, name: String, speaksPolish: Boolean)

scala> Encoders.kryo[Person]
res3: org.apache.spark.sql.Encoder[Person] = class[value[0]: binary]

scala> Encoders.javaSerialization[Person]
res5: org.apache.spark.sql.Encoder[Person] = class[value[0]: binary]
```

### Spark Env
Holds all the runtime environment objects for a running Spark instance (either master or worker), including the serializer, RpcEnv, block manager, map output tracker, etc. 

SparkEnv supports two serializers, one named serializer which is used for serialization of your data, checkpointing, messaging between workers, etc and is available under spark.serializer configuration flag. The other is called closureSerializer under spark.closure.serializer which is used to check that your object is in fact serializable and is configurable for Spark <= 1.6.2 (but nothing other than JavaSerializer actually works) and hardcoded from 2.0.0 and above to JavaSerializer.


### Modern Spark DataFrame and Dataset (Intermediate Tutorial) 
https://www.youtube.com/watch?v=_1byVWTEK1s&feature=youtu.be

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
