
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
