

### JMX

Java management extensions

Jconsole and VisualVM

An Application to be managed will provide an MBean interface and implementation of that. These Mbean will register with the MBean Server (available in standard JVM deployment). The remote client connects to application through the Mbean server. 

JMX Client exposes the API which can be used by remote client like visual VM , JConsole etc.

Notification : Mbean has to implement the notification interface. MBean can emit the notification. Client can register for listening notification.




