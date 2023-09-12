### What is inversion of control for Spring JDBC?

Inversion of Control in the context of Spring means that the framework controls the creation, configuration, and management of application objects and their interactions. This helps in building more modular, maintainable, and testable applications by reducing tight coupling and promoting separation of concerns.

In Spring, you define your application's components (beans) using configuration metadata, which can be XML-based or annotation-based. These configurations tell the Spring container what beans to create and how they are related to each other.

Dependency injection, an aspect of Inversion of Control (IoC), is a general concept stating that we do not create our objects manually but instead describe how they should be created. Then an IoC container will instantiate required classes if needed

### What does @Component annotation mean in spring
@Component is an annotation that allows Spring to detect our custom beans automatically.

In other words, without having to write any explicit code, Spring will:

Scan our application for classes annotated with @Component
Instantiate them and inject any specified dependencies into them
Inject them wherever needed

### What is the use of @Configuration Annotation in spring
In Spring Framework, the @Configuration annotation is used to indicate that a class defines one or more beans that should be managed by the Spring IoC container. When a class is annotated with @Configuration, it effectively becomes a configuration class, and Spring treats it as a source of bean definitions. 

Suppose you have a Spring application that manages two beans: a UserService and a EmailService. You want to configure these beans using a Java-based configuration class.

```java
public class UserService {
    private String name;

    public UserService(String name) {
        this.name = name;
    }

    public String getGreeting() {
        return "Hello from " + name;
    }
}

```

```java
public class EmailService {
    public void sendEmail(String recipient, String message) {
        System.out.println("Sending email to " + recipient + ": " + message);
    }
}

```
create a configuration class named AppConfig using the @Configuration annotation:  

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

    @Bean
    public UserService userService() {
        return new UserService("John");
    }

    @Bean
    public EmailService emailService() {
        return new EmailService();
    }
}

```

Use the configured beans in your application:   

```java
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class MainApp {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        UserService userService = context.getBean(UserService.class);
        System.out.println(userService.getGreeting());

        EmailService emailService = context.getBean(EmailService.class);
        emailService.sendEmail("example@example.com", "Hello there!");

        context.close();
    }
}


```

### What Is the Default Bean Scope in Spring Framework?
By default, a Spring Bean is initialized as a singleton.  

### What is a Singleton Pattern
The Singleton Pattern is a creational design pattern that ensures a class has only one instance and provides a global point of access to that instance  

The Singleton Pattern is commonly used to manage resources that are shared among multiple components of an application.

### Are Singleton Beans Thread-Safe?
No, singleton beans are not thread-safe

When multiple threads access and modify the same instance of a singleton bean concurrently, you need to take proper synchronization measures to ensure thread safety. 

 If a singleton bean's methods access shared resources or modify shared state, you should consider using synchronized blocks or other synchronization mechanisms to ensure that only one thread can access the critical section at a time.

 Utilize Java's concurrent libraries such as java.util.concurrent classes for managing concurrent access to shared resources. For example, using ConcurrentHashMap instead of a regular HashMap if your bean needs to store and manipulate data concurrently.

 ### What is concurrent HashMap and when would you use it ?
 ConcurrentHashMap is beneficial in a multi-threaded environment and performs better than HashMap. It provides thread-safety, scalability, and synchronization. For the single-threaded environment, the HashMap performs slightly better than ConcurrentHashMap.

 In HashMap, if one thread is iterating the object and the other thread will try to iterate the object, it will throw a runtime exception. But, in ConcurrentHashMap, it is possible to iterate the objects simultaneously by two or more threads.

 ### What does synchronization mean for concurrent hash map
 synchronization refers to the mechanisms used to maintain thread safety when multiple threads are accessing and modifying the map concurrently. 

 The goal of synchronization in ConcurrentHashMap is to provide a balance between performance and thread safety. Traditional synchronization methods, like using locks or synchronized blocks, can lead to contention and performance bottlenecks in multi-threaded scenarios. ConcurrentHashMap uses a variety of techniques to allow efficient concurrent operations:

 Segmented Structure: ConcurrentHashMap is divided into segments, each of which is effectively a separate hash table. This allows different threads to modify different segments concurrently, reducing contention.  

 Fine-Grained Locking: Instead of locking the entire map, ConcurrentHashMap uses fine-grained locking at the segment level. This means that only the relevant segment is locked during write operations, allowing other threads to continue working with other segments concurrently.   

 ### What is factory design pattern
 The Factory Pattern in Spring helps in achieving better separation of concerns and abstraction, allowing you to decouple the creation of objects from their usage, making your code more flexible and maintainable.

 ### When would you use an abstract class in java
 Abstract class in Java is similar to interface except that it can contain default method implementation. 
 An abstract class is mostly used to provide a base for subclasses to extend and implement the abstract methods and override or use the implemented methods in abstract class.

 Abstract class in java can’t be instantiated.  
 The subclass of abstract class in java must implement all the abstract methods unless the subclass is also an abstract class.   

 Here's an example of how you can use an abstract class in Java to create a simple hierarchy of shapes.  

 ```java
 // Abstract class representing a generic shape
abstract class Shape {
    private String color;

    public Shape(String color) {
        this.color = color;
    }

    // Abstract method to calculate the area of the shape
    public abstract double calculateArea();

    // Concrete method to get the color of the shape
    public String getColor() {
        return color;
    }
}

// Concrete subclass representing a circle
class Circle extends Shape {
    private double radius;

    public Circle(String color, double radius) {
        super(color);
        this.radius = radius;
    }

    @Override
    public double calculateArea() {
        return Math.PI * radius * radius;
    }
}

// Concrete subclass representing a rectangle
class Rectangle extends Shape {
    private double width;
    private double height;

    public Rectangle(String color, double width, double height) {
        super(color);
        this.width = width;
        this.height = height;
    }

    @Override
    public double calculateArea() {
        return width * height;
    }
}

public class Main {
    public static void main(String[] args) {
        Circle circle = new Circle("Red", 5.0);
        System.out.println("Circle Area: " + circle.calculateArea());
        System.out.println("Circle Color: " + circle.getColor());

        Rectangle rectangle = new Rectangle("Blue", 4.0, 6.0);
        System.out.println("Rectangle Area: " + rectangle.calculateArea());
        System.out.println("Rectangle Color: " + rectangle.getColor());
    }
}

 
 ```

 In this example, the Shape class is an abstract class with a constructor to set the color of the shape and an abstract method calculateArea() that is meant to be overridden by subclasses. The Circle and Rectangle classes are concrete subclasses that extend the Shape class and provide implementations for the calculateArea() method.
### JDBC

### What does Statement.setFetchSize(nSize) method really do in SQL Server JDBC driver?   
 ### What should you take care while choosing fetch size parameter in jdbc.  
In JDBC, the setFetchSize(int) method is very important to performance and memory-management within the JVM as it controls the number of network calls from the JVM to the database and correspondingly the amount of RAM used for ResultSet processing.

The RESULT-SET is the number of rows marshalled on the DB in response to the query. The ROW-SET is the chunk of rows that are fetched out of the RESULT-SET per call from the JVM to the DB. The number of these calls and resulting RAM required for processing is dependent on the fetch-size setting.

So if the RESULT-SET has 100 rows and the fetch-size is 10, there will be 10 network calls to retrieve all of the data, using roughly 10*{row-content-size} RAM at any given time.

The default fetch-size is 10, which is rather small. In the case posted, it would appear the driver is ignoring the fetch-size setting, retrieving all data in one call (large RAM requirement, optimum minimal network calls).

What happens underneath ResultSet.next() is that it doesn't actually fetch one row at a time from the RESULT-SET. It fetches that from the (local) ROW-SET and fetches the next ROW-SET (invisibly) from the server as it becomes exhausted on the local client.


 Most of the JDBC drivers’ default fetch size is 10. In normal JDBC programming if you want to retrieve 1000 rows it requires 100 network round trips between your application and database server to transfer all data. Definitely this will impact your application response time. The reason is JDBC drivers are designed to fetch small number of rows from database to avoid any out of memory issues.   

 Type of Application: Consider the nature of your application. For interactive applications, a lower fetchSize might be preferable to provide faster initial results, while for batch processing, a larger fetchSize can improve throughput.


### Is fetch size param literally executed by jdbc driver 
The fetchSize parameter is a hint to the JDBC driver as to many rows to fetch in one go from the database. But the driver is free to ignore this and do what it sees fit. Some drivers, like the Oracle one, fetch rows in chunks, so you can read very large result sets without needing lots of memory. Other drivers just read in the whole result set in one go, and I'm guessing that's what your driver is doing.



### How to get export a large amount of data (greater > 10 million) from database in csv format
Approach 1 : get rows in result set and store in list and return csv
Approach 2: return csv in streaming manner

read the result set and stream the results (based on each implementation) directly to the OutputStream using our CSVWriterWrapper.  

Json streaming out result set with object mapper.  
https://www.javacodegeeks.com/2018/09/streaming-jdbc-resultset-json.html

csv streaming out result set with printer writer
https://www.javacodegeeks.com/2018/12/java-streaming-jdbc-resultset-csv.html  


The flush() method of PrintWriter Class in Java is used to flush the stream. By flushing the stream, it means to clear the stream of any element that may be or maybe not inside the stream. 


### What is a Streaming API response
Streaming Response: The server starts sending data as soon as it's available and continues to send more data in chunks or pieces. The client receives and processes this data incrementally as it arrives. This is particularly useful when the server needs time to generate or fetch data, and it allows the client to start consuming data earlier.

Traditional Response: The server generates the entire response and sends it to the client as a single unit. The client receives the entire response before it can start processing it. This is the conventional way of serving most web pages and responses.

### Reading a json delimited file in stream 
Each line is json and seperated by newline in file.
How to to provide a streaming output by reading the file from s3
// get files in loop. 
// read a file inputStream from s3. 
lines = new BuffererReader(new InputStreamReader(inputStream,StandardCharsets.UTF8)).lines().collect(collectors.joining("\n")) 
outputStream.write(lines.getBytes())   
outputStream.write("\n")  // so that there is newline seperation in stream for the reader


### How would you provide srteaming response for spring boot
Spring Boot Rest api streaming with StreamingResponseBody is the most easiest and elegant way to create a rest web service to stream content. I generally prefer to use StreamingResponseBody with ResponseEntity, so we can set the headers and HTTP status, in this way we can control the behavior of our API in a much better way.

StreamingResponseBody type is used for async request processing and content can be written directly to the response OutputStream without holding up the threads in the servlet container.


### Junit : What is the difference between @injectmocks and @mock?

@InjectMocks creates an instance of the class and injects the mocks that are created with the @Mock annotations into this instance. @Mock is used to create mocks that are needed to support the testing of the class to be tested. 

### When should we use @SpringBootTest annotation ?
The @SpringBootTest annotation is useful when we need to bootstrap the entire container. The annotation works by creating the ApplicationContext that will be utilized in our tests

This should not be used for unit tests as this would be very slow. It should be used as integration test



 ### Have you use Spring Boot
 ### Can you do scheduling in spring boot 
 ### How does a spring boot application get started?

Just like any other Java program, a Spring Boot application must have a main method. This method serves as an entry point, which invokes the SpringApplication#run method to bootstrap the application.

### what is caching 
Caching is the mechanism of storing data in a temporary storage location, either in memory or on disc, so that request to the data can be served faster.

Caching improves performance by decreasing page load times, and reduces the load on servers and databases.

In a typical caching model, when a new client request for a resource comes in, a lookup is done on the temporary storage to see if a similar request came in earlier. 

###  How  to prevent a thread from sharing its state with other threads
use ThreadLocal.  
With ThreadLocal, you're explicitly wanting to have one value per thread that reads the variable. That's typically for the sake of context. For example, a web server with some authentication layer might set a thread-local variable early in request handling so that any code within the execution of that request can access the authentication details, without needing any explicit reference to a context object. So long as all the handling is done on the one thread, and that's the only thing that thread does, you're fine.



### What is LRU cache
A Least Recently Used (LRU) Cache organizes items in order of use, allowing you to quickly identify which item hasn't been used for the longest amount of time.

The Least Recently Used (LRU) cache is a cache eviction algorithm that organizes elements in order of use. In LRU, as the name suggests, the element that hasn't been used for the longest time will be evicted from the cache.

ALgo: LRU Cache implementation in java with 
https://www.enjoyalgorithms.com/blog/implement-least-recently-used-cache

### What is difference between get and post rest API
GET and POST are two of the most commonly used HTTP methods in RESTful APIs.
In summary, GET requests are used for retrieving data from the server and are safe and idempotent, while POST requests are used for submitting data to the server to create or modify resources and are not necessarily safe or idempotent. 


## Can the POST request has parameters ? Why do when then have request body
Here are some reasons why having a request body in the POST method is beneficial:

Data Size: The URL has a length limit, and sending large sets of data as query parameters might lead to URL truncation or other issues. With the request body, you can transmit larger datasets more reliably.

Data Complexity: When you need to send structured data like JSON or XML, it's more convenient to include it in the request body rather than encoding it in query parameters.

Security: Some data, such as passwords, should not be exposed in the URL. The request body provides a more secure way to transmit sensitive information.

## JACKSON

Reference: https://jenkov.com/tutorials/java-json/jackson-objectmapper.html


### How would you convert is Json string to a Java Object ?

Using objectMapper readValue

```java
import com.fasterxml.jackson.databind.ObjectMapper;

public class Main {
    public static void main(String[] args) throws Exception {
        String json = "{\"first_name\":\"John\",\"last_name\":\"Doe\"}";

        ObjectMapper objectMapper = new ObjectMapper();
        Person person = objectMapper.readValue(json, Person.class);

        System.out.println("First Name: " + person.getFirstName());
        System.out.println("Last Name: " + person.getLastName());
    }
}

```

### How would you convert a Java Object to Json String
objectMapper.writeValue




### What is Hazelcast
distributed In-Memory Data Grid based on Java. 
The data is always stored in-memory (RAM) of the servers.This makes it extremely fast.  

Why to use it ?

### What is elastic search

what is a index in elastic search 

### What is Mapping in elastic search

ElasticSearch mappings define how documents and their fields are indexed and stored in ElasticSearch databases or ElasticSearch DBs. This defines the types and formats of the fields that appear in the documents. As a result, mapping can have a significant impact on how Elasticsearch searches for and stores data. After creating an index, we must define the mapping. An incorrect preliminary definition and mapping might lead to incorrect search results.


### What is Apache Kafka
Kafka is a messaging system built for high throughput and fault tolerance.  

A Topic is a category or feed in which records are saved and published.

A Kafka broker is a server that works as part of a Kafka cluster (in other words, a Kafka cluster is made up of a number of brokers). Multiple brokers typically work together to build a Kafka cluster, which provides load balancing, reliable redundancy, and failover. The cluster is managed and coordinated by brokers using Apache ZooKeeper. Without sacrificing performance, each broker instance can handle read and write volumes of hundreds of thousands per second (and gigabytes of messages). Each broker has its own ID and can be in charge of one or more topic log divisions.

### What do you mean by a Partition in Kafka? 

Kafka topics are separated into partitions, each of which contains records in a fixed order. A unique offset is assigned and attributed to each record in a partition. Multiple partition logs can be found in a single topic. This allows several users to read from the same topic at the same time. Topics can be parallelized via partitions, which split data into a single topic among numerous brokers.



