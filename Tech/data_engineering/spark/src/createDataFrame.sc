import org.apache.spark.sql._
import org.apache.spark.sql.types._

# To create a dataframe first have to create a list of Rows , the convert that to RDD and then create the RDD with createDataFrame API

val row = Row(1,true,"a string",null)

val rdd = spark.sparkContext.makeRDD(List(row))

val schema = List(StructField("col1",IntegerType,false), StructField("col2",BooleanType,true),StructField("col3",StringType,true),StructField("col4",StringType,true))

val df = spark.createDataFrame(rdd,StructType(schema))
