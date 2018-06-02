
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


## No Master Slave
Solr does not have master slave concept. Instead we have a distributed search where indexes are shareded across nodes.
If you have bootstrapped Solr with numShards=2, for example, your indexes are split across both shards


