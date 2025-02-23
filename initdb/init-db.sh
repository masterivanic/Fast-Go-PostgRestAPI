#!/bin/bash
set -e

if [ -z "POSTGRES_PASSWORD" ]; then
    export POSTGRES_PASSWORD="8Fny?aXEFkh9ePA3"
fi

while ! PGPASSWORD=${POSTGRES_PASSWORD} psql -h db -U postgres_user -c '\q'; do echo "En attente du demarrage de postgresql..." && sleep 1; done
if ! PGPASSWORD=${POSTGRES_PASSWORD}  psql -U postgres_user -h db -p 5432 -lqt | cut -d \| -f 1 | cut -d ' ' -f 2 | grep -q "^postgres_db$"; then
    PGPASSWORD=${POSTGRES_PASSWORD} createdb -U postgres_user -h db -p 5432 postgres_db
else
    echo "La database existe déjà..."
fi

echo "db initialization..."
echo "db:5432:postgres_db:postgres_user:8Fny?aXEFkh9ePA3" > ~/.pgpass
chmod 600 ~/.pgpass
psql -h db -U postgres_user -d postgres_db -p 5432 -f /docker-entrypoint-initdb.d/db.sql -e