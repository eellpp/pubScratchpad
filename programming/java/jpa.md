## JPA vs Hibernate

As you state JPA is just a specification, meaning there is no implementation. You can annotate your classes as much as you would like with JPA annotations, however without an implementation nothing will happen. Think of JPA as the guidelines that must be followed or an interface, while Hibernate's JPA implementation is code that meets the API as defined by the JPA specification and provides the under the hood functionality.

JPA is the interface while Hibernate is the implementation.

When you use Hibernate with JPA you are actually using the Hibernate JPA implementation. The benefit of this is that you can swap out Hibernate's implementation of JPA for another implementation of the JPA specification. When you use straight Hibernate you are locking into the implementation because other ORMs may use different methods/configurations and annotations, therefore you cannot just switch over to another ORM.

As explained in  book, High-Performance Java Persistence, Hibernate offers features that are not yet supported by JPA:

- extended identifier generators (hi/lo, pooled, pooled-lo)
- transparent prepared statement batching
- customizable CRUD (@SQLInsert, @SQLUpdate, @SQLDelete) statements
- static or dynamic collection filters (e.g. @FilterDef, @Filter, @Where) and entity filters (e.g. @Where)
- mapping properties to SQL fragments (e.g. @Formula)
- immutable entities (e.g. @Immutable)
- more flush modes (e.g. FlushMode.MANUAL, FlushMode.ALWAYS)
- querying the second-level cache by the natural key of a given entity
- entity-level cache concurrency strategies (e.g. Cache(usage = CacheConcurrencyStrategy.READ_WRITE))
- versioned bulk updates through HQL
- exclude fields from optimistic locking check (e.g. @OptimisticLock(excluded = true))
- versionless optimistic locking (e.g. OptimisticLockType.ALL, OptimisticLockType.DIRTY)
- support for skipping (without waiting) pessimistic lock requests
- support for Java 8 Date and Time
- support for multitenancy
- support for soft delete (e.g. @Where, @Filter)

These extra features allow Hibernate to address many persistence requirements demanded by large enterprise applications.

## Hive with JPA ??

No. The "R" in ORM stands for a "relational database". Hive is a NOSQL databse, not a relational database. It's a huge advantage of Hive comparing to many other NOSQL databases that you can access it using (almost) normal SQL and using (almost) full featured standard JDBC interface. But if you are thinking about using ORM and Hive together, you might be approaching your problem from an incorrect angle.

> Wikipedia: In the relational model, each table schema must identify a primary column used for identifying a row called the primary key. Tables can relate by using a foreign key that points to the primary key.

Hive does not support neither foreign nor primary keys, so it is not a relational database.

Hive is actually a warehouse that runs on top of your Hadoop cluster. And even if you to think of it from a database point of view, then Hive is not a full database. The design constraints and limitations of Hadoop and HDFS impose limits on what Hive can do. The biggest limitation is that Hive does not provide record-level update, insert, nor delete. Hive does not provide transactions either. Apart from the warehousing capability Hive provides an SQL dialect, called Hive Query Language for querying data stored in a Hadoop cluster. SO, people sometimes get confused and think of it as a DB.

