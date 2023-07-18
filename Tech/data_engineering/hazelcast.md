http://www.baeldung.com/java-hazelcast

Hazelcast is an open source in-memory data grid based on Java.In a Hazelcast grid, data is evenly distributed among the nodes of a computer cluster, allowing for horizontal scaling of processing and available storage.

https://hazelcast.org/mastering-hazelcast/#online-book-resources


### For single node caching Hazecast is much slower than in memory java collectiions
 - Hazelcast read/write is almost 80 times slower than using a in-memory Java Map collection to store the objects.
 - we shouldn't need to use Hazelcast if it's just one node as there won't be any need for distributed caching
 
### Each jvm can have multiple nodes
JVM can host multiple Hazelcast instances (nodes). Each node can only participate in one group and it only joins to its own group, does not mess with others. Following code creates 3 separate Hazelcast nodes, h1 belongs to app1 cluster, while h2 and h3 are belong to app2 cluster.
```java
Config configApp1 = new Config();
        configApp1.getGroupConfig().setName("app1");

        Config configApp2 = new Config();
        configApp2.getGroupConfig().setName("app2");

        HazelcastInstance h1 = Hazelcast.newHazelcastInstance(configApp1);
        HazelcastInstance h2 = Hazelcast.newHazelcastInstance(configApp2);
        HazelcastInstance h3 = Hazelcast.newHazelcastInstance(configApp2);
 ```

### dev/uat/prod group
```java
<hazelcast>
	<group>
		<name>dev</name>
		<password>dev-pass</password>
	</group>
	...
	
</hazelcast>
```

https://blog.hazelcast.com/in-memory-format/

 In Hazelcast there is a lot of control on the format that is used to store the value using the following 3 in-memory-formats: 
 1. BINARY: the value is stored in serialized form.
 is more efficient compared to OBJECT if normal map operations like get/put are in the majority. This sounds counter intuitive, but the BINARY in-memory-format exactly matches the format required for reading/writing since Hazelcast will always serialize when writing and deserialize when reading. With the OBJECT format an additional step is required; when a value is written, first it is serialized (just like BINARY) but then it needs to be deserialized to be stored as object. When the value is read, it needs to be serialized before it can be deserialized (the actual object instance is never returned)
 
 2. OBJECT: the value is not stored in a serialized form, but stored as a normal object instance. 
 if the majority of your operations are queries/entry-processors. These operations are allowed to directly access the stored object and bypass any serialization/deserialization unlike the BINARY format.
 
 3. CACHED: this is a combination BINARY and OBJECT: the value always is stored in serialized form, but when it is needed, it cached in object form, so it doesn’t need to be deserialized when the object form is needed again. 
 combines the advantages of the BINARY and OBJECT format, but it uses more memory since the value is potentially stored in 2 formats instead of 1.
 
 ### Partition
 
 `hazelcast.map.partition.count` configuration property is used to setup the count.
 
 Data is broken down into partition for resilience. By default there are 271 partition within a cluster. It is partitioned by key.
 
 Each partitioned is backed up by another node other than the owner. When a node goes down, the ownership of any of the partition owned by the defunct node will be migrated to one of the backups. Morever the data will be migrated to another backup node so as to have same resilience.
 
 ```java
 <hazelcast>

  <map name="default">
    <backup-count>1</backup-count>
    <async-backup-count>1</async-backup-count>
    <read-backup-data>false</read-backup-data>
  </map>

  <map name="capitals">
    <backup-count>2</backup-count>
    <async-backup-count>1</async-backup-count>
    <read-backup-data>true</read-backup-data>
  </map>

  <map name="countries.*">
    <backup-count>1</backup-count>
    <async-backup-count>1</async-backup-count>
    <read-backup-data>false</read-backup-data>
  </map>

</hazelcast>
 ```
 
 - backup-count  : This is the sync backup count
 - async-backup-count : This is async which does not block on put, delete operation
 
 total number of copies = 1 (owner) + backup-count + aysnc-backup-count
 
 - read-backup-data : For using this, the async-backup should be 0 else we may be reading data from backup partition which may be still be modified
 
 ### Fair share of load across nodes
 A cluster of four nodes with 4 million object will have each node have 1 million owned object and 1 million backup
 
 
 ### Partition grouping
 Hazelcast considers each instance as a separate node. If there are 4 instances within a single machine they share the same risk of hadrware going down. 

- The default group type is  `group-type="PER_MEMBER" ` 
- HOST_AWARE : This group type makes the instances sharing the same IP address or interface be part of same group
-- http://docs.hazelcast.org/docs/3.9.3/manual/html-single/index.html#grouping-types
 if there are multiple network interfaces or domain names per physical machine, that will make this assumption invalid.
- CUSTOM : manual configuration

```bash
<hazelcast>
  <partition-group enabled="true" group-type="HOST_AWARE" />
</hazelcast>

<hazelcast>
  <partition-group enabled="true" group-type="CUSTOM">

    <member-group>
      <interface>10.0.1.*</interface>
      <interface>10.0.2.1-127</interface>
    </member-group>

    <member-group>
      <interface>10.0.2.128-254</interface>
      <interface>10.0.3.*</interface>
    </member-group>

    <member-group>
      <interface>10.0.4.*</interface>
    </member-group>

  </partition-group>
</hazelcast>
```
When using partition group, the partition backup is held at group level and not node level. So each group will have backup of partition.

### Split brain merge policy on network failure

Different merge policies determine the merge when separate networks come back after disconnect.

LatestUpdateMapMergePolicy is most useful as it merges based on which is most recently updated or created.

```java
<hazelcast>
  <map name="default">
    <merge-policy>
      com.hazelcast.map.merge.LatestUpdateMapMergePolicy
    </merge-policy>
  </map>
</hazelcast>
```

### Cluster Quorum
This allows us to define a set of health rules around individual maps or the cluster as a whole, with Hazelcast preventing access to our data (either read, write, or both) should this health rule be violated. Eg we should atleast have tow nodes in cluster.

```bash
<hazelcast>
  <quorum name="requireAtLeastTwoNodes" enabled="true">
    <quorum-size>2</quorum-size>
    <quorum-type>WRITE</quorum-type>
  </quorum>

  <map name="default">
    <quorum-name>requireAtLeastTwoNodes</quorum-name>
  </map>
</hazelcast>
```
