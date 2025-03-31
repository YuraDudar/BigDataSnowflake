#!/bin/bash
set -e

PGDATABASE="$POSTGRES_DB"
PGUSER="$POSTGRES_USER"
export PGPASSWORD="$POSTGRES_PASSWORD"

echo "Starting CSV import into mock_data_raw table..."
for f in /data_source/MOCK_DATA*.csv
do
  echo "Processing $f file..."
  psql -v ON_ERROR_STOP=1 --username "$PGUSER" --dbname "$PGDATABASE" <<-EOSQL
    \\copy mock_data_raw FROM '$f' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
EOSQL
done

echo "CSV import finished."

unset PGPASSWORD