

## Confluent - deep dive into Apache Kafka
https://www.youtube.com/watch?v=hplobfWsY2E

## Things We Wish We Knew Before Operationalising Kafka 
https://www.youtube.com/watch?v=MhyW1FUdN8I

## Lessons learned form Kafka in production 
https://www.youtube.com/watch?v=1vLMuWsfMcA


## Different ways to subscribe to kafka messages
In Apache Kafka, there are different ways to consume or subscribe to messages depending on your requirements and the Kafka client library you are using. Here are the common approaches to subscribing to messages in Kafka:

#### Simple Consumer
`Simple Consumer`: The simple consumer API allows you to directly interact with Kafka partitions and consume messages. You can manually manage the offset and read messages from specific partitions. However, this API is relatively low-level and requires more manual effort in handling various aspects such as load balancing, partition management, and fault tolerance.  

```java
import kafka.api.FetchRequest;
import kafka.api.FetchRequestBuilder;
import kafka.javaapi.consumer.SimpleConsumer;
import kafka.javaapi.message.ByteBufferMessageSet;
import kafka.message.MessageAndOffset;

public class SimpleConsumerExample {
    public static void main(String[] args) {
        String topic = "my-topic";
        int partition = 0;
        String kafkaServer = "localhost";
        int kafkaPort = 9092;
        long offset = 0;

        SimpleConsumer consumer = new SimpleConsumer(kafkaServer, kafkaPort, 10000, 1024 * 64, "consumerGroup");
        FetchRequest fetchRequest = new FetchRequestBuilder()
                .clientId("simpleConsumerClient")
                .addFetch(topic, partition, offset, 100)
                .build();
        ByteBufferMessageSet messageSet = consumer.fetch(fetchRequest);
        
        for (MessageAndOffset messageAndOffset : messageSet) {
            String message = new String(messageAndOffset.message().payload().array());
            System.out.println("Received message: " + message);
        }
        
        consumer.close();
    }
}

```
#### High Level Consumer
`High-Level Consumer`: The high-level consumer API, which has been deprecated in recent versions, provided a more abstracted and easier-to-use interface for consuming messages. It handled partition assignment, offset management, and other complexities internally. However, it has been replaced by the new consumer API (introduced in Kafka 0.9) and is not recommended for new projects.  

```java
import kafka.consumer.Consumer;
import kafka.consumer.ConsumerConfig;
import kafka.consumer.ConsumerIterator;
import kafka.consumer.KafkaStream;
import kafka.javaapi.consumer.ConsumerConnector;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class HighLevelConsumerExample {
    public static void main(String[] args) {
        String topic = "my-topic";
        String zookeeperConnect = "localhost:2181";
        String groupId = "highLevelConsumerGroup";

        Properties props = new Properties();
        props.put("zookeeper.connect", zookeeperConnect);
        props.put("group.id", groupId);
        ConsumerConnector consumer = Consumer.createJavaConsumerConnector(new ConsumerConfig(props));
        
        Map<String, Integer> topicCountMap = new HashMap<>();
        topicCountMap.put(topic, 1);
        
        Map<String, List<KafkaStream<byte[], byte[]>>> consumerMap = consumer.createMessageStreams(topicCountMap);
        KafkaStream<byte[], byte[]> stream = consumerMap.get(topic).get(0);
        ConsumerIterator<byte[], byte[]> iterator = stream.iterator();
        
        while (iterator.hasNext()) {
            String message = new String(iterator.next().message());
            System.out.println("Received message: " + message);
        }
        
        consumer.shutdown();
    }
}

```
#### Consumer Groups
`Consumer Groups`: The new consumer API introduced in Kafka 0.9 introduced the concept of consumer groups. A consumer group is a group of consumers that work together to consume messages from Kafka topics. Each consumer within a group is assigned a subset of partitions to consume from. This approach allows for parallel consumption and load balancing across multiple consumers within a group. The consumer group coordinates automatically manage partition assignment, rebalancing, and offset management.  
```java
import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.serialization.StringDeserializer;

import java.time.Duration;
import java.util.Collections;
import java.util.Properties;

public class ConsumerGroupExample {
    public static void main(String[] args) {
        String topic = "my-topic";
        String bootstrapServers = "localhost:9092";
        String groupId = "consumerGroup";

        Properties props = new Properties();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ConsumerConfig.GROUP_ID_CONFIG, groupId);
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());

        Consumer<String, String> consumer = new KafkaConsumer<>(props);
        consumer.subscribe(Collections.singletonList(topic));

        while (true) {
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));
            records.forEach(record -> {
                System.out.println("Received message: key = " + record.key() + ", value = " + record.value());
            });
        }
    }
}
```

Here are some key points to consider regarding consumer groups and real-time streaming:

`Parallel Processing`: With consumer groups, you can have multiple consumers within a group, each assigned to one or more partitions of a topic. This enables parallel processing of messages, where each consumer can independently process its assigned partitions concurrently. This parallelism allows for high throughput and faster processing of messages, which is crucial for real-time streaming.  

`Load Balancing`: Kafka's consumer group mechanism automatically distributes partitions across consumers within a group based on a partition assignment strategy (e.g., round-robin or range-based). This load balancing ensures that messages are evenly distributed across consumers, optimizing resource utilization and ensuring efficient processing.  

`Offset Management`: Consumer groups also handle offset management, which is crucial for real-time streaming. Offsets represent the position of a consumer within a partition, indicating which messages have been consumed. Kafka's consumer group mechanism automatically tracks and manages offsets, ensuring that each consumer continues from where it left off during restarts or failures. This guarantees that real-time streaming applications can resume processing without missing any messages.  

`Dynamic Scaling`: Consumer groups support dynamic scaling of consumers. You can add or remove consumers from a group without interrupting the streaming process. This flexibility allows you to scale your real-time streaming application based on demand or to adapt to changing workloads.  

#### Kafka Streams
`Kafka Streams`: Kafka Streams is a high-level library built on top of the Kafka consumer and producer APIs. It provides a more functional and declarative approach to processing and transforming Kafka data streams. With Kafka Streams, you define processing logic as a stream processing topology, which allows you to consume, transform, and produce messages easily. Kafka Streams handles much of the underlying complexity, including managing offsets, state storage, and fault tolerance.  
```java
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.StreamsConfig;
import org.apache.kafka.streams.kstream.KStream;

import java.util.Properties;

public class KafkaStreamsExample {
    public static void main(String[] args) {
        Properties props = new Properties();
        props.put(StreamsConfig.APPLICATION_ID_CONFIG, "kafkaStreamsExample");
        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");

        StreamsBuilder builder = new StreamsBuilder();
        KStream<String, String> input = builder.stream("my-input-topic");
        input.foreach((key, value) -> System.out.println("Received message: " + value));

        KafkaStreams streams = new KafkaStreams(builder.build(), props);
        streams.start();

        Runtime.getRuntime().addShutdownHook(new Thread(streams::close));
    }
}

```

`Kafka Connect`: Kafka Connect is a framework that enables easy integration of Kafka with external systems, such as databases, file systems, and other messaging systems. Kafka Connect provides connectors for various data sources and sinks, allowing you to subscribe to messages from external systems and publish them to Kafka topics. It simplifies the process of subscribing to and consuming data from external systems and can be used to build real-time data pipelines.

Kafka Connect examples involve configuring connectors for specific use cases. Here's a simple example for reading from a file and publishing to a Kafka topic using th Kafka Connect File Source connector:  


```bash
#Create a configuration file connect-file-source.properties:
name=file-source. 
connector.class=FileStreamSource. 
tasks.max=1. 
file=test.txt. 
topic=my-topic. 

# Start Kafka Connect with the configuration:
bin/connect-standalone.sh config/connect-standalone.properties connect-file-source.properties

```

The choice of subscription method depends on the specific requirements and characteristics of your application. The new consumer API with consumer groups is the recommended approach for most use cases, as it provides a balance of simplicity, scalability, and fault tolerance. Kafka Streams and Kafka Connect are suitable for scenarios where you need more advanced stream processing or integration capabilities.
```java

```



### Is key required in sending messages in kafka
In Apache Kafka, both keys and values are optional when sending messages to a Kafka topic. You have the flexibility to send messages with or without keys, depending on your use case and requirements.

When sending a message, each record consists of a key and a value. The key and value can be of any type, including primitive types, custom objects, or even null.

The key is used to determine the partition to which the message will be assigned within the Kafka topic. Kafka uses a partitioning algorithm to map each message to a specific partition based on its key. If the key is null, the message will be assigned to a random partition.

Here's an example of sending a message with a key and value using the Kafka Producer API in Java: 

```java
import org.apache.kafka.clients.producer.*;

public class KafkaProducerExample {
    public static void main(String[] args) {
        Properties properties = new Properties();
        properties.put("bootstrap.servers", "localhost:9092");
        properties.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        properties.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

        Producer<String, String> producer = new KafkaProducer<>(properties);

        String key = "myKey";
        String value = "Hello Kafka!";

        ProducerRecord<String, String> record = new ProducerRecord<>("myTopic", key, value);

        producer.send(record, new Callback() {
            @Override
            public void onCompletion(RecordMetadata metadata, Exception exception) {
                if (exception != null) {
                    System.out.println("Failed to send message: " + exception.getMessage());
                } else {
                    System.out.println("Message sent successfully! Offset: " + metadata.offset());
                }
            }
        });

        producer.close();
    }
}
```

In this example, the ProducerRecord is created with a specified topic, key, and value. The producer then sends the record to Kafka using the send method. The key and value can be any string value or object representation depending on your application's needs.

Remember that while the key is optional, using keys can provide benefits such as message ordering and the ability to perform partition-specific processing or aggregation. However, if you don't have a meaningful key for your messages, you can still send them without a key, and Kafka will assign them to partitions randomly.




