Thinking data ingestion as seperate from data processing simplifies reasoning about failures when they happen. Often when the same tool is doing ingestion and processing, the failures become complex to predict and analyse.

Primary principal in data ingestion is to not loose the data and data integrity

Secondary are:
- ability to replay data
- capturing events during data ingestion 
-- CPU, Storage, Network IO

### Real time data ingestion

### Batch data ingestion

### Continuous and one time data ingestion

### Tools for data ingestion
web services
sftp
hdfs vs s3 vs gcloud
kafka , redis


### Fault tolerance in data ingestion
What happens when your primary data ingestion strategy fails. Would there be data loss ?

### Should processing be done at data ingestion

### Recording data as fact and pipeline as replayable transformation on the pipeline
