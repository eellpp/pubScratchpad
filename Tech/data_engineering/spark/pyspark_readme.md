
### Spark - Brief Introduction
Spark is an in-memory data processing engine for big datasets. On hadoop clusters it runs through Apache YARN. It is used for processing big data worlkloads like SQL queries, machine learning  and data streaming jobs.

Its popularity comes from these facts
- it is open source
- it provides developer friendly API's that abstracts out the complexities of distributed data processing
- it is very fast as compared to native hadoop map reduce


The components of spark application are 
- Driver
- the cluster manager
- the master (inside cluster manager)
- executors 

**Spark from Hardware perspective:**
1. There's a cluster. There is a driver. Cluster has executors and each executor has cores in it. Cores within a executor can be considered as slot. Tasks can be inserted in a slot. 
2. Memory: Cluster has Working memory and storage memory for persistence. 50% of memory is utilized as storage memory
3. Executor has disk storage. It provides space for shuffle partitions during shuffle stages and also provides persistence to the disk.  Also storage for spills from executor while executing the workloads
 

**Spark from Software Perspective**
1. Spark has transformations and actions
2. Transformations are lazy and dont do anything unless we call an action
3. Transformation can be narrow and wide
	1. narrow are ones for which all data is available in each executor and no shuffling is required
	2. wide ones are one for which shuffling is required to move data around
4. Actions perform one of many transformations at a time which spawn off jobs. Jobs contains one of more stages. Stages contain task. Task is the part which interacts with the hardware. All others are doing orchestrations and co-ordinations.
5. Every task in a stage is doing the same thing. If a task in stage is required to do something different, then it is put into another stage

1Task  === 1core === 1 partition = 1 slot

JOB --> Stages --> Tasks

How many cores you have ? 
How much memory you have per core ?

What to see in spark UI
- Any stages the hangs ?
- Any tasks that are taking long time ?
- Stages that longest ?
- How much of the cluster utilization. Ideally 70% is good range

Partition
Hive partition is not same as Spark partition. 
- hive partition is in disk as storage in persistence
- spark partition is amount dividing the data so that it can operated in parrallel from memory


**Basic spark partitions (while reading, processing and writing out)**
- Input
	- In general spark does this well and may not require optimizations
- **Shuffle**
	- default partition size is 200 (good for 20 to 30 GB data)
	- partition count calculation =  Stage Input Data /Target Size 
	- Target size is <= 200 MB/partition
		- eg: Shuffle stage input = 210 GB then partition_count is 210000/200 = 1050 
		- spark.conf.set("spark.sql.shuffle.partitions",1050)
		- if cluster has 2000 cores, then you can instead set it to 2000
- Output
	- coalesce(n), 
	- repartition(n) to balance the shuffle
	- If max write stage parallilism is 10, ( to created 10 files), then in a 100 core cluster, 90 of them are sitting idle


Shuffle is the most data intensive part and requires most effort in optimizing

**Optimizing shuffle partitions**
- check the spillage. To reduce the spillage adjust the shuffle partition such that each task has 100 to 200 MB of data. This should increase the speed of job

---

#### Driver

Driver is the process that clients use to submit applications to spark . Driver can be client or on a node on cluster 

Drivers creates a spark session object. Driver plans the execution of the program by creating a DAG of node. Each node is either a transformational or computation step

DAG
- dag consists of tasks and stages. 
- A task is a smallest unit of work in spark. A stage is a set of tasks that can run together. 
- Stages can have dependencies on other stages. 

The drivers also serves the application UI on port 4040.

#### Executor
Executors are processes that run the spark tasks
A worker node hosts a group of executors. Each executors is allocated memory and resources


#### The master and cluster manager
The master and cluster manager , monitor, reserve and allocate resources on the cluster.
Yarn is the cluster manager. Mesos is another one   




### programming Languages does spark support
Sparks core API is written in Scala. But it has interfaces written in Java, Scala, Python and R. Python is used merely as frontend or a thin wrapper around native scala classes. 


### Spark Ecosystem and outline of its major components
Spark consists of Spark Core API's and other decoupled components. 

Spark Core API provides the generalized execution engine and all the other functionalities are build on top of it. 

### RDD
RDD is one of the spark data structures. It is schemaless and immutable JVM objects


## Spark RDD vs Dataset/Dataframe
- `RDD` : RDD stands for Resilient Distributed Datasets
	- Read only
	- The inmemory distributed dataset that spark creates for faster computation and reduce the I/O. 
	- Choose this format if the data is structured or unstructured.
	- RDD are immutable
	- RDDs are also fault-tolerant which means that whenever failure happens, they can be recovered automatically.RDD Provides Fault Tolerance Through Lineage Graph. A Lineage Graph keeps A Track of Transformations to be executed after an action has been called.  RDD Lineage Graph helps Recomputed any missing or damaged RDD because of node failures.
	- RDDs are a set of Java or **[Scala](https://data-flair.training/blogs/why-you-should-learn-scala-introductory-tutorial/)** objects representing data.
	- We can move from RDD to DataFrame (If RDD is in tabular format)
	- Run time of RDD's are much slower than the dataset/dataframe counterparts. This is because spark leverages on the structured view of data to do optimizations while performing operations on data. (RDD can be 3/4x slower)
- `Dataframe` : Like RDD but for data having tabular structure. Dataframe's are untyped and does not provide compile time type checks. This is structured or semi structured data
	- Spark does optimization on the sql on dataframes
	- dataframe API's provide a more granular level operations than the SQL API
	- SQL provides a structured view of the data while limiting the operations over it. This limited set of operations allows optimizations to be built into it. 
- `DataSet` : Introduced in spark2 . Like Dataframe but with compile time type safety. 
	- Another benefit of this new Dataset API is the reduction in memory usage. Since Spark understands the structure of data in Datasets, it can create a more optimal layout in memory when caching Datasets.


### Spark Env
Holds all the runtime environment objects for a running Spark instance (either master or worker), including the serializer, RpcEnv, block manager, map output tracker, etc. 

SparkEnv supports two serializers, one named serializer which is used for serialization of your data, checkpointing, messaging between workers, etc and is available under spark.serializer configuration flag. The other is called closureSerializer under spark.closure.serializer which is used to check that your object is in fact serializable and is configurable for Spark <= 1.6.2 (but nothing other than JavaSerializer actually works) and hardcoded from 2.0.0 and above to JavaSerializer.

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


### How to use caching in spark
You can create a RDD or create a temporary view and an cache it. RDD is cache is row based and less optimal than column based in-memory tabular format.
1. RDD
``` bash
myrdd.cache
```
Note that rdd.cache is a lazy operation

2. dataframe

### Why Do You Need To Cache or Persist RDDs?
By default, each transformed RDD may be recomputed each time you run an action on it. However, you may also persist an RDD in memory using the persist (or cache) method, in which case Spark will keep the elements around on the cluster for much faster access the next time you query it. There is also support for persisting RDDs on disk, or replicated across multiple nodes.

A couple of use cases for caching or persisting RDDs are the use of iterative algorithms and fast interactive RDD use.

### Can you use RDD and Dataframe across sparkSessions
RDDs and Datasets cannot be shared between application (at least, there is no official API to share memory)

However, you may be interested in Data Grid. Look at Apache Ignite. You can i.e. load data to Spark, preprocess it and save to grid. Then, in other applications you could just read data from Ignite cache.

There is a special type of RDD, named IgniteRDD, which allows you to use Ignite cache just like other data sources. Of course, like any other RDD, it can be converted to Dataset


1. What is partitioning
2. How use partitioning to speed up dataframe operations
3. Using Partitioning at various level : HDFS, File format like parquet, spark dataframe  

- what is shuffling
- how to reduce shuffling is spark
- best practices to reduce shuffling in sql spark operations
- 

### Introduction to shuffling

The shuffle is Spark’s mechanism for re-distributing data so that it’s grouped differently across partitions. This typically involves copying data across executors and machines, making the shuffle a complex and costly operation.

Spark knows to avoid a shuffle when a previous transformation has already partitioned the data according to the same partitioner.

In general, avoiding shuffle will make your program run faster. All shuffle data must be written to disk and then transferred over the network.

-  groupByKey shuffles all the data, which is slow.
-  reduceByKey shuffles only the results of sub-aggregations in each partition of the data.

**when shuffling is triggered on Spark?** 
Any join, cogroup, or ByKey operation involves holding objects in hashmaps or in-memory buffers to group or sort. join, cogroup, and groupByKey use these data structures in the tasks for the stages that are on the fetching side of the shuffles they trigger.

distinct creates a shuffle

**operations that cause shuffling**
cogroup, groupWith, join: hash partition, leftOuterJoin: hash partition,rightOuterJoin: hash partition ,groupByKey: hash partition,reduceByKey: hash partition, combineByKey: hash partition, sortByKey: range partition,intersection: hash partition, repartition, coalesce,distinct

#### Optimizing performance
- use parquet format files for faster read operations 
- not to many small files
- too few partitions can have some executors being idle. Too many partitions will have execessive overhead in managing small tasks (eg 1000 + partitions where each partitions is small data) Eg:  2 million large json objects split across 25K partitions will run v slowly or out of memory vs the same coalesce to 320 wil run very fast. 

recommendation is  to have your number of partitions set to 3 or 4 times the number of CPU cores in your cluster


https://stackoverflow.com/questions/43831387/how-to-avoid-shuffles-while-joining-dataframes-on-unique-keys

https://deepsense.ai/optimize-spark-with-distribute-by-and-cluster-by/


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