## Java containers
J2EE/Java EE applications aren't self contained. In order to be executed, they need to be deployed in a container. In other words, the container provides an execution environment on top of the JVM.

Also, applications rely on several APIs like JPA, EJB, servlet, JMS, JNDI, etc. The role of the EE compliant container is to provide a standard implementation of all or some of these APIs. This means you can theoretically run your application on top of any container as long as it relies on standard APIs.

From a technical perspective, a container is just another Java SE application with a main() method. EE applications on the other hand are a collection of services/beans/servlets/etc. The container finds these components and runs them, providing API implementations, monitoring, scalability, reliability and so on.

The common containers in Java EE are servlet container and the EJB container, and I see these as examples of IoC(Inversion of Control) containers. The crucial aspects are :

- Your code does not have any main() or "wait here for a request logic" - the container starts up and configures itself and then eventually initialises your code and delivers requests
- Your code may be one of many similar classes (servlets in a servlet container, EJBs in an EJB container) whose instances have life-cycles to be controlled by the container.
- Requests are delivered to your servlet or EJB via some protocol defined by the container, using resources (eg. HTTP ports) controlled by the container, and possibly with considerable infrastructure cleverness (look at the HTTP request queues, EJB load balancing etc.)
- There's considerable added value from functions such as transaction control and security management - as the container is calling your code it is well-placed to implement this unintrusively.
- The main container functionality is very much IOC, the container calls your code at appropriate times, however the container will also provide useful APIs that your code can call (eg. to get Servlet or EJB Contexts.


Contrary to the servlet container (e.g. Tomcat), "full" Java EE application servers contain also an EJB container. EJB are Enterprise Java Beans and you can read a lot about them for example here (chapter IV). EJBs are now in version 3.2 (Java EE 7), previous versions are 3.1 (Java EE 6) and 3.0 (Java EE 5); however the greatest difference is between v2 and v3.

EJBs are designed to keep a business logic of your application. For example, stateless session bean can calculate something, or represent a Web service or whatever your application needs to do. Message-driven beans can listen on message queues, therefore they are useful if you want asynchronous communication. Singleton beans guarantee one instance per bean etc.

Regarding the file type, EJB is packed into a .jar file, Web application into a .war file, and if you want to mix them in a single application, that would be the .ear file ("enterprise archive").

Beside EJBs, "full" application server also takes care about transactions, security, JDBC resources.. I would highly recommend using it over a servlet container, but the benefits come with the complexity so you will have to spend a reasonable amount of time to learn how to deal with e.g. Websphere (Glassfish is much simpler, and it is my favourite). JBoss and Weblogic are also quite popular, and if you are familiar with Tomcat take a look at TomEE.

## Tomcat Container
It's both a web server (supports HTTP protocol) and a web container (supports JSP/Servlet API, also called "servlet container" at times). But it's not really meant to function as a high performance web server, nor does it include some features typical of a web server. Tomcat is meant to be used in conjunction with the Apache web server, where Apache manages static pages, caching, redirection, etc. and Tomcat handles the container (web application) functions.

## Web-INF

When you deploy a Java EE web application (using frameworks or not),its structure must follow some requirements/specifications. These specifications come from : 

The servlet container (e.g Tomcat)
- Java Servlet API
- Your application domain
- The Servlet container requirements

If you use Apache Tomcat, the root directory of your application must be placed in the webapp folder. That may be different if you use another servlet container or application server.

Java Servlet API requirements

Java Servlet API states that your root application directory must have the following structure :
``` java
ApplicationName
 |
 |--META-INF
 |--WEB-INF
       |_web.xml       <-- Here is the configuration file of your web app(where you define servlets, filters, listeners...)
      |_classes       <--Here goes all the classes of your webapp, following the package structure you defined. Only 
      |_lib           <--Here goes all the libraries (jars) your application need
```

These requirements are defined by Java Servlet API.

3. Your application domain
Now that you've followed the requirements of the Servlet container(or application server) and the Java Servlet API requirements, you can organize the other parts of your webapp based upon what you need. 
- You can put your resources (JSP files, plain text files, script files) in your application root directory. But then, people can access them directly from their browser, instead of their requests being processed by some logic provided by your application. So, to prevent your resources being directly accessed like that, you can put them in the WEB-INF directory, whose contents is only accessible by the server.

