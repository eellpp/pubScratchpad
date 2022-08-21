HBase (a NoSQL variant) is designed to be an OLTP engine, 

### Is hbase column oriented
http://www.thecloudavenue.com/2012/01/is-hbase-really-column-oriented.html  

Although HBase is known to be a column oriented database (where the column data stay together), the data in HBase for a particular row stay together and the column data is spread and not together.

Let's go into the details. In HBase, the cell data in a table is stored as a key/value pair in the HFile and the HFile is stored in HDFS. More details about the data model are present in the Google BigTable paper. Also, Lars (author of HBase - The Definitive Guide) does a very good job of explaining the storage layout.

Below is one of the key/value pair stored in the HFile which represents a cell in a table.

K: row-550/colfam1:50/1309812287166/Put/vlen=3 V: 501  

where  
 
`row key` is `row-550`  
`column family` is `colfam1`  
`column family identifier (aka column)` is `50`  
`time stamp` is `1309812287166`   
`value` stored is `501`.  

The dump of a HFile (which stores a lot of key/value pairs) looks like below in the same order  

K: row-550/colfam1:50/1309812287166/Put/vlen=2 V: 50  
K: row-550/colfam1:51/1309813948222/Put/vlen=2 V: 51  
K: row-551/colfam1:30/1309812287200/Put/vlen=2 V: 51  
K: row-552/colfam1:31/1309813948256/Put/vlen=2 V: 52  
K: row-552/colfam1:49/1309813948280/Put/vlen=2 V: 52  
K: row-552/colfam1:51/1309813948290/Put/vlen=2 V: 52  

As seen above, the data for a particular row stay together (for ex., all the rows starting with K: row-550/) and the column data is spread and not together (for ex., consider K: row-550/colfam1:51 and K: row-552/colfam1:51 which are in bold above for column name 51). Since the columns are spread the compression algorithms cannot take advantage of the similarities between data of a particular column.  

To conclude, although HBase is called column oriented data base, the data of a particular row stick together.  

---

Yes, HBase is column oriented in the sense that when a table has multiple column families, those families are stored separately. When each column family has at most one column, it gets column oriented. When you have hundreds of different columns in one column family it is getting back to row oriented almost.

HBase isn't really a columnar database; that is a misnomer. HBase stores data in rows based on the primary key of each record. The reason why it is called "column-oriented" is that it is HBase columns are structured in column families, to be contrasted with a traditional databases. HBase tries to store records together internally in the same HFile (where HBase data is stored in Hadoop), which is why it is called "column-oriented"  

--- 

https://www.oreilly.com/library/view/hbase-the-definitive/9781449314682/ch01.html   
Note, though, that HBase is not a column-oriented database in the typical RDBMS sense, but utilizes an on-disk column storage format. This is also where the majority of similarities end, because although HBase stores data on disk in a column-oriented format, it is distinctly different from traditional columnar databases: whereas columnar databases excel at providing real-time analytical access to data, HBase excels at providing key-based access to a specific cell of data, or a sequential range of cells.

---  

This article describes our experience and research on how the execution time for inserting datasets and selecting data depends on the size of the data volumes, the locations (nodes of the same or different networks) from which they send or retrieve and what is the effect of the selected data organization (especially RowKey design) on the execution time.  
https://www.temjournal.com/content/103/TEMJournalAugust2021_1051_1057.pdf  


---
hbase best suited for web applications due to its fast random read queries. But this only comes with very good row key design. This involves you planning out your end queries well in advance and design your row key. Special care needs to be take in row key desing if you also have time based data and your queries heavily depend on it. In short, you should avoid hot spotting.

---
It is worth noting because there are systems that can store values of different columns separately, but that can’t effectively process analytical queries due to their optimization for other scenarios. Examples are HBase, BigTable, Cassandra, and HyperTable. You would get throughput around a hundred thousand rows per second in these systems, but not hundreds of millions of rows per second.


