Spring TaskScheduler Interface can be used for scheduling task as regular interval
 
The ThreadPoolTaskScheduler is a good default choice.   
options: 
- Pool size: The number of threads in the thread pool
- Thread name prefix: A prefix for thread names, useful for debugging
- Wait for tasks to complete on shutdown: A flag to indicate whether the scheduler should wait for scheduled tasks to complete before shutting down


```java
@Configuration
public class SchedulerConfig {
    @Bean
    public TaskScheduler taskScheduler() {
        ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
        scheduler.setPoolSize(5);
        scheduler.setThreadNamePrefix("MyTaskScheduler-");
        scheduler.setWaitForTasksToCompleteOnShutdown(true);
        return scheduler;
    }
}
```

```java
@Component
public class ProgrammaticallyScheduledTasks {
    private final TaskScheduler taskScheduler;
    private static final Logger logger = LoggerFactory.getLogger(ProgrammaticallyScheduledTasks.class);

    @Autowired
    public ProgrammaticallyScheduledTasks(TaskScheduler taskScheduler) {
        this.taskScheduler = taskScheduler;
        scheduleTask();
    }

    public void scheduleTask() {
        CronTrigger cronTrigger  = new CronTrigger("10 * * * * ?");
        taskScheduler.schedule(new RunnableTask("Cron Trigger"), cronTrigger);
    }
}
```
Scheduled tasks should handle exceptions gracefully to avoid disrupting other tasks. You can use a try-catch block to catch exceptions within the scheduled task:  


The default configuration is a core pool size of 1, with unlimited max pool size and unlimited queue capacity. This is roughly equivalent to Executors.newSingleThreadExecutor(), sharing a single thread for all tasks. 

Methods supported by TaskScheduler

```java
public interface TaskScheduler {

    ScheduledFuture schedule(Runnable task, Trigger trigger);

    ScheduledFuture schedule(Runnable task, Date startTime);

    ScheduledFuture scheduleAtFixedRate(Runnable task, Date startTime, long period);

    ScheduledFuture scheduleAtFixedRate(Runnable task, long period);

    ScheduledFuture scheduleWithFixedDelay(Runnable task, Date startTime, long delay);

    ScheduledFuture scheduleWithFixedDelay(Runnable task, long delay);

}

```


### References
[Title](https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/scheduling.html)