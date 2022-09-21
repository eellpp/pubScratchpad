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


**How to create a spark dataframe from csv file ?**
df = spark.read.csv("/path/to/file.csv")

**How would you run SQL on a spark dataframe ?**
create a temporary table on DataFrame by using `createOrReplaceTempView()
> df.createOrReplaceTempView("STUDENTS") 
> df_new = spark.sql("SELECT * from STUDENTS")


**What is broadcast join?**
Broadcast join happens when a larger dataframe is joined with a smaller dataframe. To avoid shuffling the smaller dataframe is braodcasted to all nodes. This the network io is minimal   


**How to create dataframe with complex datatype columns ?**
We have to provide a schema 
We have to import StructType,StructField,StringType etc  classes modules from pyspark.sql module

**How to get unique records in a dataframe ?**
`distinct()` takes no arguments at all, while `dropDuplicates()` can be given a subset of columns to consider when dropping duplicated records.


**How to convert Spark Dataframe to pandas ?**
df.toPandas()

