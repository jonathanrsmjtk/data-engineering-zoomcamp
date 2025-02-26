{{
    config(
        materialized='table'
    )
}}

with green_tripdata as (
    select *, 
        'Green' as service_type
    from {{ ref('stg_green_tripdata_dbt') }}
), 
yellow_tripdata as (
    select *, 
        'Yellow' as service_type
    from {{ ref('stg_yellow_tripdata_dbt') }}
), 
trips_unioned as (
    select * from green_tripdata
    union all 
    select * from yellow_tripdata
), 
dim_zones as (
    select * from {{ ref('dim_zones_dbt') }}
    where borough != 'Unknown'
),
fact as (
select trips_unioned.tripid, 
    trips_unioned.vendorid, 
    trips_unioned.service_type,
    trips_unioned.ratecodeid, 
    trips_unioned.pickup_locationid, 
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    trips_unioned.dropoff_locationid,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,  
    trips_unioned.pickup_datetime, 
    trips_unioned.dropoff_datetime, 
    trips_unioned.store_and_fwd_flag, 
    trips_unioned.passenger_count, 
    trips_unioned.trip_distance, 
    trips_unioned.trip_type, 
    trips_unioned.fare_amount, 
    trips_unioned.extra, 
    trips_unioned.mta_tax, 
    trips_unioned.tip_amount, 
    trips_unioned.tolls_amount, 
    trips_unioned.ehail_fee, 
    trips_unioned.improvement_surcharge, 
    trips_unioned.total_amount, 
    trips_unioned.payment_type, 
    trips_unioned.payment_type_description
    
from trips_unioned
inner join dim_zones as pickup_zone
on trips_unioned.pickup_locationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on trips_unioned.dropoff_locationid = dropoff_zone.locationid
where trips_unioned.trip_distance > 0
    and trips_unioned.fare_amount > 0
    and trips_unioned.payment_type_description in ('Cash', 'Credit Card')
    and {{ get_extracted_date("pickup_datetime", "year") }} between 2019 and 2021
)
select service_type, 
    pickup_datetime,
    percentile_cont(fact.fare_amount, 0.90) over(partition by fact.service_type, {{ get_extracted_date("pickup_datetime", "year") }}, {{ get_extracted_date("pickup_datetime", "month") }}) as p90,
    percentile_cont(fact.fare_amount, 0.95) over(partition by fact.service_type, {{ get_extracted_date("pickup_datetime", "year") }}, {{ get_extracted_date("pickup_datetime", "month") }}) as p95,
    percentile_cont(fact.fare_amount, 0.97) over(partition by fact.service_type, {{ get_extracted_date("pickup_datetime", "year") }}, {{ get_extracted_date("pickup_datetime", "month") }}) as p97
from fact