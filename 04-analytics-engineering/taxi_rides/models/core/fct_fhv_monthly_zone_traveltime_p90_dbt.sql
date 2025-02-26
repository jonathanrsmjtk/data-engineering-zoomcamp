{{
    config(
        materialized='table'
    )
}}

with dim_fhv_trips as (
    select *
    from {{ ref('dim_fhv_trips_dbt') }}
)

select 
    dim_fhv_trips.tripid, 
    dim_fhv_trips.dispatching_base_num, 
    dim_fhv_trips.pickup_locationid, 
    dim_fhv_trips.pickup_borough, 
    dim_fhv_trips.pickup_zone, 
    dim_fhv_trips.dropoff_locationid,
    dim_fhv_trips.dropoff_borough, 
    dim_fhv_trips.dropoff_zone,  
    dim_fhv_trips.pickup_datetime, 
    dim_fhv_trips.dropoff_datetime, 
    {{ get_extracted_date("pickup_datetime", "month") }} as month,
    {{ get_extracted_date("pickup_datetime", "year") }} as year,
    timestamp_diff(dropoff_datetime, pickup_datetime, second) as trip_duration,
    percentile_cont(timestamp_diff(dropoff_datetime, pickup_datetime, second), 0.90) over(partition by year, month, pickup_locationid, dropoff_locationid) as p90,
from dim_fhv_trips