
### Doc for java args.  
https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html

-Dproperty=value.  
Sets a system property value. The property variable is a string with no spaces that represents the name of the property. The value variable is a string that represents the value of the property. If value is a string with spaces, then enclose it in quotation marks (for example -Dfoo="foo bar").  



`Program arguments` are arguments passed to your program and available in the args array of your main method

`VM arguments` are passed to the virtual machine and are designed to instruct the VM to do something. You can do things like control the heap size, etc.

### JVM Args
You have distinct categories of JVM arguments :

1. Standard Options (-D but not only).

These are the most commonly used options that are supported by all implementations of the JVM.

You use -D to specify System properties but most of them don't have any prefix :-verbose, -showversion, and so for...

2. Non-Standard Options (prefixed with -X)

These options are general purpose options that are specific to the Java HotSpot Virtual Machine.
For example : -Xmssize, -Xmxsize

3. Advanced Runtime Options (prefixed with -XX)

These options control the runtime behavior of the Java HotSpot VM.

4. Advanced JIT Compiler Options (prefixed with -XX)

These options control the dynamic just-in-time (JIT) compilation performed by the Java HotSpot VM.

5. Advanced Serviceability Options (prefixed with -XX)

These options provide the ability to gather system information and perform extensive debugging.

6. Advanced Garbage Collection Options (prefixed with -XX)

These options control how garbage collection (GC) is performed by the Java HotSpot VM.

### SPring boot args
>>> mvn spring-boot:run -Dspring-boot.run.arguments=--spring.main.banner-mode=off,--customArgument=custom. 


Other than passing custom arguments, we can also override system properties.

For example, here's our application.properties file:

server.port=8081  
spring.application.name=SampleApp   

To override the server.port value, we need to pass the new value in the following manner 


>>> mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8085  

### Command line args
java -jar cli-example.jar Hello World!   
Java will treat every argument we pass after the class name or the jar file name as the arguments of our application. Therefore, everything we pass before that are arguments for the JVM itself.  

