
PySpark requires py4j on the driver machine. PY4J starts the JVM process which creates the spark session. If any of the data operation on the nodes require custom python code execution, then the RDD and python code is serialized/pickled and piped to a new python process created to execute this work.

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
exec "${SPARK_HOME}"/bin/spark-class org.apache.spark.deploy.SparkSubmit "$@"
```

2) 
