import os
import pandas as pd
from sqlalchemy import create_engine
from time import time
from datetime import datetime

import argparse


def read_parquet(filename: str) -> pd.DataFrame:
    dataframe = pd.read_parquet(filename)
    dataframe = dataframe.rename({
        'VendorID': 'vendorid',
        'RatecodeID': 'ratecodeid',
        'PULocationID': 'pulocationid',
        'DOLocationID': 'dolocationid',
        'Airport_fee': 'airport_fee'
    }, axis=1)
    dataframe["tpep_pickup_datetime"] = pd.to_datetime(dataframe["tpep_pickup_datetime"])
    dataframe["tpep_dropoff_datetime"] = pd.to_datetime(dataframe["tpep_dropoff_datetime"])
    return dataframe

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url
    filename = "output.parquet"

    os.system(f"curl {url} -o {filename}")
    
    dataframe = read_parquet(filename)
    engine = create_engine(f"postgresql://{user}:{password}@{host}:{port}/{db}")
    print(f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} Starting ingestion")
    try:
        start_time = time()
        dataframe.to_sql(name=table_name, con=engine, if_exists="append", index=False, chunksize=100000)
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
