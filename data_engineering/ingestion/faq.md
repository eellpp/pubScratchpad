
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
