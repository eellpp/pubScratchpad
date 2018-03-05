
### Hbase copy specific columns of a table to another table

- Using copy table utility
https://github.com/apache/hbase/blob/f572c4b80e2bef91f582ed5b535c4ba695d63a2d/hbase-mapreduce/src/main/java/org/apache/hadoop/hbase/mapreduce/CopyTable.java

hbase org.apache.hadoop.hbase.mapreduce.CopyTable  --peer.adr=server1,server2,server3:2181:/hbase --families=myOldCf:myNewCf,oldcf2:newcf2,cf3 --new.name=DestinationTableName SourceTestTable

### Drop a column family

If you want to drop a column family from the whole table you can do that via HBaseAdmin with the not so aptly named deleteColumn method (or the shell with alter 'table_name', {NAME => 'family_name', METHOD => 'delete'}) - in this case the table needs to be disabled first so while HBase won't suffer a downtime, the specific table will
