#!/bin/bash
set -e

echo "db initialization..."
echo "db:5432:postgres_db:postgres_user:8Fny?aXEFkh9ePA3" > ~/.pgpass
chmod 600 ~/.pgpass
psql -h db -U postgres_user -d postgres_db -p 5432 -f /docker-entrypoint-initdb.d/db.sql -e