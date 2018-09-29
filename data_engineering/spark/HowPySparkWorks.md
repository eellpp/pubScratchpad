
PySpark requires py4j on the driver machine. PY4J starts the JVM process which creates the spark session. If any of the data operation on the nodes require custom python code execution, then the RDD and python code is serialized/pickled and piped to a new python process created to execute this work.\
Note that py4J is used on only the spark driver. The executors don't use py4j. Instead they use unix pipes to communicate\

PySpark relies on Py4J to execute Python code that can call objects that reside in the JVM. To do that, Py4J uses a gateway server to communicate between the JVM and the Python interpreter, and PySpark sets it up for you.\
From the pyspark python driver code we can access code in jvm by 
```bash
sc._jvm.com.myJavaModule.hello()
 ```
 The jar file of the dependency should be added to classpath

Questions
1. On spark submit how the python env is setup\
2. Where is python kickstarting py4J jvm process\
3. How are java rdd and python files piped to python processes on nodes

### Submitting Spark Job
The spark-submit script in Spark's bin directory is used to launch applications on a cluster. \
For java/scala create a uber jar with code and all its dependencies.  Mark Hadoop and Spark as provided dependencies as these are provided by cluster manager at run time\
use the --py-files argument of spark-submit to add .py, .zip or .egg files to be distributed with your application. If you depend on multiple Python files we recommend packaging them into a .zip or .egg.

1) Execute the spark-submit shell script\
This internally calls:
```bash
#path :spark/bin/spark-submit
exec "${SPARK_HOME}"/bin/spark-class org.apache.spark.deploy.SparkSubmit "$@"
```

2) 
spark/core/src/main/scala/org/apache/spark/deploy/SparkSubmit.scala

args.isPython property is used to check if its a python application\
python runner used : 
```bash
args.mainClass = "org.apache.spark.deploy.PythonRunner"
```

3)
spark/core/src/main/scala/org/apache/spark/deploy/PythonRunner.scala

Here all the pythong env variables are setup
```bash
val pythonExec = sparkConf.get(PYSPARK_DRIVER_PYTHON)
      .orElse(sparkConf.get(PYSPARK_PYTHON))
      .orElse(sys.env.get("PYSPARK_DRIVER_PYTHON"))
      .orElse(sys.env.get("PYSPARK_PYTHON"))
      .getOrElse("python")
```

// Launch a Py4J gateway server for the process to connect to;
Py4J gatway server allows the python process to connect to JVM over a socket.

```bash
val gatewayServer = new py4j.GatewayServer.GatewayServerBuilder()
      .authToken(secret)
      .javaPort(0)
      .javaAddress(localhost)
      .callbackClient(py4j.GatewayServer.DEFAULT_PYTHON_PORT, localhost, secret)
      .build()
    val thread = new Thread(new Runnable() {
      override def run(): Unit = Utils.logUncaughtExceptions {
        gatewayServer.start()
      }
    })
    thread.setName("py4j-gateway-init")
    thread.setDaemon(true)
    thread.start()
 ```
 
 Once the gateway server is started and ready to serve connections, the python process is lauched with socket address etc
 
 ```bash
 val builder = new ProcessBuilder((Seq(pythonExec, formattedPythonFile) ++ otherArgs).asJava)
    val env = builder.environment()
    env.put("PYTHONPATH", pythonPath)
    // This is equivalent to setting the -u flag; we use it because ipython doesn't support -u:
    env.put("PYTHONUNBUFFERED", "YES") // value is needed to be set to a non-empty string
    env.put("PYSPARK_GATEWAY_PORT", "" + gatewayServer.getListeningPort)
    env.put("PYSPARK_GATEWAY_SECRET", secret)
    // pass conf spark.pyspark.python to python process, the only way to pass info to
    // python process is through environment variable.
    sparkConf.get(PYSPARK_PYTHON).foreach(env.put("PYSPARK_PYTHON", _))
    sys.env.get("PYTHONHASHSEED").foreach(env.put("PYTHONHASHSEED", _))
    builder.redirectErrorStream(true) // Ugly but needed for stdout and stderr to synchronize
    try {
      val process = builder.start()

 ```
 


