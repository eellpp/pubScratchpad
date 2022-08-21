
## Differences between @Component, @Repository, @Controller and @Service
`@Component`

This is a general-purpose stereotype annotation indicating that the class is a spring component.

### What’s special about @Component
<context:component-scan> only scans @Component and does not look for @Controller, @Service and @Repository in general. They are scanned because they themselves are annotated with @Component.

Just take a look at @Controller, @Service and @Repository annotation definitions:
```java
@Component
public @interface Service {
    ….
}
 

@Component
public @interface Repository {
    ….
}
 

@Component
public @interface Controller {
    …
}
```
Spring 2.5 introduces further stereotype annotations: @Component,  @Service, and @Controller. @Component is a generic stereotype for any Spring-managed component. @Repository, @Service, and @Controller are specializations of @Component for more specific use cases, for example, in the persistence, service, and presentation layers, respectively.

Therefore, you can annotate your component classes with @Component, but by annotating them with @Repository, @Service, or @Controller instead, your classes are more properly suited for processing by tools or associating with aspects. For example, these stereotype annotations make ideal targets for pointcuts.

Thus, it’s not wrong to say that @Controller, @Service and @Repository are special types of @Component annotation. <context:component-scan> picks them up and registers their following classes as beans, just as if they were annotated with @Component.

They are scanned because they themselves are annotated with @Component annotation. If we define our own custom annotation and annotate it with @Component, then it will also get scanned with <context:component-scan>

### @Repository

This is to indicate that the class defines a data repository.
In Spring 2.0 and later, the @Repository annotation is a marker for any class that fulfills the role or stereotype (also known as Data Access Object or DAO) of a repository. Among the uses of this marker is the automatic translation of exceptions.

What’s special about @Repository?

In addition to pointing out that this is an Annotation based Configuration, @Repository’s job is to catch Platform specific exceptions and re-throw them as one of Spring’s unified unchecked exception. And for this, we’re provided with PersistenceExceptionTranslationPostProcessor, that we are required to add in our Spring’s application context like this:

<bean class="org.springframework.dao.annotation.PersistenceExceptionTranslationPostProcessor"/>
This bean post processor adds an advisor to any bean that’s annotated with @Repository so that any platform-specific exceptions are caught and then rethrown as one of Spring’s unchecked data access exceptions.

### @Controller

The @Controller annotation indicates that a particular class serves the role of a controller. The @Controller annotation acts as a stereotype for the annotated class, indicating its role.

What’s special about @Controller?

We cannot switch this annotation with any other like @Service or @Repository, even though they look same. The dispatcher scans the classes annotated with @Controller and detects @RequestMapping annotations within them. We can only use @RequestMapping on @Controller annotated classes.

### @Service

@Services hold business logic and call method in repository layer.

What’s special about @Service?

Apart from the fact that it is used to indicate that it's holding the business logic, there’s no noticeable speciality that this annotation provides, but who knows, spring may add some additional exceptional in future.

What else?

Similar to above, in future Spring may choose to add special functionalities for @Service, @Controller and @Repository based on their layering conventions. Hence its always a good idea to respect the convention and use them in line with layers.

### @PostConstruct
A method annotated by @PostConstruct is run just after all services initialized.

```java
 @PostConstruct
  public void init(){
     // init code goes here
  }
  ```
  
  
