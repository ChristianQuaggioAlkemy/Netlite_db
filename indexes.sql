
CREATE INDEX sources_plant_id_idx ON staging.sources (plant_id);
CREATE INDEX sources_line_id_idx ON staging.sources (line_id);
CREATE INDEX sources_kind_id_idx ON staging.sources (kind_id);
CREATE INDEX sources_name_idx ON staging.sources (name);

CREATE INDEX measures_ts_idx ON staging.measures (ts);
CREATE INDEX measures_insert_ts_idx ON staging.measures (insert_ts);
CREATE INDEX measures_source_id_idx ON staging.measures (source_id);
CREATE INDEX measures_status_idx ON staging.measures (status);

CREATE INDEX aggregate_min_ts_idx ON staging.aggregate_min (minute);
CREATE INDEX aggregate_min_line_id_idx ON staging.aggregate_min (line_id);
CREATE INDEX aggregate_min_status_idx ON staging.aggregate_min (status);

CREATE INDEX aggregate_day_ts_idx ON staging.aggregate_day (day);
CREATE INDEX aggregate_day_line_id_idx ON staging.aggregate_day (line_id);
CREATE INDEX aggregate_day_status_idx ON staging.aggregate_day (status);

CREATE INDEX aggregate_week_ts_idx ON staging.aggregate_week (week);
CREATE INDEX aggregate_week_line_id_idx ON staging.aggregate_week (line_id);
CREATE INDEX aggregate_week_status_idx ON staging.aggregate_week (status);
