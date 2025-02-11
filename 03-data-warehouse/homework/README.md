# 3rd Week Homework

1. Q: What is count of records for the 2024 Yellow Taxi Data? <br>
A: Use this query:
```sql
SELECT count(1)
FROM zoomcamp.yellow_tripdata_non_partitioned
```
The size is <b>20,332,093</b>

2. Q: Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table? <br>
A: 
Use this query:
```sql
SELECT DISTINCT(PULocationID)
FROM zoomcamp.yellow_tripdata_partitioned;

SELECT DISTINCT(PULocationID)
FROM zoomcamp.yellow_tripdata_non_partitioned;
```
Bigquery doesn't estimate external tabels because it has data stored outside of BigQuery. However, BigQuery can estimates its materialized table because the data stored on BigQuery itself. So, the answer is <b>0 MB for the External Table and 155.12 MB for the Materialized Table</b>

3. Q: Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different? <br>
A: As I have explained at 2nd question, so the answer is <b>BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.</b><br>

4. Q: How many records have a fare_amount of 0? <br>
A: Use this query:
```sql
SELECT count(1)
FROM zoomcamp.yellow_tripdata_nonpartitioned
WHERE fare_amount = 0;
```
and it results <b>8,333</b>

5. Q: What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy) <br>
A: It is the good idea for create a partitioned+clustered table. Cost and bytes read when you running the query would be decreased. Date-time column is a nice choice as a partition column, and a frequent-used-as-filter column (and contains a less variety of data) can be used as a clustering column. Use this query as a DDL:
```sql
CREATE OR REPLACE TABLE zoomcamp.yellow_tripdata_partitioned_clustered
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
select 
  *
from zoomcamp.yellow_tripdata_ext s where pt between '202401' and '202406';
```
So the answer is <b>Partition by tpep_dropoff_datetime and Cluster on VendorID</b>


6. Q: Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive).
Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values? <br>
A: Use this query:
```sql
SELECT DISTINCT(VendorID)
FROM zoomcamp.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-03-01' AND '2024-03-14';

SELECT DISTINCT(VendorID)
FROM zoomcamp.yellow_tripdata_non_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-03-01' AND '2024-03-14';
```
The answer is <b>310.24 MB for non-partitioned table and 26.84 MB for the partitioned table</b>

7. Q: Where is the data stored in the External Table you created? <br>
A: The answer is <b>GCP Bucket</b>

8. Q: It is best practice in Big Query to always cluster your data: True or False? <br>
A: It really depends on needs and cases. For a small table (approximately < 1 GB), clustering is not required. However, bigger table tend to be slower when you query on these, so considering to clustering these table can be the good way.