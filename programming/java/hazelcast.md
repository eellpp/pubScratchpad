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
 
 
 
