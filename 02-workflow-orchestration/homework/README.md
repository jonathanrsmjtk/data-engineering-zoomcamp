# 2nd Week Homework

1. Q: Within the execution for Yellow Taxi data for the year 2020 and month 12: what is the uncompressed file size (i.e. the output file yellow_tripdata_2020-12.csv of the extract task)? <br>
A: The size is <b>128,3 MB</b>

2. Q: What is the rendered value of the variable file when the inputs taxi is set to green, year is set to 2020, and month is set to 04 during execution? <br>
A: <b>green_tripdata_2020-04.csv</b>

3. Q: How many rows are there for the Yellow Taxi data for all CSV files in the year 2020? <br>
A: Use this query:
```sql
select count(1) from zoomcamp.yellow_tripdata where filename like 'yellow_tripdata_2020%';
```
and it results <b>24,648,499</b>

4. Q: How many rows are there for the Green Taxi data for all CSV files in the year 2020? <br>
A: Use the same query as 3rd question but change the filter value:
```sql
select count(1) from zoomcamp.yellow_tripdata where filename like 'green_tripdata_2020%';
```
and it results <b>1,734,051</b>

5. Q: How many rows are there for the Yellow Taxi data for the March 2021 CSV file? <br>
A: Use this query:
```sql
select count(1) from zoomcamp.yellow_tripdata where filename like 'yellow_tripdata_2021-03%';
```
and it results <b>1,925,152</b>

6. Q: How would you configure the timezone to New York in a Schedule trigger? <br>
A: As written in <href>https://kestra.io/docs/configuration#timezone</href>, you can set timezone in JVM option. We will configure the timezone to New York, so we can set <b>America/New_York</b> as a timezone, so the answer is:<br>
<b>Add a timezone property set to America/New_York in the Schedule trigger configuration</b>