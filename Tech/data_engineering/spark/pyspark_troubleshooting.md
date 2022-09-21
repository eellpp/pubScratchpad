
### How to see the logical and physical plan for a query comparison ?
spark.sql("select distinct(login) from users").explain(True).  
spark.sql("select count(login) from users group by login").explain(True).   
This will help compare the queries that are generated for both 

### Example of OOM issue while using row_number
https://towardsdatascience.com/adding-sequential-ids-to-a-spark-dataframe-fa0df5566ff6

```bash
spark.sql(‘select row_number() over (order by “monotonically_increasing_id”) as row_num, * from df_final’)
```
In order to use row_number(), we need to move our data into one partition. The Window in both cases (sortable and not sortable data) consists basically of all the rows we currently have so that the row_number() function can go over them and increment the row number. This can cause performance and memory issues — we can easily go OOM, depending on how much data and how much memory we have.


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


