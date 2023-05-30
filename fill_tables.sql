
/*
##########################################
############## FILL SOURCES ##############
##########################################
*/

CREATE EXTENSION IF NOT EXISTS tablefunc;

INSERT INTO staging.sources(plant_id, line_id, kind_id, name)
	SELECT
    		1 as plant_id,
    		1 + (i % 3) as line_id,
    		1 + (i % 5) as kind_id,
    		concat('device ', i) as name	
	FROM
    		generate_series(1, 15) s(i);

/*
##########################################
############# FILL MEASURES ##############
##########################################
*/

INSERT INTO staging.measures(ts, source_id, status, value)
	SELECT
		cast(now() + make_interval(secs => random() * 31*86400) AS timestamp) as ts,
		(random() * 40)::int as source_id,
		(random() * 5)::int as status,
		value
	FROM
		normal_rand(1000 * 1000 * 1.5, 250, 10) s(value);
/*
##########################################
############ FILL AGGREGATES #############
##########################################
*/


INSERT INTO staging.aggregate_hour(hour, line_id, status, count_value_hour, avg_value_hour, stddev_value_hour)
	SELECT
		date_trunc('hour', ts) as hour,
		line_id,
		status,
		count(1) as count_value_hour,
		avg(value) as avg_value_hour,
		stddev_samp(value) as stddev_value_hour
	FROM
		staging.measures m
		JOIN staging.sources s
			ON m.source_id = s.id
	GROUP BY 
		hour, line_id, status
	ORDER BY
		hour;
/*
##########################################
############ fill day aggregate #############
##########################################
*/

WITH ezio as
(
	SELECT
		CAST(date_trunc('day', hour) as date) as day,
		line_id,
		status,
		sum(count_value_hour) AS count_value_day,
		sum(count_value_hour*avg_value_hour)/sum(count_value_hour) AS avg_value_day
	FROM
		staging.aggregate_hour
	GROUP BY 
		day, line_id, status
	ORDER BY 
		day
)

INSERT INTO staging.aggregate_day(day, line_id, status, count_value_day, count_value_day_mean, stddev_count_value_day, count_value_day_offset, avg_value_day, avg_value_day_mean, stddev_avg_value_day, avg_value_day_offset)
	SELECT
		day,
		line_id,
		status,
		count_value_day,
		avg(count_value_day) OVER (PARTITION BY day) AS count_value_day_mean,
		stddev_samp(count_value_day) OVER (PARTITION BY day) AS stddev_count_value_day,
		round((100*(count_value_day - avg(count_value_day) OVER (PARTITION BY day))/avg(count_value_day) OVER (PARTITION BY day))::numeric, 2) AS count_value_day_offset,
		avg_value_day,
		avg(avg_value_day) OVER (PARTITION BY day) AS avg_value_day_mean,
		stddev_samp(avg_value_day) OVER (PARTITION BY day) AS stddev_avg_value_day,
		round((100*(avg_value_day - avg(avg_value_day) OVER (PARTITION BY day))/avg(avg_value_day) OVER (PARTITION BY day))::numeric, 2) AS avg_value_day_offset
	FROM 
		ezio;

/*
##########################################
############ fill week aggregate #############
##########################################
*/

WITH ezio as
(
	SELECT
		CAST(date_trunc('week', hour) as date) as week,
		line_id,
		status,
		sum(count_value_hour) AS count_value_week,
		sum(count_value_hour*avg_value_hour)/sum(count_value_hour) AS avg_value_week
	FROM
		staging.aggregate_hour
	GROUP BY 
		week, line_id, status
	ORDER BY 
		week
)

INSERT INTO staging.aggregate_week(week, line_id, status, count_value_week, count_value_week_mean, stddev_count_value_week, count_value_week_offset, avg_value_week, avg_value_week_mean, stddev_avg_value_week, avg_value_week_offset)
	SELECT
		week,
		line_id,
		status,
		count_value_week,
		avg(count_value_week) OVER (PARTITION BY week) AS count_value_week_mean,
		stddev_samp(count_value_week) OVER (PARTITION BY week) AS stddev_count_value_week,
		round((100*(count_value_week - avg(count_value_week) OVER (PARTITION BY week))/avg(count_value_week) OVER (PARTITION BY week))::numeric, 2) AS count_value_week_offset,
		avg_value_week,
		avg(avg_value_week) OVER (PARTITION BY week) AS avg_value_week_mean,
		stddev_samp(avg_value_week) OVER (PARTITION BY week) AS stddev_avg_value_week,
		round((100*(avg_value_week - avg(avg_value_week) OVER (PARTITION BY week))/avg(avg_value_week) OVER (PARTITION BY week))::numeric, 2) AS avg_value_week_offset
	FROM 
		ezio;


/*
##########################################
############ fill month aggregate #############
##########################################
*/

WITH ezio as
(
	SELECT
		CAST(date_trunc('month', hour) as date) as month,
		line_id,
		status,
		sum(count_value_hour) AS count_value_month,
		sum(count_value_hour*avg_value_hour)/sum(count_value_hour) AS avg_value_month
	FROM
		staging.aggregate_hour
	GROUP BY 
		month, line_id, status
	ORDER BY 
		month
)

INSERT INTO staging.aggregate_month(month, line_id, status, count_value_month, count_value_month_mean, stddev_count_value_month, count_value_month_offset, avg_value_month, avg_value_month_mean, stddev_avg_value_month, avg_value_month_offset)
	SELECT
		month,
		line_id,
		status,
		count_value_month,
		avg(count_value_month) OVER (PARTITION BY month) AS count_value_month_mean,
		stddev_samp(count_value_month) OVER (PARTITION BY month) AS stddev_count_value_month,
		round((100*(count_value_month - avg(count_value_month) OVER (PARTITION BY month))/avg(count_value_month) OVER (PARTITION BY month))::numeric, 2) AS count_value_month_offset,
		avg_value_month,
		avg(avg_value_month) OVER (PARTITION BY month) AS avg_value_month_mean,
		stddev_samp(avg_value_month) OVER (PARTITION BY month) AS stddev_avg_value_month,
		round((100*(avg_value_month - avg(avg_value_month) OVER (PARTITION BY month))/avg(avg_value_month) OVER (PARTITION BY month))::numeric, 2) AS avg_value_month_offset
	FROM 
		ezio;












