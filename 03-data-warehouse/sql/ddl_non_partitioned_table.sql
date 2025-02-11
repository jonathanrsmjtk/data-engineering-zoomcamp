CREATE OR REPLACE TABLE zoomcamp.yellow_tripdata_non_partitioned AS
select 
  *
from zoomcamp.yellow_tripdata_ext s where pt between '202401' and '202406';