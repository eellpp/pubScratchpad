https://spring.io/blog/2017/04/20/spring-cloud-data-flow-1-2-rc1-released

### Video Tutorial
https://www.youtube.com/watch?v=KT_4kVcyfRA

## Composed Task Runner

https://docs.spring.io/spring-cloud-dataflow/docs/current/reference/html/spring-cloud-dataflow-composed-tasks.html

https://docs.spring.io/spring-cloud-dataflow/docs/current/reference/html/_composed_tasks_dsl.html

https://github.com/spring-cloud-task-app-starters/composed-task-runner/blob/master/spring-cloud-starter-task-composedtaskrunner/README.adoc

A composed task within Spring Cloud Data Flow is actually built on Spring Batch in that the transition from task to task is managed by a dynamically generated Spring Batch job. This model allows the decomposition of a batch job into reusable parts that can be independently tested, deployed, and orchestrated at a level higher than a job.

You can use a composed task within Spring Cloud Data Flow to orchestrate both Spring Cloud Tasks as well as Spring Batch jobs (run as tasks). It really depends on how you want to slice up your process. If you have processes that are tightly coupled, package them as a single job. From there, you can orchestrate them with Spring Cloud Data Flow's composed task functionality.

