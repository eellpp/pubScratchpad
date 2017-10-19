
https://github.com/PacktPublishing/Mastering-Spring-5.0/tree/master/Chapter10
use Spring Initializr (https://start.spring.io) to set up the application. 


Building on top of other Spring Projects, such as Spring Cloud Stream, Spring Integration, and Spring Boot, Spring Data Flow makes it easy to define and scale use cases involving data and event flows using message-based integration.

#### Source, Processor,Sink
The source application generates the event. The processor application processes the event and generates another message that will be processed by the sink application

## Spring Integration
Spring Integration helps integrate microservices seamlessly over a message broker.
https://projects.spring.io/spring-integration/

Spring Cloud Stream and Spring Cloud Data Flow extend the features provided by Spring Integration 
- make them available on the Cloud, create new instances of microservice cloud instances 
- automatically integrate with message brokers and 
- scale our microservice cloud instances automatically without manual configuration


## Spring CloudStream
Spring Cloud Stream is the framework to build message-driven microservices for the Cloud. It provides
- Message broker configuration and channel creation
- Message-broker-specific conversions for message
- Creating binders to connect to the message broker

 Spring Cloud Stream provides three simple kinds of applications to support typical stream flows:
 - Source: A source would only have an input channel
 - Processor : the processor would have both the input and output channel
 - Sink : sink would have only an output channel
 
 Terminology
 
 - source | processor | Sink
 - input channels, output channels
 - *binders* : 
 
 Binders bring configurability to Spring Cloud Stream applications. A String Cloud Stream application only declares the channels. Deployment team can configure, at runtime, which message broker (Kafka or RabbitMQ) the channels connect to. Spring Cloud Stream uses auto-configuration to detect the binder available on the classpath. To connect to a different message broker, all that we need to do is change the dependency for the project. Another option is to include multiple binders in the classpath and choose the one to use at runtime.
 
 - Message Brokers : Support for a variety of message brokers--RabbitMQ, Kafka, Redis, and GemFire
 
 > Spring Cloud Stream is used to create individual microservices in the data flow. Spring Cloud Stream microservices define business logic and the connection points, the inputs and/or outputs. Spring Cloud Data Flow helps in defining the flow, that is, connecting different applications.
 
 Create microservices with Spring Cloud Data Stream. These microservices are then used to create a flow using Spring Cloud Data Flow
 All the microservices that are deployed through the Spring Cloud Data Flow server should be Spring Boot microservices that define appropriate channels.
 
 Spring Cloud Data Flow provides interfaces to define applications and define flows between them using Spring DSL. Spring Data Flow Server understands the DSL and establishes the flow between applications.
 
 
 
 Spring Cloud Stream is built on
 - Spring Boot
 - Spring Integration

Features: 

- Bare minimum configuration to connect a microservice to a message broker.
- Support for persistence of messages--in case a service is down, it can start processing the messages once it is back up.
- Support for consumer groups--in cases of heavy loads, you need multiple instances of the same microservice. You can group all these microservice instances under a single consumer group so that the message is picked up only by one of the available instances.
- Support for partitioning--there can be situations where you would want to ensure that a specific set of messages are addressed by the same instance. Partitioning allows you to configure the criteria to identify messages to be handled by the same partition instance.
 
 
 
 @EnableBinding(Source.class): The EnableBinding annotation enables binding a class with the respective channel it needs--an input and/or an output. The source class is used to register a Cloud Stream with one output channel.
 
 @EnableBinding(Processor.class): The EnableBinding annotation enables binding a class with the respective channel it needs--an input and/or an output. The Processor class is used to register a Cloud Stream with one input channel and one output channel.
 
 @EnableBinding(Sink.class): The EnableBinding annotation enables binding a class with the respective channel it needs--an input and/or an output. The Sink class is used to register a Cloud Stream with one input channel.
 
 - The Source interface defines an output channel
 - Processor class extends the Source and Sink classes. Hence, it defines both the output and input channels
 
 The @InboundChannelAdapter annotation is used to indicate that this method can create a message to be put on a message broker. The value attribute is used to indicate the name of the channel where the message is to be put.
 
 @Transformer(inputChannel = Processor.INPUT, outputChannel = Processor.OUTPUT): The Transformer annotation is used to indicate a method that is capable of transforming/enhancing one message format into another.
 
 @StreamListener(Sink.INPUT): The StreamListener annotation is used to listen on a channel for incoming messages. In this example, StreamListener is configured to listen on the default input channel.

@EnableDataFlowServer annotation is used to activate a Spring Cloud Data Flow Server implementation.
The @EnableDataFlowShell annotation is used to activate the Spring Cloud Data Flow shell.


 ## Spring DataFlow
  deployment manifest  and Spring DSL 
 - Uses a mapping between the application name and the deployable unit of the application to download the application artifacts from repositories. Spring Data Flow Server supports Maven and Docker repositories.
- Deploy the applications to the target runtime. (Yarn, Mesos,Kubernates,Local Server)
- Creat channels on the message broker.
- Establish connections between the applications and the message broker channels.

### Steps in setting Spring cloud Data Flow
- Setting up Spring Cloud Data Flow server.
- Setting up the Data Flow Shell project.
- Configuring the apps.
- Configuring the stream.
- Running the stream.
 
 Before you run the Local Data Flow Server, ensure that the message broker RabbitMQ is up and running.
 http://localhost:9393/dashboard
 
 Spring Cloud Data Flow Server uses an internal schema to store all the configuration of applications, tasks, and streams. In this example, we have not configured any database. So, by default, the H2 in-memory database is used. Spring Cloud Data Flow Server supports a variety of databases, including MySQL and Oracle, to store the configuration.
 
 The Data Flow Shell or the Dashboard UI can be used to set up applications and streams.
 
 Spring Cloud Data Flow gives the option of picking up the application deployable from a Maven repository. 
 Run mvn clean install on all the three applications that we created using Spring Cloud Stream to install them into the local repository
 
 The syntax of the command to register an app from a Maven repository is shown here:
app register —-name {{NAME_THAT_YOU_WANT_TO_GIVE_TO_APP}} --type source --uri maven://{{GROUP_ID}}:{{ARTIFACT_ID}}:jar:{{VERSION}}


The Maven URIs for the three applications are listed as follows:

maven://com.mastering.spring.cloud.data.flow:significant-stock-change-source:jar:0.0.1-SNAPSHOT
maven://com.mastering.spring.cloud.data.flow:stock-intelligence-processor:jar:0.0.1-SNAPSHOT
maven://com.mastering.spring.cloud.data.flow:event-store-sink:jar:0.0.1-SNAPSHOT

The commands to create the apps are listed here. These commands can be executed on the Data Flow Shell application:

app register --name significant-stock-change-source --type source --uri maven://com.mastering.spring.cloud.data.flow:significant-stock-change-source:jar:0.0.1-SNAPSHOT
app register --name stock-intelligence-processor --type processor --uri maven://com.mastering.spring.cloud.data.flow:stock-intelligence-processor:jar:0.0.1-SNAPSHOT
app register --name event-store-sink --type sink --uri maven://com.mastering.spring.cloud.data.flow:event-store-sink:jar:0.0.1-SNAPSHOT

## Stream DSL to  connect
significant-stock-change-source|stock-intelligence-processor|event-store-sink

The entire command to create a stream is shown as follows:

stream create --name process-stock-change-events --definition significant-stock-change-source|stock-intelligence-processor|event-store-sink

To deploy the stream, we can execute the following command on the Data Flow Shell:

stream deploy --name process-stock-change-events

When we deploy a stream, Spring Cloud Data Flow will deploy all the applications in the stream and set up the connections between the applications through the message broker. 

### Registering Spring cloud task
The @EnableTask annotation enables the task features in a Spring Boot application.

We can register the task on the data flow shell using the following commands:

app register --name simple-logging-task --type task --uri maven://com.mastering.spring.cloud.data.flow:simple-logging-task:jar:0.0.1-SNAPSHOT
task create --name simple-logging-task-definition --definition "simple-logging-task"

The task can be launched using the following command:

task launch simple-logging-task-definition




