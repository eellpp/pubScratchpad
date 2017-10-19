
## Running
#### Download and run zookeeper
```bash
zookeeper-3.4.10]$./bin/zkServer.sh start
```

#### Download and run Kafka
```bash

```

#### Download and run DataFlow Server
#### Download and run DataFlow Shell


## Examples

#### Monitor files in a folder and copy it to another destination
```bash
stream create --name filetest --definition "sourcefile: file --file.directory=<path>/testStream | sinkfile: file --file.directory=<path>/testOutputStream" --deploy
```
This will append the contents of all the files in source folder to single file in destination folder

*Note the label. Since the same app is mentioned multiple times in the stream it needs to be qualified with a label. This is the requirment from the DSL*
