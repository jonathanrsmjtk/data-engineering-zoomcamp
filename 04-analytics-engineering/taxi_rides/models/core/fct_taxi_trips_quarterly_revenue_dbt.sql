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
revenue_per_quarter as (
    select 
    {{  get_extracted_date("pickup_datetime", "year") }} as year,
        trips_unioned.service_type,
        sum(trips_unioned.total_amount) as revenue_total_amount, 
        {{ get_quarter(get_extracted_date("pickup_datetime", "month")) }} as quarter
    from trips_unioned
    inner join dim_zones as pickup_zone
    on trips_unioned.pickup_locationid = pickup_zone.locationid
    inner join dim_zones as dropoff_zone
    on trips_unioned.dropoff_locationid = dropoff_zone.locationid
    group by {{  get_extracted_date("pickup_datetime", "year") }}, 
        trips_unioned.service_type,
        {{ get_quarter(get_extracted_date("pickup_datetime", "month")) }}
),
revenue_yoy as (
    select
        curr.service_type,
        curr.year,
        curr.revenue_total_amount,
        prev.year as prev_year,
        prev.revenue_total_amount as prev_revenue_total_amount,
         curr.quarter,
        case when prev.revenue_total_amount is not null then
            (curr.revenue_total_amount - prev.revenue_total_amount ) / prev.revenue_total_amount 
        else 0 end as revenue_total_amount_yoy
    from revenue_per_quarter curr
    left join revenue_per_quarter prev
        on curr.service_type = prev.service_type
        and curr.quarter = prev.quarter
        and curr.year = prev.year + 1
)

select * from revenue_yoy