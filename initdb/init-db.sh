#!/bin/bash
set -e

source .env

echo "db initialization...🚀"
echo "log_statement = 'all'" >> /var/lib/postgresql/data/postgresql.conf # enable postgres logging
echo "db:5432:${POSTGRES_DB}:${POSTGRES_USER}:${POSTGRES_PASSWORD}" > ~/.pgpass
chmod 600 ~/.pgpass
psql -h db -U ${POSTGRES_USER} -d ${POSTGRES_DB} -p 5432 -f /docker-entrypoint-initdb.d/db.sql -e
