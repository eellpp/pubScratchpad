
Available in JDK installation. 

Used to monitor the performance of local and remote application. 

processID of the application : tasklist command 

> jconsole <pid>

### Memory Pools:

The heap memory is the runtime data area from which the Java VM allocates memory for all class instances and arrays. The heap may be of a fixed or variable size. The garbage collector is an automatic memory management system that reclaims heap memory for objects.
- Eden Space: The pool from which memory is initially allocated for most objects.
- Survivor Space: The pool containing objects that have survived the garbage collection of the Eden space.
- Tenured Generation: The pool containing objects that have existed for some time in the survivor space.
- Perm Gen :

https://stackoverflow.com/questions/1262328/how-is-the-java-memory-pool-divided

### Threads Tab

Peak number of threads
- can view any deadlock that has happened

### VM Summary

Get overview about the system etc

### MBeans
beans for monitoring via JMX
