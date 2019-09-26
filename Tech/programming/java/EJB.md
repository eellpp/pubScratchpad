## What does an EJB do

http://stackoverflow.com/questions/12872683/what-is-an-ejb-and-what-does-it-do

An EJB is a Java component, containing business logic, that you deploy in a container, and that benefits from technical services provided by the container, usually in a declarative way, thanks to annotations:

- Transaction management: a transaction can be started automatically before a method of the EJB is invoked, and committed or rollbacked once this method returns. This transactional context is propagated to calls to other EJBs.
- Security management: a check can be made that the callerhas the necessary roles to execute the method
- Dependency injection: other EJBs, or resources like a JPA entity manager, a JDBC datasource, etc. can be injected into the EJB
- Concurrency: the container makes sure that only one thread at a time invokes a method of your EJB instance
- Distribution: some EJBs can be called remotely, from another JVM
- Failover and load-balancing: remote clients of your EJBs can automatically have their call redirected to another server if necessary
- Resource management: stateful beans can automatically be passivated to disk in order to limit the memory consumption of your server
... I probably have forgotten some points
