
Available in JDK installation. 

Used to monitor the performance of local and remote application. 

processID of the application : tasklist command 

> jconsole <pid>

The overview provides a dashboard for viewing four monitoring metrics (heap memory, threads, classes, CPU usage) and additionally lets you specify a time range going back to 1 year. The time range feature is also available on three other tabs.
  
### Memory Tab

The Memory tab shows a chart detailing the Heap Memory usage as well as an ability to perform garbage collecting if you are running into those OutofMemoryErrors. You can also view the breakdown of the Heap vs. Non-Heap percentages in the lower right. 

#### heap memory
The heap memory is the runtime data area from which the Java VM allocates memory for all class instances and arrays. The heap may be of a fixed or variable size. The garbage collector is an automatic memory management system that reclaims heap memory for objects.
- Eden Space: The pool from which memory is initially allocated for most objects.
- Survivor Space: The pool containing objects that have survived the garbage collection of the Eden space.
- Tenured Generation: The pool containing objects that have existed for some time in the survivor space.
- Perm Gen :

https://stackoverflow.com/questions/1262328/how-is-the-java-memory-pool-divided

### Threads Tab
The Threads tab allow you to pick an active thread and check out its stack trace while simultaneously showing the running number of threads on the top in a graph format. You will also see a deadlock detection feature allowing you to determine if there are any threads in the deadlock state.

Peak number of threads
- can view any deadlock that has happened

### Classes Tab
The Classes tab shows the number of classes loaded and unloaded, also in  a running graph.

### VM Summary
 The VM summary gives detailed information and statistics of the Operating System/VM as well as additional information from the four main metrics.  
 
Get overview about the system etc

### MBeans
beans for monitoring via JMX

MBeans are generally beans with the Java Management Extensions technology that allow you to view resources running in the JVM which collect statistics on application specific properties that go into performance and configuration detail. The MBeans tree on the left hand side can be customized by providing the information when starting JConsole at the command line. The tree provides an easy viewing of the name/value pairs.


Since Jconsole may itself consume resources, it is recommended to use jconsole remotely.
