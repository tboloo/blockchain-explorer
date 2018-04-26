#!/bin/sh
set -e

PGPASSWORD=${POSTGRES_PASSWORD} psql -h ${POSTGRES_HOST} -U ${POSTGRES_USER} -f ./app/db/explorerpg.sql
PGPASSWORD=${POSTGRES_PASSWORD} psql -h ${POSTGRES_HOST} -U ${POSTGRES_USER} -f ./app/db/updatepg.sql

rm -rf /tmp/fabric-client-kvs*

node main.js
