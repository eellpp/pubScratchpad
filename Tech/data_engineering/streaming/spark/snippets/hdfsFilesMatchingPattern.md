```python
from pyspark.sql import SparkSession
import re

# Initialize Spark Session
spark = SparkSession.builder.appName("FileContentPatternSearch").getOrCreate()

# Define the pattern
pattern = r"your_pattern_here"

# List Files in HDFS Directory
hdfs_directory = "hdfs://your_hdfs_directory_here"
file_paths = spark._jvm.org.apache.hadoop.fs.FileSystem.get(spark._jsc.hadoopConfiguration()).listFiles(spark._jvm.org.apache.hadoop.fs.Path(hdfs_directory), True)

# Filter Files with Matching Content
matching_files = []
for file in file_paths:
    file_path = file.getPath().toString()
    lines = spark.read.text(file_path).rdd.map(lambda r: r[0])
    if lines.filter(lambda line: re.search(pattern, line)).count() > 0:
        matching_files.append(file_path)

# Print Matching File Names
for file_path in matching_files:
    print(file_path)

# Stop Spark Session
spark.stop()

```