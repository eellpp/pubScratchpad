
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



### How to create a Dataframe

Visualize dataframe as a table with rows and columns. The easiest way to create it as a list of rows.

With list of Rows
```bash
>>> row1 = Row(id=1,cat=2,dog=0)
>>> row2 = Row(id=2,cat=0,dog=1)
>>> spark.createDataFrame([row1,row2])
DataFrame[cat: bigint, dog: bigint, id: bigint]
```


With columns and values
```bash
>>> from pyspark.sql import *
>>> columns = ['id','cat','dog']
>>> vals = [(1,2,0),(2,0,1)]
>>> spark.createDataFrame(vals,columns)
DataFrame[id: bigint, cat: bigint, dog: bigint]
```
