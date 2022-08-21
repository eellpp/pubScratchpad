**Hive Difference between external table and Internal table (managed table) ?**
- dropping managed table will delete metadata and data
- dropping external table will delete only metadata 

**Where is hive data stored ?**
In hdfs. Generally at location /user/hive/warehouse

**Why hive is not suited for OLTP ?**
Hive is usable for batch processing jobs (not OLTP) as latencies are high. Latencies are high because hive is running map reduce queries over hadoop cluster which has high latencies. 
RDBMS generally are on a single machine and heavily optimized for relational data queries.
Hive is used for complex queries over large datasets which cannot be held in single machine

**Why is partitioning used in Hive?**
Paritioning of data is done for efficient querying of data. 
Partitioning of data helps by parallelizing the operations for faster queries.

**What is hive metastore**
Hive metastore has information about table name,columns and partitions etc

**What are dataformats supported by hive ?**
Various dataformats supported by hive are csv (Text file), ORC , Parquet and RCFile 


**Dynamic partition vs static partition**
- in static partition, paritions are manually created in hdfs and data is inserted into parition based on "load data inpath <> into table tablename partition(partition='2020-09-09') "
- in dynamic partition (enable the hive dynamic partition)
	- data is inserted by insert overwrite table tablename partition(column_name) select * from tablename


**What is the difference between external table and managed table?**
Here is the key difference between an external table and managed table:
-   In case of managed table, If one drops a managed table, the metadata information along with the table data is deleted from the Hive warehouse directory. 
-   On the contrary, in case of an external table, Hive just deletes the metadata information regarding the table and leaves the table data present in HDFS untouched.
OpenCSV serde can be used for hive to read and parse the csv data properly


**Is it possible to change the default location of a managed table?**
Yes, it is possible to change the default location of a managed table. It can be achieved by using the clause – add LOCATION ‘<hdfs_path>’.

**Why is sort by faster than order by clause ?**
The reason `order by` is slower is that in order to impose total order of all results, there has to be one reducer to sort the final output. If the number of rows in the output is too large, the single reducer could take a very long time to finish.

**What is difference between `order by` and `sort by` ?**
`SORT BY` sorts the data per reducer. The difference between "order by" and "sort by" is that the former guarantees total order in the output while the latter only guarantees ordering of the rows within a reducer. If there are more than one reducer, "sort by" may give partially ordered final results.
Basically,for sort by,  the data in each reducer will be sorted according to the order that the user specified.


**Why `sort by` can give bad results in query and how to improve on it ?**
When doing sort by, the sorting is guranteed per reducer. However the same key can distributed across multiple reducers. Hence the results will get messed up. 
Combining `distribute by` and `sort by` makes the result somewhat better. 
Distribute by will ensure that all the rows with same key goes to same reducer. So at least sorting within the reducer is fine. 

> SELECT col1, col2 FROM t1 DISTRIBUTE BY col1 SORT BY col1 ASC, col2 DESC


**How do you add a new partition to a dynamically partitioned table?**
Alter table ... add partition(name='')


**What are different kind of joins and how they are performed ?**
[Hive Joins](Hive%20Joins.md)

**How to consume a csv file at a certain location with hive ?**
create external table .... stored as textfile location '<>'

**If the hive table is not partitioned and every day data is written to a new path everyday, what would you do to have the hive table read data from recently ingested path?**
alter table .... set location <>


**Does hive support schema on read or write ? Explain**
In traditional databases, the table’s schema is imposed during the data load time, if the data being loaded does not conform to the schema then the data load is rejected, this process is know as Schema-on-Write. Here the data is being checked against the schema when written into the database(during data load).
In HIVE, the data schema is not verified during the load time, rather it is verified while processing the query. Hence this process in HIVE called Schema-on-Read.

**Why does hive not follow schema on write ?**
Schema-on-Write helps in faster performance of the query, as the data is already loaded in a particular format and it is easy to locate the column index or compress the data. However, it takes longer time to load data into the database.

Schema-on-Read helps in very fast initial data load, since the data does not have to follow any internal schema(internal database format) to read or parse or serialize, as it is just a copy/move of a file

For big datasets, schema on read is favourable to make data ingestion faster. 

Hive cannot do indexing of columns like RDBMS

**Changing column name:** 
- alter table <tablename> change oldname newname type
This will not work for data is stored in parquet format as parquet format contains the column name and data is immutable. The column name though will be changed in hive metasotre

**Can you delete column in hive ?**

There is no delete column in hive. 
You can only do replace columns
> ALTER TABLE TEST REPLACE COLUMNS( name string, case string);
REPLACE COLUMNS removes all existing columns and adds the new set of columns. This can be done only for tables with a native SerDe (DynamicSerDe, MetadataTypedColumnsetSerDe, LazySimpleSerDe and ColumnarSerDe).

### Limitations

No Row level inserts, updates and deletes   
No designed for OLTP since no real time access   



Steps in Hive Query Processing: 

1. Hive query compilation takes the query string and produces a QueryPlan. The QueryPlan contains both the list of cluster tasks required for the query, as well as the FetchTask used to fetch results. The cluster tasks are configured to output the final results to a designated temp directory. The FetchTask contains a FetchOperator which is configured to read from the designated temp directory, as well as the input format, column information, and other information.

2. During query execution (Driver.execute()), Hive will submit any cluster tasks (MR/Tez/Spark) required for the query.

3. When the cluster tasks are finished the queryPlan’s FetchTask is used to read the query results from the temp directory (Driver.getResults())

4. Cleanup of the query results is handled by the Driver’s Context object. Several directory paths are cleaned up in this step, including the query results directory and parent directories of the results directory.


Hive