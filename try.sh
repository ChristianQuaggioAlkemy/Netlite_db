#!/bin/bash

source ./.env

rp=$(readlink -f "./indexes.sql")
echo ${rp}
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ${rp}
rp=$(readlink -f "./partitions.sql")
psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f ${rp}
