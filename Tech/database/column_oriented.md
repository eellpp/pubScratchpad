

In a Column oriented or a columnar database data are stored on disk in a column wise manner.

In a real column-oriented DBMS, no extra data is stored with the values. Among other things, this means that constant-length values must be supported, to avoid storing their length “number” next to the values. For example, a billion UInt8-type values should consume around 1 GB uncompressed, or this strongly affects the CPU use. It is essential to store data compactly (without any “garbage”) even when uncompressed since the speed of decompression (CPU usage) depends mainly on the volume of uncompressed data.

Some column-oriented DBMSs do not use data compression. However, data compression does play a key role in achieving excellent performance.


e.g: Table Bonuses table

| ID |        Last  |  First |  Bonus|
|---|---|---|---|
 1      |Doe   |  John  |  8000 |
 2       |Smith |  Jane  |  4000 |
 3        |Beck |    Sam  |   1000 |

In a row-oriented database management system, the data would be stored like this: 1,Doe,John,8000;2,Smith,Jane,4000;3,Beck,Sam,1000;

In a column-oriented database management system, the data would be stored like this:
1,2,3;Doe,Smith,Beck;John,Jane,Sam;8000,4000,1000; 

Cassandra is basically a column-family store

Cassandra would store the above data as:

Bonuses: { row1: { "ID":1, "Last":"Doe", "First":"John", "Bonus":8000}, row2: { "ID":2, "Last":"Smith", "Jane":"John", "Bonus":4000} ... }

Vertica, VectorWise, MonetDB are some column oriented databases that I've heard of.

### Column Oriented Databases
https://en.wikipedia.org/wiki/List_of_column-oriented_DBMSes

ClickHouse  
DuckDB  
InfluxDB  

### Wide Column store
Wide-column stores such as Bigtable and Apache Cassandra are not column stores in the original sense of the term, since their two-level structures do not use a columnar data layout. In genuine column stores, a columnar data layout is adopted such that each column is stored separately on disk. Wide-column stores do often support the notion of column families that are stored separately. However, each such column family typically contains multiple columns that are used together, similar to traditional relational database tables. Within a given column family, all data is stored in a row-by-row fashion, such that the columns for a given row are stored together, rather than each column being stored separately. Wide-column stores that support column families are also known as column family databases.  
https://en.wikipedia.org/wiki/Wide-column_store  

Cassandra  
HBase  
Bigtable  


In practice, columnar databases are well-suited for OLAP-like workloads (e.g., data warehouses) which typically involve highly complex queries over all data (possibly petabytes).  
Row-oriented databases are well-suited for OLTP-like workloads which are more heavily loaded with interactive transactions. For example, retrieving all data from a single row is more efficient when that data is located in a single location (minimizing disk seeks), as in row-oriented architectures.  

