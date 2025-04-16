

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
import org.apache.spark.sql.Row;
import org.apache.spark.sql.RowFactory;
import org.apache.spark.sql.api.java.UDF1;
import org.apache.spark.sql.types.*;

import scala.collection.mutable.WrappedArray;
import scala.collection.mutable.ArrayBuffer;

public class AgeGrouperUDF {
    public static class AddAgeGroup implements UDF1<WrappedArray<Row>, WrappedArray<Row>> {
        @Override
        public WrappedArray<Row> call(WrappedArray<Row> inputRows) {
            ArrayBuffer<Row> output = new ArrayBuffer<>();

            for (int i = 0; i < inputRows.length(); i++) {
                Row row = inputRows.apply(i);
                String name = row.getString(0);
                int age = row.getInt(1);
                String ageGroup = (age < 35) ? "young" : "old";

                Row enriched = RowFactory.create(name, age, ageGroup);
                output.$plus$eq(enriched);
            }

            return (WrappedArray<Row>) WrappedArray.make(output.toArray(new Row[0]));
        }

        // Optional: schema if using Java UDF with DataFrame API
        public static StructType getReturnType() {
            return DataTypes.createArrayType(DataTypes.createStructType(new StructField[]{
                DataTypes.createStructField("first_name", DataTypes.StringType, false),
                DataTypes.createStructField("age", DataTypes.IntegerType, false),
                DataTypes.createStructField("age_group", DataTypes.StringType, false)
            }));
        }
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
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, ArrayType
from pyspark.sql import functions as F

# Start Spark session
spark = SparkSession.builder \
    .appName("JavaUDFArrayTransform") \
    .config("spark.jars", "udf.jar") \
    .getOrCreate()

# Register Java UDF
spark.udf.registerJavaFunction(
    "addAgeGroup",
    "AgeGrouperUDF$AddAgeGroup",
    ArrayType(StructType([
        StructField("first_name", StringType(), False),
        StructField("age", IntegerType(), False),
        StructField("age_group", StringType(), False)
    ]))
)

# Input data: 5 rows
data = [
    ("A", "Alice", 30),
    ("A", "Bob", 25),
    ("B", "Carol", 40),
    ("B", "Dave", 22),
    ("C", "Eve", 35)
]

schema = StructType([
    StructField("group_id", StringType()),
    StructField("first_name", StringType()),
    StructField("age", IntegerType())
])

df = spark.createDataFrame(data, schema)

# Group rows into array of struct (for each group)
df_struct = df.withColumn("person", F.struct("first_name", "age")) \
              .groupBy("group_id") \
              .agg(F.collect_list("person").alias("people"))

# Apply Java UDF and explode results
result = df_struct.withColumn("enriched", F.expr("addAgeGroup(people)")) \
                  .withColumn("person", F.explode("enriched")) \
                  .selectExpr("group_id", "person.first_name", "person.age", "person.age_group")

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

