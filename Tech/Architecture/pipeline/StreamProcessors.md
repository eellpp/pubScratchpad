### stream processors

https://www.oreilly.com/library/view/stream-processing-with/9781491974285/ch01.html

Instead of running analytical queries directly on the transactional databases, the data is typically replicated to a data warehouse, a dedicated datastore for analytical query workloads.  

An ETL process extracts data from a transactional database, transforms it into a common representation that might include validation, value normalization, encoding, deduplication, and schema transformation, and finally loads it into the analytical database.

Once the data has been imported into the data warehouse it can be queried and analyzed. Typically, there are two classes of queries executed on a data warehouse. 

1. `Standard Queries`: The first type are periodic report queries that compute business-relevant statistics such as revenue, user growth, or production output. These metrics are assembled into reports that help the management to assess the businessâs overall health. 

2. `Adhoc Queries`: The second type are ad-hoc queries that aim to provide answers to specific questions and support business-critical decisions, for example a query to collect revenue numbers and spending on radio commercials to evaluate the effectiveness of a marketing campaign. 

### Stateful Stream Processing
Stateful stream processing is a type of computing that involves processing a continuous stream of data in real-time, while also maintaining a current state or context based on the data that has been processed so far. This allows the system to track changes and patterns in the data stream over time, and to make decisions or take actions based on this information.

An example is a financial trading system that processes real-time market data and uses past market trends and patterns to make informed trading decisions. The system maintains a state based on past market data, and updates this state as new data becomes available, in order to make decisions about when to buy or sell securities.

Step 1: Set up a data source that continuously streams data about the user’s interactions with the streaming service.

Step2: A stream processor that continuously processes this data stream in real-time, extracting relevant information and updating the state of the system 

To store and maintain the current state of the system (Context), you might use a state store that is implemented using a distributed database or in-memory data structure. This state store would keep track of the user’s past interactions with the streaming service, and update this information as new data becomes available.

Stateful processing allows a system or program to maintain a current state or context based on past input or interactions, which can provide important contextual information that can be used to inform current and future actions

Stateful processing can be more challenging to scale compared to stateless processing, as it requires the ability to store and manage a current state for each individual entity being processed. This can be particularly challenging in situations where there are a large number of entities or a high volume of data being processed.

### Examples of streaming frameworks
Apache Flink :  It works on the Kappa architecture that has a single processor for the stream of input.

Apache Storm : Storm uses a primary/worker architecture. The primary node is called Nimbus, and the worker nodes are called supervisors. For coordination, the architecture uses ZooKeeper.

Apache Samza : Samza stores data in a local state on the same machine as the stream task. Its architecture has three layers, namely the streaming layer (Kafka), the execution layer (YARN), and the processing layer (Samza API). 
Applications that have exactly-once delivery guarantee requirements.



