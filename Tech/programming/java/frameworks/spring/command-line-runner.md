
### Command Line Runner vs Application Runner

Spring Boot provides two interfaces, CommandLineRunner and ApplicationRunner, to run specific pieces of code when an application is fully started. These interfaces get called just before run() once SpringApplication completes.

### CommandLineRunner
This interface provides access to application arguments as string array. Let's see the example code for more clarity.
```java
@Component
public class CommandLineAppStartupRunner implements CommandLineRunner {
    private static final Logger logger = LoggerFactory.getLogger(CommandLineAppStartupRunner.class);
    @Override
    public void run(String...args) throws Exception {
        logger.info("Application started with command-line arguments: {} . \n To kill this application, press Ctrl + C.", Arrays.toString(args));
    }
}
```

### ApplicationRunner
ApplicationRunner wraps the raw application arguments and exposes the ApplicationArguments interface, which has many convinent methods to get arguments, like getOptionNames() to return all the arguments' names, getOptionValues() to return the agrument value, and raw source arguments with method getSourceArgs(). Let's see an example:

```java
@Component
public class AppStartupRunner implements ApplicationRunner {
    private static final Logger logger = LoggerFactory.getLogger(AppStartupRunner.class);
    @Override
    public void run(ApplicationArguments args) throws Exception {
        logger.info("Your application started with option names : {}", args.getOptionNames());
    }
}
```
### When to Use It
When you want to execute some piece of code exactly before the application startup completes, you can use it then. In one of our projects, we used these to source data from other microservices via service discovery, which was registered in Consul.

### Ordering
You can register as many application/command line runners as you want. You just need to register them as Beans in the application context. Then, Spring will automatically pick them up. You can order them as well either by extending interface org.springframework.core.Ordered or via the @Order annotation.
