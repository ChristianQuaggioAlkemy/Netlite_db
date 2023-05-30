#!/bin/bash

export $(cat .env | xargs)

#####################
## SCHEMA CREATION ##
#####################

schema_name="staging"
psql -h ${PGHOST} -U ${PGUSER} -d ${PGDATABASE}  -c "CREATE SCHEMA IF NOT EXISTS ${schema_name}"

# Tables' name

TABLE_SOURCES="sources"
TABLE_MEASURES="measures"
TABLE_AGG_HOUR="aggregate_hour"
TABLE_AGG_DAY="aggregate_day"
TABLE_AGG_WEEK="aggregate_week"
TABLE_AGG_MONTH="aggregate_month"

names="${schema_name} ${TABLE_SOURCES} ${TABLE_MEASURES} ${TABLE_AGG_HOUR} ${TABLE_AGG_DAY} ${TABLE_AGG_WEEK} ${TABLE_AGG_MONTH}"

#####################
## TABLES CREATION ##
#####################

psql -h $PGHOST -U $PGUSER -d $PGDATABASE  -c "
	CREATE TABLE IF NOT EXISTS ${schema_name}.${TABLE_SOURCES} (
		id bigserial NOT NULL,
		plant_id smallint NOT NULL,
		line_id smallint NOT NULL,
		kind_id smallint NOT NULL,
		name varchar(100) NOT NULL,
		CONSTRAINT sources_pk PRIMARY KEY (id)	
	);"

 psql -h $PGHOST -U $PGUSER -d $PGDATABASE  -c "
	CREATE TABLE IF NOT EXISTS ${schema_name}.${TABLE_MEASURES} (
		id bigserial NOT NULL,
		ts timestamp NOT NULL,
		insert_ts timestamp NOT NULL DEFAULT current_timestamp,
		source_id smallint NOT NULL,
		status smallint NOT NULL,
		value real NOT NULL
        ) PARTITION BY RANGE(ts);"

psql -h $PGHOST -U $PGUSER -d $PGDATABASE  -c "
	CREATE TABLE IF NOT EXISTS ${schema_name}.${TABLE_AGG_HOUR} (
		hour timestamp NOT NULL,
		line_id smallint NOT NULL,
		status smallint NOT NULL,
		count_value_hour int,
		avg_value_hour real,
		stddev_value_hour real
	);"

 psql -h $PGHOST -U $PGUSER -d $PGDATABASE  -c "
	CREATE TABLE IF NOT EXISTS ${schema_name}.${TABLE_AGG_DAY} (
		day date NOT NULL,
		line_id smallint NOT NULL,
		status smallint NOT NULL,
		count_value_day int,
		count_value_day_mean real,
		stddev_count_value_day real,
		count_value_day_offset real,
		avg_value_day real,
		avg_value_day_mean real,
		stddev_avg_value_day real,
		avg_value_day_offset real
	);"

psql -h $PGHOST -U $PGUSER -d $PGDATABASE  -c "
	CREATE TABLE IF NOT EXISTS ${schema_name}.${TABLE_AGG_WEEK} (
		week date NOT NULL,
		line_id smallint NOT NULL,
		status smallint NOT NULL,
		count_value_week int,
		count_value_week_mean real,
		stddev_count_value_week real,
		count_value_week_offset real,
		avg_value_week real,
		avg_value_week_mean real,
		stddev_avg_value_week real,
		avg_value_week_offset real
	);"

psql -h $PGHOST -U $PGUSER -d $PGDATABASE  -c "
	CREATE TABLE IF NOT EXISTS ${schema_name}.${TABLE_AGG_MONTH} (
		month date NOT NULL,
		line_id smallint NOT NULL,
		status smallint NOT NULL,
		count_value_month int,
		count_value_month_mean real,
		stddev_count_value_month real,
		count_value_month_offset real,
		avg_value_month real,
		avg_value_month_mean real,
		stddev_avg_value_month real,
		avg_value_month_offset real
	);"

####################
## CREATE INDEXES ##
####################

rp=$(readlink -f "./indexes.sql")
psql -h $PGHOST -U $PGUSER -d $PGDATABASE  -f ${rp}

#######################
## CREATE PARTITIONS ##
#######################

rp=$(readlink -f "./partitions.sql")
psql -h $PGHOST -U $PGUSER -d $PGDATABASE  -f ${rp}

#######################
##    FILL TABLES    ##
#######################

rp=$(readlink -f "./fill_tables.sql")
psql -h $PGHOST -U $PGUSER -d $PGDATABASE  -f ${rp}

#######################
##   QUERY TABLES    ##
#######################

rp=$(readlink -f "./views.sql")
psql -h $PGHOST -U $PGUSER -d $PGDATABASE  -f ${rp}
