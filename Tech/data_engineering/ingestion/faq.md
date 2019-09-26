
Q: A NLP data pipeline processes the incoming stream and generates NER tags in json format. Since each of these json files are small in size, how to store in hdfs. 

A: 
In hdfs, large number of small files are not favourable. 
If the data is to stored as an external hive table formatted hourly, then each hours data can be written in sequence file format. 
- native hadoop internal format
- the entire row can can be read at once. This is the intended query pattern here. ( if the query requires subset of the data, and operates on columns, like filtering etc, then better store in columnar format like parquet)
- splittable and compressed. The compression codec support is available locally with hadoop
 
 A Sequence File is a file containing a sequence of binary Key/Value records, where both Key and Value are serialized objects.
 Each row will contain the full json string. A unique key will be generated for each row by the writing class. 

Reference 
- http://blog.ditullio.fr/2015/12/18/hadoop-basics-working-with-sequence-files/

Q: What is the default number of partitions that spark creates while doing shuffling ?

- It creates 200 partitions by default. It is set by spark.sql.shuffle.partitions. 
However each file should be around the block size. The large number of partition helps in parallelism when operating on large data.

Q: How to avoid writing large number of files to hive from spark while appending data to table?

- Use the coalesce command. Another way is use repartition which is not favoured since it involves full shuffle across network.
- new_df.coalesce(2).write.mode("append").partitionBy("week").insertInto(db.tablename)

Q: How does coalesce works in spark?

- With repartition() the number of partitions can be increased/decreased, but with coalesce() the number of partitions can only be decreased.

- coalesce avoids a full shuffle. If it's known that the number is decreasing then the executor can safely keep data on the minimum number of partitions, only moving the data off the extra nodes, onto the nodes that we kept.

So, it would go something like this:
```bash
Node 1 = 1,2,3
Node 2 = 4,5,6
Node 3 = 7,8,9
Node 4 = 10,11,12
Then coalesce down to 2 partitions:

Node 1 = 1,2,3 + (10,11,12)
Node 3 = 7,8,9 + (4,5,6)
```
Notice that Node 1 and Node 3 did not require its original data to move.

Q: If i partition by column and the column contains only one type, then on repartition how many paritions will be created by default in spark ?

- A: 200 partition. The first partition will have the data and rest 199 will be empty. This is the default optimization in spark to enhance performance which could be true in most cases.

Q: How to avoid creating small files during hive job ?

- Set hive.merge.smallfiles.avgsize . The default is 16MB
- When the average output file size of a job is less than this number, Hive will start an additional map-reduce job to merge the output files into bigger files. 

Q: How to generate a single file of 256 MB during a hive job, when the average file size is 99KB ?
- set hive.merge.size.per.task - 256000000 (default)

set hive.merge.mapredfiles=true;
set hive.merge.smallfiles.avgsize=102400

Here since our average size of file is 99 KB which is less than 100 KB we can choose 100KB for hive.merge.smallfiles.avgsize property to make the files eligible for merge.




