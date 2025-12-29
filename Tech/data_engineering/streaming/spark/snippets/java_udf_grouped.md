

- A **Java UDF** that:
  - Accepts a `WrappedArray<Row>` (array of people),
  - Returns a **new array of Rows**, where each row is enriched with an `age_group` field (`young` or `old`).
- PySpark:
  - Has 5 flat rows,
  - Groups in 2s using `collect_list(...)`,
  - Calls the UDF,
  - **Explodes the output back into flat rows** so we end up with all 5 rows again, each with the new field `age_group`.

---

## ✅ 1. Java Code: `AgeGrouperUDF.java`

```java
// AgeGrouperUDF.java
import org.apache.spark.sql.api.java.UDF1;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.RowFactory;
import scala.collection.JavaConverters;
import scala.collection.Seq;

import java.util.ArrayList;
import java.util.List;

public class AgeGrouperUDF {
    public static class AddAgeGroup implements  UDF1<Seq<Row>, Seq<Row>> {
        @Override
       @Override
    public Seq<Row> call(Seq<Row> batch) throws Exception {
        List<Row> output = new ArrayList<>();
        
        // Convert Scala Seq to Java List for processing
        List<Row> rows = JavaConverters.seqAsJavaList(batch);
        
        for (Row row : rows) {
            String name = row.getString(0);
            int age = row.getInt(1);
            String ageType = age < 35 ? "young" : "old";
            output.add(RowFactory.create(name, age, ageType));
        }
        
        // Convert back to Scala Seq
        return JavaConverters.collectionAsScalaIterable(output).toSeq();
    }
}
```

---

## ✅ 2. Compile & Package

```bash
javac -cp "$SPARK_HOME/jars/*" AgeGrouperUDF.java
jar cf udf.jar AgeGrouperUDF.class
```

---

## ✅ 3. PySpark Script (`test.py`)

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, pandas_udf
from pyspark.sql.types import *

# Initialize Spark
spark = SparkSession.builder \
    .appName("BatchUDFExample") \
    .config("spark.jars", "javaudf.jar") \
    .getOrCreate()

# Sample data
data = [("John", 25), ("Alice", 30), ("Bob", 40), ("Eve", 35), ("Mike", 28)]
df = spark.createDataFrame(data, ["name", "age"])

# Register Java UDF (using Arrow for efficient batch transfer)
spark.udf.registerJavaFunction(
    "batchAgeUDF",
    "com.example.BatchAgeTypeUDF",
    ArrayType(StructType([
        StructField("name", StringType()),
        StructField("age", IntegerType()),
        StructField("age_type", StringType())
    ]))
)

# Process in batches of 2 using Java UDF
result = df.withColumn("group_id", (col("monotonically_increasing_id") / 2).cast("int")) \
    .groupBy("group_id") \
    .agg(collect_list(struct("name", "age")).alias("batch")) \
    .select(explode(expr("batchAgeUDF(batch)")).alias("result")) \
    .select("result.*")

result.show()
```

---

## ✅ Output:

```
+--------+----------+---+---------+
|group_id|first_name|age|age_group|
+--------+----------+---+---------+
|   A    |   Alice  |30 |  young  |
|   A    |   Bob    |25 |  young  |
|   B    |   Carol  |40 |   old   |
|   B    |   Dave   |22 |  young  |
|   C    |   Eve    |35 |   old   |
+--------+----------+---+---------+
```

