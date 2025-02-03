# 2nd Week Homework

1. Q: Within the execution for Yellow Taxi data for the year 2020 and month 12: what is the uncompressed file size (i.e. the output file yellow_tripdata_2020-12.csv of the extract task)?
A: The size is 128,3 MB

2. Q: What is the rendered value of the variable file when the inputs taxi is set to green, year is set to 2020, and month is set to 04 during execution?
A: green_tripdata_2020-04.csv

3. Q: How many rows are there for the Yellow Taxi data for all CSV files in the year 2020?
A: Use this query:
```sql
select count(1) from zoomcamp.yellow_tripdata where filename like 'yellow_tripdata_2020%';
```
and it results <b>24,648,499</b>
