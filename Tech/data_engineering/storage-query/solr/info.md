
## Solr Configuration Files

### Server config file
solr.xml specifies configuration options for your Solr server instance.

### Per Solr Core config file

- `core.properties` : defines specific properties for each core such as its name, the collection the core belongs to, the location of the schema, and other parameters.
- `solrconfig.xml` : controls high-level behavior. You can, for example, specify an alternate location for the data directory.
- `schema.xml` : managed-schema (or schema.xml instead) describes the documents you will ask Solr to index. The Schema define a document as a collection of fields. You get to define both the field types and the fields themselves. Field type definitions are powerful and include information about how Solr processes incoming field values and query values. 
- `data/` : The directory containing the low level index files.

### Sharding and Replication 
`Sharding` is a scaling technique in which a collection is split into multiple logical pieces called "shards" in order to scale up the number of documents in a collection beyond what could physically fit on a single server. Incoming queries are distributed to every shard in the collection, which respond with merged results.

`Replication` : "Replication Factor" of your collection, which allows you to add servers with additional copies of your collection to handle higher concurrent query load by spreading the requests around to multiple machines.

SolrCloud uses sharding and replication for scaling.

### Solr and Zookeeper
SolrCloud is flexible distributed search and indexing, without a master node to allocate nodes, shards and replicas. Instead, Solr uses ZooKeeper to manage these locations, depending on configuration files and schemas. Queries and updates can be sent to any server. Solr will use the information in the ZooKeeper database to figure out which servers need to handle the request.

### Logical concepts
- A Cluster can host multiple Collections
- A collection can be partitioned into multiple Shards
- The amount of parallelization that is possible for an individual search request is determined by number of shards

### Physical concepts
- A Cluster is made up of one or more Solr Nodes (JVM processes)
- Each Node is a JVM process that can host multiple Cores
- A Solr core is basically an index of the text and fields found in documents. A single Solr Node can contain multiple "cores"


### No Master Slave
Solr does not have master slave concept. Instead we have a distributed search where indexes are shareded across nodes.
If you have bootstrapped Solr with numShards=2, for example, your indexes are split across both shards

### Solrctl
For collection configuration, users have the option of 
- interacting directly with ZooKeeper using the instancedir option (solrctl instancedir )or 
- using Solr's ConfigSet API using the config option (solrctl config )

The difference between both is that using the config api is more secure. Compared in the link
- https://www.cloudera.com/documentation/enterprise/5-7-x/topics/search_solrctl_managing_solr.html#concept_h44_bbc_mt


#### instancedir
Each SolrCloud collection must be associated with an instance directory, though note that different collections can use the same instance directory.
```bash
#Generate the config files for the collection:
$ solrctl instancedir --generate $HOME/solr_configs2
#Upload the instance directory to ZooKeeper. This base config cane be used by multiple collections
$ solrctl instancedir --create collection_base $HOME/solr_configs2
# create the config
$solrctl config --create collection1 collection_base
# create the collection with 2 shard
$solrctl collection --create collection1 -s 2
```

#### Batch ingestion with cloudera morphline
Morphlines replaces Java programming with simple configuration steps, reducing the cost and effort of doing custom ETL.

Morphline is a configuration file which can be used for doing ETL transformation on incoming data and ingest them into Solr. Morphline reads data from HDFS. It can read files in CSV, JSON, AVRO, RCFILE etc: 

The Morphlines library takes in a Morphlines configuration file that defines a set and order of transformations in a JSON-like format. In this way, you can use the Morphlines library and write little or no Java code at all. 

References
- http://cloudera.github.io/cdk/docs/current/cdk-morphlines/morphlinesReferenceGuide.html
- https://blog.cloudera.com/blog/2013/07/morphlines-the-easy-way-to-build-and-integrate-etl-apps-for-apache-hadoop/
- https://github.com/cloudera/cdk/tree/master/cdk-morphlines

Example of ingesting data in parquet format:
- https://medium.com/@bkvarda/index-parquet-with-morphlines-and-solr-20671cd93a41

With Envelope:
- Morphline is one of the derivers for cloudera envelope. 
- The morphline file can be provided to the Spark executors from spark2-submit using the --files option.
