SELECT passenger_count, trip_distance, PULocationID, DOLocationID, payment_type, fare_amount, tolls_amount, tip_amount
FROM `zoomcamp.yellow_tripdata_partitioned` WHERE fare_amount != 0;

CREATE OR REPLACE TABLE `zoomcamp.yellow_tripdata_ml` (
  `passenger_count` INTEGER,
  `trip_distance` FLOAT64,
  `PULocationID` STRING,
  `DOLocationID` STRING,
  `payment_type` STRING,
  `fare_amount` FLOAT64,
  `tolls_amount` FLOAT64,
  `tip_amount` FLOAT64
) AS (
SELECT passenger_count, trip_distance, cast(PULocationID AS STRING), CAST(DOLocationID AS STRING),
CAST(payment_type AS STRING), fare_amount, tolls_amount, tip_amount
FROM `zoomcamp.yellow_tripdata_partitioned` WHERE fare_amount != 0
);

CREATE OR REPLACE MODEL `zoomcamp.tip_model`
OPTIONS
(
  model_type='linear_reg',
  input_label_cols=['tip_amount'],
  DATA_SPLIT_METHOD='AUTO_SPLIT'
) AS
  SELECT
    *
  FROM
  `zoomcamp.yellow_tripdata_ml`
  WHERE
    tip_amount IS NOT NULL;

SELECT * FROM ML.FEATURE_INFO(MODEL `zoomcamp.tip_model`);

SELECT
*
FROM
ML.EVALUATE(
  MODEL `zoomcamp.tip_model`,
  (
    SELECT
    *
    FROM
    `zoomcamp.yellow_tripdata_ml`
    WHERE
    tip_amount IS NOT NULL
  )
);

SELECT
  *
FROM
ML.PREDICT(
  MODEL `zoomcamp.tip_model`,
  (
    SELECT
    *
    FROM
    `zoomcamp.yellow_tripdata_ml`
    WHERE
    tip_amount IS NOT NULL
  )
);

-- PREDICT AND EXPLAIN
SELECT
  *
FROM
ML.EXPLAIN_PREDICT(
  MODEL `zoomcamp.tip_model`,
  (
    SELECT
    *
    FROM
    `zoomcamp.yellow_tripdata_ml`
    WHERE
    tip_amount IS NOT NULL
  ), STRUCT(3 as top_k_features)
);
