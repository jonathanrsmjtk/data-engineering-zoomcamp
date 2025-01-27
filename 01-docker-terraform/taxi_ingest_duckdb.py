from datetime import datetime
import duckdb
from time import time


import argparse

QUERY_DUCKDB_COLUMN_FETCH = """
    describe select * from {dataframe}
"""

QUERY_DUCKDB_ATTACH_POSTGRES = """
    ATTACH 'dbname={db} user={user} password={password} host={host} port={port}' AS ny_taxi (TYPE POSTGRES, SCHEMA 'public')
"""

QUERY_DUCKDB_INSERT_TO_POSTGRES = """
    INSERT INTO ny_taxi.{table_name} select * from {dataframe}
"""


def read_parquet(url: str) -> duckdb.DuckDBPyRelation:
    duckdb.sql("install httpfs")
    duckdb.sql("load httpfs")
    dataframe = duckdb.read_parquet(url)
    columns = duckdb.sql(QUERY_DUCKDB_COLUMN_FETCH.format(dataframe="dataframe")).df()
    columns_list = columns["column_name"].replace({
        'VendorID': 'vendorid',
        'RatecodeID': 'ratecodeid',
        'PULocationID': 'pulocationid',
        'DOLocationID': 'dolocationid',
        'Airport_fee': 'airport_fee'
    }).tolist()
    dataframe = duckdb.sql(f"select {', '.join(column for column in columns_list)} from dataframe")
    return dataframe

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url
    
    duckdb.sql("install postgres")
    duckdb.sql("load postgres")
    duckdb.sql(QUERY_DUCKDB_ATTACH_POSTGRES.format(
            db=db,
            user=user,
            password=password,
            host=host,
            port=port
        )
    )

    dataframe = read_parquet(url)
    print(f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} Starting ingestion")
    try:
        start_time = time()
        duckdb.sql(QUERY_DUCKDB_INSERT_TO_POSTGRES.format(
            table_name=table_name,
            dataframe="dataframe"
        ))
    except Exception as e:
        raise Exception(e)
    else:
        print(f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} Success for ingest for {time() - start_time} secs")

if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(description="ingest file data to Postgres")
    parser.add_argument("--user", help="user name for postgres")
    parser.add_argument("--password", help="password for postgres")
    parser.add_argument("--host", help="host for postgres")
    parser.add_argument("--port", help="port for postgres")
    parser.add_argument("--db", help="database name for postgres")
    parser.add_argument("--table-name", help="name of the table where the results will go to")
    parser.add_argument("--url", help="url of the file")

    args = parser.parse_args()
    main(args)
