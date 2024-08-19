Facebook. 
 
 RocksDB is a high-performance, embeddable key-value store for fast storage. It is a C++ library to store keys and values, which are arbitrarily-sized byte streams. It supports both point lookups and range scans, and provides different types of ACID guarantees.

 - low-latency and high-throughput operations.
 - handle large datasets with efficient read/write performance.

### Useful as a write through cache
In scenarios where you need to persist data immediately, but still want the low-latency benefits of a cache, RocksDB can be used as a write-through cache.   

### Larger than main memory cache
One important advantage of RocksDB in contrast to pure in-memory key-value stores is its ability to write to disc.   
For this reason it is used by kafka streams so that a state larger than available main memory can be supported by Kafka Streams.

### As persistent cache that survives crash
RocksDB is used to provide a persistent caching layer that survives application restarts. For example, Facebook uses RocksDB as a backend for its Facebook Graph Search.

## As embedded time series database
https://stackoverflow.com/questions/40110511/why-apache-kafka-streams-uses-rocksdb-and-if-how-is-it-possible-to-change-it

### rocksjava
https://github.com/facebook/rocksdb/wiki/rocksjava-basics  
RocksJava is a project to build high performance but easy-to-use Java driver for RocksDB.

RocksJava is structured in 3 layers:

- The Java classes within the org.rocksdb package which form the RocksJava API. Java users only directly interact with this layer.
- JNI code written in C++ that provides the link between the Java API and RocksDB.
- RocksDB itself written in C++ and compiled into a native library which is used by the JNI layer.

 

RocksDB organizes all data in sorted order and the common operations are Get(key), NewIterator(), Put(key, val), Delete(key), and SingleDelete(key).

The three basic constructs of RocksDB are memtable, sstfile and logfile

The memtable is an in-memory data structure - new writes are inserted into the memtable and are optionally written to the logfile (aka. Write Ahead Log(WAL)). The logfile is a sequentially-written file on storage. When the memtable fills up, it is flushed to a sstfile on storage and the corresponding logfile can be safely deleted. The data in an sstfile is sorted to facilitate easy lookup of keys.


RocksDB supports partitioning a database instance into multiple column families. All databases are created with a column family named "default", which is used for operations where column family is unspecified.

### Interator
All data in the database is logically arranged in sorted order. An application can specify a key comparison method that specifies a total ordering of keys. An Iterator API allows an application to do a range scan on the database. The Iterator can seek to a specified key and then the application can start scanning one key at a time from that point. The Iterator API can also be used to do a reverse iteration of the keys in the database. A consistent-point-in-time view of the database is created when the Iterator is created. Thus, all keys returned via the Iterator are from a consistent view of the database.

### Snapshot
A Snapshot API allows an application to create a point-in-time view of a database. The Get and Iterator APIs can be used to read data from a specified snapshot. 

https://github.com/facebook/rocksdb/wiki/RocksDB-Overview
