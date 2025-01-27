# 1st Week Homework

1. Run using

```
docker run -it --entrypoint=bash python:3.12.8
pip --version
```
and you can see the version, <b>24.3.1</b>

2. The answer is <b>postgres:5432</b> because they're in the same network of Docker

3. 
```
with october_trips as (
	select *
	from green_taxi_trips gtt
	where cast(lpep_pickup_datetime as date) between '2019-10-01' and '2019-10-31' 
	and cast(lpep_dropoff_datetime as date) between '2019-10-01' AND '2019-10-31'
)
select 'up to 1 miles' as trip_group, count(1) from october_trips where trip_distance <= 1
union
select 'In between 1 (exclusive) and 3 miles (inclusive)' as trip_group, count(1) from october_trips where trip_distance > 1 and trip_distance <= 3
union
select 'In between 3 (exclusive) and 7 miles (inclusive)' as trip_group, count(1) from october_trips where trip_distance > 3 and trip_distance <= 7
union
select 'In between 7 (exclusive) and 10 miles (inclusive)' as trip_group, count(1) from october_trips where trip_distance > 7 and trip_distance <= 10
union
select 'over 10 miles' as trip_group, count(1) from october_trips where trip_distance > 10
```

4.
```
select lpep_pickup_datetime, max(trip_distance) as distance
from green_taxi_trips gtt 
group by lpep_pickup_datetime 
order by max(trip_distance) desc;
```

5.
```
select sum(gtt.total_amount) total_amount, z1.zone as src_zone
from green_taxi_trips gtt
inner join zones z1 on gtt.pulocationid = z1.locationid
where cast(lpep_pickup_datetime as date) = '2019-10-18'
group by z1.zone
order by sum(gtt.total_amount) desc;
```

6.
```
select max(gtt.tip_amount) as tip_amount, z1.zone as src_zone, z2.zone as dest_zone
from green_taxi_trips gtt
inner join zones z1 on gtt.pulocationid = z1.locationid
inner join zones z2 on gtt.dolocationid = z2.locationid
where z1.zone = 'East Harlem North'
group by z1.zone, z2.zone
order by max(gtt.tip_amount) desc;
```

7. Run 
```
terraform init
terraform apply -auto-apply
terraform destroy
```