DO
$script$
	DECLARE 
		partition_week TEXT;
		partition_days TEXT;
	BEGIN 
		FOR i IN 0..4 LOOP 
			partition_week := format(
				'create table if not exists staging.measures_week_%s partition of staging.measures for values from (''%s'') to (''%s'') partition by range (ts)',
				to_char(now() + make_interval(weeks => i), 'YYYY_MM_DD'),
				to_char(now() + make_interval(weeks => i), 'YYYY-MM-DD'),
				to_char(now() + make_interval(weeks => i+1), 'YYYY-MM-DD')
			);
			EXECUTE partition_week;
			FOR j IN 0..6 LOOP
				partition_days := format(
					'create table if not exists staging.measures_week_%s_day_%s partition of staging.measures_week_%s for values from (''%s'') to (''%s'')',
					to_char(now() + make_interval(weeks => i), 'YYYY_MM_DD'),
					to_char(now() + make_interval(weeks => i, days => j), 'YYYY_MM_DD'),
					to_char(now() + make_interval(weeks => i), 'YYYY_MM_DD'),
					to_char(now() + make_interval(weeks => i, days => j), 'YYYY-MM-DD'),
					to_char(now() + make_interval(weeks => i, days => j+1), 'YYYY-MM-DD')
				);
				EXECUTE partition_days;
			END LOOP;
		END LOOP;
	END
$script$;

