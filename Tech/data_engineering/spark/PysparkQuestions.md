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

**What are pyspark dataframes ?**
PySpark DataFrame is a distributed collection of well-organized data that is equivalent to tables of the relational databases and are placed into named columns. PySpark DataFrame has better optimisation when compared to R or python. These can be created from different sources like Hive Tables, Structured Data Files, existing RDDs, external databases etc

**What are the types of PySpark’s shared variables?**
`Broadcast variables`: These are also known as read-only shared variables and  are cached and are made available on all the cluster nodes so that the tasks can make use of them.

> broadcastVar = sc.broadcast([10, 11, 22, 31])

`Accumulator variables`: 
- These variables are updatable shared variables.
- are used for performing counter or sum operations

**What is PySpark UDF?**
UDF stands for User Defined Functions. In PySpark, UDF can be created by creating a python function and wrapping it with PySpark SQL’s udf() method and using it on the DataFrame or SQL. These are generally created when we do not have the functionalities supported in PySpark’s library and we have to use our own logic on the data. UDFs can be reused on any number of SQL expressions or DataFrames.

**What is pyspark architecture ?**
It has a master slave architecture pattern
- master node is the driver
- slave nodes are workers
- cluster manager allocates resources and orchestrates the workers
- Workers have executors. Each executor is assigned tasks. Task is the unit of execution in spark

**What is DAGScheduler in spark?** 
DAG stands for Direct Acyclic Graph. DAGScheduler does scheduling of tasks. It creates a logical execution plan (series of transformations) and then a physical execution plan into stages and tasks. 


**What happens during the logical plan stage of DagScheduler?**
- SQL analysis to check sql is correct
- Tables and columns etc is correct
- If all ok, then this resolved logical plan is sent to Catalyst optimizer to generate a optimized logical plan of series of transformation required.  Eg: Apply a filter clause before doing any join operations


**What happens during a physical plan stage of DAG Scheduler ?**
Let’s say, we are performing a join query between two tables. In that join operation, we may have a fat table and a thin table with a different number of partitions scattered in different nodes across the cluster (same rack or different rack). Spark decides which partitions should be joined first (basically it decides the order of joining the partitions), the type of join, etc for better optimization. 

Physical Plan is specific to Spark operation and for this, it will do a check-up of multiple physical plans and decide the best optimal physical plan. And finally, the Best Physical Plan runs in our cluster.

### How to see the logical and physical plan for a query comparison ?
spark.sql("select distinct(login) from users").explain(True).  
spark.sql("select count(login) from users group by login").explain(True).   
This will help compare the queries that are generated for both 

**How to create a spark dataframe from csv file ?**
df = spark.read.csv("/path/to/file.csv")

**How would you run SQL on a spark dataframe ?**
create a temporary table on DataFrame by using `createOrReplaceTempView()
> df.createOrReplaceTempView("STUDENTS") 
> df_new = spark.sql("SELECT * from STUDENTS")


**What is broadcast join?**
Broadcast join happens when a larger dataframe is joined with a smaller dataframe. To avoid shuffling the smaller dataframe is braodcasted to all nodes. This the network io is minimal   

### What are the different joins in spark  
broadcast hash join.  
shuffle hash join.  
shuffle sort-merge join  
cartesian join.  

A hash join is based on creating hash table based on join key of smaller table and looping the larger table to match the join key values  

broadcast hash join has the entire smaller dataset sent over to all nodes. 

Shuffle hash join involves moving the data with the same hash key to same node. Data is shuffles around.

sort join involves first sorting each of the table and then doing the join. Shuffle sort-merge join involves moving the data with the same hash key to same node, then sorting each of dataset and then doing the join in the node. 

### Why is distict slower than groupby when operating on lots of columns?
Distinct creates more shuffles. Spark has while optimization replaces distinct by ReplaceDistinctWithAggregate optimization rule
Groupby will involve creation of hash by group key and would be faster. 
However distinct will involve sorting and duplicate removal by columns.

### What is shuffling
The shuffle is Spark’s mechanism for re-distributing data so that it’s grouped differently across partitions. This typically involves copying data across executors and machines, making the shuffle a complex and costly operation.

Spark knows to avoid a shuffle when a previous transformation has already partitioned the data according to the same partitioner.

In general, avoiding shuffle will make your program run faster. All shuffle data must be written to disk and then transferred over the network.

-  groupByKey shuffles all the data, which is slow.
-  reduceByKey shuffles only the results of sub-aggregations in each partition of the data.

### Optimizing performance
- use parquet format files for faster read operations 
- not to many small files
- too few partitions can have some executors being idle. Too many partitions will have execessive overhead in managing small tasks (eg 1000 + partitions where each partitions is small data) Eg:  2 million large json objects split across 25K partitions will run v slowly or out of memory vs the same coalesce to 320 wil run very fast. 


**How to create dataframe with complex datatype columns ?**
We have to provide a schema 
We have to import StructType,StructField,StringType etc  classes modules from pyspark.sql module

**How to get unique records in a dataframe ?**
`distinct()` takes no arguments at all, while `dropDuplicates()` can be given a subset of columns to consider when dropping duplicated records.


**How to convert Spark Dataframe to pandas ?**
df.toPandas()

**How to handle rows with null value during explode**. 
Use explode_outer 
With explode, rows with null values are silently ignored.   


**What happens if two datasets with same columns, but different ordering are joined using UNION***. 
The union will give incorrect results. It will not give errors.  

**What is grouping sets((warehouse) , (product)) do?**.  
This is same as union of group by warehouse and group by product. 



