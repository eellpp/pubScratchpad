
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



