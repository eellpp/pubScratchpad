
### Apache Folder Structure
http://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html

### Java coding guidelines
https://wiki.sei.cmu.edu/confluence/display/java/Java+Coding+Guidelines

### Code Convention
http://www.oracle.com/technetwork/java/codeconventions-135099.html#367

- Classes are Nouns : Company
- Functions are verbs : getName()
- Variables are short : name

### Interface and Implementation naming
An Interface in Java is a Type. Then you have DumpTruck, TransferTruck, WreckerTruck, CementTruck, etc that implement Truck.
When you are using the Interface in place of a sub-class you just cast it to Truck. As in List<Truck>
   
> For instance, if you have a XMLParser interface, your implementations should be XMLFileParser, XMLInputStreamParser etc. If you cannot find a decent name for your class, maybe your should consider your design again.

https://web.archive.org/web/20130331071928/http://isagoksu.com/2009/development/java/naming-the-java-implementation-classes

Look to the Java standard library itself. Do you see IList, ArrayListImpl, LinkedListImpl? No, you see List and ArrayList, and LinkedList.

https://stackoverflow.com/questions/2814805/java-interfaces-implementation-naming-convention
