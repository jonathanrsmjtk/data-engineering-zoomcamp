#run with 'spark-submit --master local pyspark_tutorial.py'
from pyspark.sql import SparkSession

spark = SparkSession\
    .builder\
    .master("local[*]")\
    .appName("test")\
    .getOrCreate()
sc = spark.sparkContext
# sc.setLogLevel("ERROR")

df = spark.read.parquet("./files/fhvhv_tripdata_2021-01.parquet")

#Show as dataframe
df.show()

#Show as rows
print(df.head(5))

#Get schemas
print(df.schema)

#Change schema
import pyspark.sql.types as types
schema = types.StructType(
    [
        types.StructField('hvfhs_license_num', types.StringType(), True), 
        types.StructField('dispatching_base_num', types.StringType(), True), 
        types.StructField('originating_base_num', types.StringType(), True), 
        types.StructField('request_datetime', types.TimestampType(), True), 
        types.StructField('on_scene_datetime', types.TimestampType(), True), 
        types.StructField('pickup_datetime', types.TimestampType(), True), 
        types.StructField('dropoff_datetime', types.TimestampType(), True), 
        types.StructField('PULocationID', types.IntegerType(), True), 
        types.StructField('DOLocationID', types.IntegerType(), True), 
        types.StructField('trip_miles', types.DoubleType(), True), 
        types.StructField('trip_time', types.IntegerType(), True), 
        types.StructField('base_passenger_fare', types.DoubleType(), True), 
        types.StructField('tolls', types.DoubleType(), True), 
        types.StructField('bcf', types.DoubleType(), True), 
        types.StructField('sales_tax', types.DoubleType(), True), 
        types.StructField('congestion_surcharge', types.DoubleType(), True), 
        types.StructField('airport_fee', types.DoubleType(), True), 
        types.StructField('tips', types.DoubleType(), True), 
        types.StructField('driver_pay', types.DoubleType(), True), 
        types.StructField('shared_request_flag', types.StringType(), True), 
        types.StructField('shared_match_flag', types.StringType(), True), 
        types.StructField('access_a_ride_flag', types.StringType(), True), 
        types.StructField('wav_request_flag', types.StringType(), True),
        types.StructField('wav_match_flag', types.StringType(), True)
    ]
)

print("Schema before changed", df.printSchema)
df = spark.createDataFrame(df.rdd, schema)
print("Schema after changed", df.printSchema)

# df = spark.read.format("parquet").schema(schema).load("./files/fhvhv_tripdata_2021-01.parquet")
# print(df.head(10))

#Repartition parquet into smaller
# df = df.repartition(4)
# df.write.format("parquet").mode("overwrite").save("./files/fhvhv")

#using built-in functions
import pyspark.sql.functions as F

df\
    .withColumn('pickup_date', F.to_date(df.pickup_datetime))\
    .withColumn('dropoff_date', F.to_date(df.dropoff_datetime))\
    .show()

#Using UDF
def crazy_stuff(base_num):
    num = int(base_num[1:])
    if num % 7 == 0:
        return f's/{num:03x}'
    elif num % 3 == 0:
        return f'a/{num:03x}'
    else:
        return f'e/{num:03x}'

crazy_stuff_udf = F.udf(crazy_stuff, returnType=types.StringType())
df\
    .withColumn('pickup_date', F.to_date(df.pickup_datetime))\
    .withColumn('dropoff_date', F.to_date(df.dropoff_datetime))\
    .withColumn('base_id', crazy_stuff_udf(df.dispatching_base_num))\
    .select('base_id', 'pickup_date', 'dropoff_date', 'PULocationID', 'DOLocationID')\
    .show()

#Spark SQL
df\
    .withColumn("service_type", F.lit("fhvhv"))\
    .createOrReplaceTempView("fhvhv_tripdata")

spark.sql("""
        SELECT 
            -- Reveneue grouping 
            PULocationID AS trip_zone,
            date_trunc('month', pickup_datetime) AS trip_month, 
            service_type, 

            max(trip_miles) as max_distance,
            max(trip_time) as max_trip_time
        FROM
            fhvhv_tripdata
        GROUP BY
            1, 2, 3
""").show()

spark.stop()