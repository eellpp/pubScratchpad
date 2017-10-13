
https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#spring-core

The interface org.springframework.context.ApplicationContext represents the Spring IoC container and is responsible for 
- instantiating, 
- configuring, 
- and assembling the aforementioned beans. 
The container gets its instructions on what objects to instantiate, configure, and assemble by _reading configuration metadata_. 
The configuration metadata is represented in XML, Java annotations, or Java code. 


### Java-based configuration: 
Starting with Spring 3.0, many features provided by the Spring JavaConfig project became part of the core Spring Framework. Thus you can define beans external to your application classes by using Java rather than XML files. To use these new features, see the @Configuration, @Bean, @Import and @DependsOn annotations.

 Java configuration typically uses @Bean annotated methods within a @Configuration class.
 
These bean definitions correspond to the actual objects that make up your application. Typically you define service layer objects, data access objects (DAOs), presentation objects such as Struts Action instances, infrastructure objects such as Hibernate SessionFactories, JMS Queues, and so forth. 

_Note: Typically one does not configure fine-grained domain objects in the container, because it is usually the responsibility of DAOs and business logic to create and load domain objects_.

### @Bean and @Configuration

https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-java

You can use @Bean annotated methods with any Spring @Component, however, they are most often used with @Configuration beans.
Annotating a class with @Configuration indicates that its primary purpose is as a source of bean definitions. Furthermore, @Configuration classes allow inter-bean dependencies to be defined by simply calling other @Bean methods in the same class. The simplest possible @Configuration class would read as follows:

```java
@Configuration
public class AppConfig {

        @Bean
        public MyService myService() {
                return new MyServiceImpl();
        }
}
```

### Instantiating the Application Context
AnnotationConfigApplicationContext is implementation of ApplicationContext. AnnotationConfigApplicationContext can accepts @configuration classes and @Component classes as inputs
```java
public static void main(String[] args) {
        ApplicationContext ctx = new AnnotationConfigApplicationContext(AppConfig.class);
        MyService myService = ctx.getBean(MyService.class);
        myService.doStuff();
}

@Configuration
@ComponentScan(basePackages = "com.acme")
public class AppConfig  {
           ...
}
```




