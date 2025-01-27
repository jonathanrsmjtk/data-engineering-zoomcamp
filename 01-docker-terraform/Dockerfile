FROM python:3.9


WORKDIR /app
COPY taxi_ingest_duckdb.py ./taxi_ingest_duckdb.py
COPY requirements.txt ./requirements.txt
RUN pip install -r requirements.txt

ENTRYPOINT [ "python", "taxi_ingest_duckdb.py" ]