
CREATE VIEW bad_lines_week AS
    SELECT
        week,
        line_id,
        status,
        count_value_week,
        count_value_week_mean,
        count_value_week_offset
    FROM 
        staging.aggregate_week
    WHERE 
        status = 0 AND count_value_week_offset < -20

CREATE VIEW good_lines_week AS
     SELECT
        week,
        line_id,
        status,
        count_value_week,
        count_value_week_mean,
        count_value_week_offset
    FROM 
        staging.aggregate_week
    WHERE 
        status = 0 AND count_value_week_offset > 20

CREATE VIEW bad_products_week AS
    SELECT 
        week,
        CASE WHEN status=0 THEN 'good'
             ELSE 'not_good'
        END AS status,
        count_value_week
    FROM
        staging.aggregate_week
    GROUP BY 
        week, status


