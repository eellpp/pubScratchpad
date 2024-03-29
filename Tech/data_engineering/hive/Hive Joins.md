The join operation is used to combine two or more database tables based on foreign keys.  

Just like SQL join, we can also perform join operations in MapReduce on different data sets.

Map Reduce Joins

1) Map side joins
2) Reduce side joins

A mapper’s job during Map Stage is to _“read”_ the data from join tables and to _“return”_ the **‘join key’** and **‘join value’** pair into an intermediate file. Further, in the shuffle stage, this intermediate file is then sorted and merged. The reducer’s job during reduce stage is to take this sorted result as input and complete the task of join.


### Map Side join 
 Map join is a type of join where a smaller table is loaded in memory and the join is done in the map phase of the MapReduce job. As no reducers are necessary, map joins are way faster than the regular joins.

Map side join is adequate only when one of the tables on which you perform map-side join operation is small enough to fit into the memory.  Hence it is not suitable to perform map-side join on the tables which are huge data in both of them.


The idea is that if one of the table is small, then the whole data in small table can be made available to each of the mappers in clusters where they can do the join. 

The smaller table is converted to hash table and made availble on each of mappers across nodes. 


-   `hive.auto.convert.join`: By default, this option is set to `true`. When it is enabled, during joins, when a table with a size less than 25 MB (hive.mapjoin.smalltable.filesize) is found, the joins are converted to map-based joins.
-   `hive.auto.convert.join.noconditionaltask`: When three or more tables are involved in the join condition. Using `hive.auto.convert.join`, Hive generates three or more map-side joins with an assumption that all tables are of smaller size.

Full outer joins are never converted to map-side joins


### Reduce side join
Like the join done in RDBMS to combine the contents of two tables based on a primary key, in a MapReduce job reduce side join combines the contents of two mapper outputs based on a common key.

Steps in reduce side join
1. Mapper reads the input data which are to be combined based on common column or join key.
2. The mapper processes the input and adds a tag to the input to distinguish the input belonging from different sources or data sets or databases.
3. The mapper outputs the intermediate key-value pair where the key is nothing but the join key.
4. After the sorting and shuffling phase, a key and the list of values is generated for the reducer.
5. Now, the reducer joins the values present in the list with the key to give the final aggregated output.

Since in stage five, each key has list of values, the number of reducer tasks that need to performed  is equal to unique count of join key


**What is Hash join in sql ?**

The Hash Join Algorithm consists of two steps. In the first step, it creates an in-memory hash table structure from the records of the relation with fewer elements. 
In the second step, the larger relation is iterated and the smaller table record is located using the previously build hash map:

The Hash Join algorithm may be used by relational database systems when joining relations, if one database relation is rather large and there is enough memory to hold the in-memory HashTable structure that’s needed to be built in the first step.

**What is sort merge join in sql ?**
In a SORT-MERGE join, Oracle sorts the first row source by its join columns, sorts the second row source by its join columns, and then merges the sorted row sources together. As matches are found, they are put into the result set.

**On what basis is hash join or sort merge join is selected ?**
-   **Merge join** is used when projections of the joined tables are sorted on the join columns. Merge joins are faster and uses less memory than hash joins. 
-   **Hash join** is used when projections of the joined tables are not already sorted on the join columns. In this case, the optimizer builds an in-memory hash table on the inner table's join column. The optimizer then scans the outer table for matches to the hash table, and joins data from the two tables accordingly. The cost of performing a hash join is low if the entire hash table can fit in memory. Cost rises significantly if the hash table must be written to disk.

The optimizer automatically chooses the most appropriate algorithm to execute a query, given the projections that are available.

