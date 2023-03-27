
CREATE INDEX sources_plant_id_idx ON staging.sources (plant_id);
CREATE INDEX sources_line_id_idx ON staging.sources (line_id);
CREATE INDEX sources_kind_id_idx ON staging.sources (kind_id);
CREATE INDEX sources_name_idx ON staging.sources (name);

CREATE INDEX measures_ts_idx ON staging.measures (ts);
CREATE INDEX measures_insert_ts_idx ON staging.measures (insert_ts);
CREATE INDEX measures_source_id_idx ON staging.measures (source_id);
CREATE INDEX measures_status_idx ON staging.measures (status);

CREATE INDEX agg_min_ts_idx ON staging.agg_min (minute);
CREATE INDEX agg_min_line_id_idx ON staging.agg_min (line_id);
CREATE INDEX agg_min_status_idx ON staging.agg_min (status);

CREATE INDEX agg_day_ts_idx ON staging.agg_day (day);
CREATE INDEX agg_day_line_id_idx ON staging.agg_day (line_id);
CREATE INDEX agg_day_status_idx ON staging.agg_day (status);

CREATE INDEX agg_week_ts_idx ON staging.agg_week (week);
CREATE INDEX agg_week_line_id_idx ON staging.agg_week (line_id);
CREATE INDEX agg_week_status_idx ON staging.agg_week (status);
