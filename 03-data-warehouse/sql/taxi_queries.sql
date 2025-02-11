



SELECT table_name, partition_id, total_rows
FROM `zoomcamp.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitioned'
ORDER BY total_rows DESC;

SELECT DISTINCT(VendorID)
FROM zoomcamp.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-01-01' AND '2024-06-30';

SELECT DISTINCT(VendorID)
FROM zoomcamp.yellow_tripdata_non_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-01-01' AND '2024-06-30';

SELECT count(*) as trips
FROM zoomcamp.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-01-01' AND '2024-06-30'
  AND VendorID=1;

SELECT count(*) as trips
FROM zoomcamp.yellow_tripdata_partitioned_clustered
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-01-01' AND '2024-06-30'
  AND VendorID=1;