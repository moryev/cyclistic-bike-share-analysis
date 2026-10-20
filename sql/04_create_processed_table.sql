-- Cyclistic bike-share analysis
-- 04_create_processed_table.sql
-- Purpose: create the cleaned/derived analytical table while leaving rides_raw unchanged.
--
-- Project-specific findings incorporated here:
--   * 35 duplicated ride IDs were found across the April/May 2026 source boundary.
--   * For those duplicated rides, the April record is retained and the May copy removed.
--   * Non-positive durations are retained but flagged as invalid for duration statistics.
--   * Durations longer than 24 hours are retained but excluded from primary duration statistics.

USE cyclistic;

DROP TABLE IF EXISTS rides_processed;
DROP TABLE IF EXISTS duplicate_ride_ids;

-- -----------------------------------------------------------------------------
-- 1. Persist the cross-month duplicate IDs identified during quality checks.
-- -----------------------------------------------------------------------------
CREATE TABLE duplicate_ride_ids AS
SELECT DISTINCT april.ride_id
FROM rides_raw AS april
JOIN rides_raw AS may
    ON april.ride_id = may.ride_id
WHERE april.source_month = '2026-04-01'
  AND may.source_month   = '2026-05-01';

ALTER TABLE duplicate_ride_ids
ADD PRIMARY KEY (ride_id);

-- -----------------------------------------------------------------------------
-- 2. Build the analytical table.
-- -----------------------------------------------------------------------------
CREATE TABLE rides_processed AS
SELECT
    r.ride_id,
    r.rideable_type,
    r.started_at,
    r.ended_at,
    r.start_station_name,
    r.start_station_id,
    r.end_station_name,
    r.end_station_id,
    r.start_lat,
    r.start_lng,
    r.end_lat,
    r.end_lng,
    r.member_casual,
    r.source_month,

    DATE(r.started_at) AS ride_date,
    DATE(DATE_FORMAT(r.started_at, '%Y-%m-01')) AS ride_month,
    DAYNAME(r.started_at) AS day_of_week,
    DAYOFWEEK(r.started_at) AS day_of_week_num,
    HOUR(r.started_at) AS hour_of_day,

    CASE
        WHEN DAYOFWEEK(r.started_at) IN (1, 7) THEN 1
        ELSE 0
    END AS is_weekend,

    TIMESTAMPDIFF(SECOND, r.started_at, r.ended_at) AS raw_duration_seconds,

    CASE
        WHEN r.ended_at <= r.started_at THEN 1
        ELSE 0
    END AS dst_or_invalid_duration,

    CASE
        WHEN TIMESTAMPDIFF(SECOND, r.started_at, r.ended_at) > 86400 THEN 1
        ELSE 0
    END AS over_24h,

    CASE
        WHEN r.ended_at > r.started_at
         AND TIMESTAMPDIFF(SECOND, r.started_at, r.ended_at) <= 86400
        THEN 1
        ELSE 0
    END AS duration_valid,

    CASE
        WHEN r.ended_at > r.started_at
         AND TIMESTAMPDIFF(SECOND, r.started_at, r.ended_at) <= 86400
        THEN TIMESTAMPDIFF(SECOND, r.started_at, r.ended_at) / 60.0
        ELSE NULL
    END AS ride_length_minutes

FROM rides_raw AS r
LEFT JOIN duplicate_ride_ids AS d
    ON r.ride_id = d.ride_id
WHERE NOT (
    d.ride_id IS NOT NULL
    AND r.source_month = '2026-05-01'
);

-- ride_id is unique after deduplication.
ALTER TABLE rides_processed
ADD PRIMARY KEY (ride_id);

-- -----------------------------------------------------------------------------
-- 3. Validation of the processed table.
-- -----------------------------------------------------------------------------
SELECT
    COUNT(*) AS processed_rows,
    COUNT(DISTINCT ride_id) AS unique_ride_ids
FROM rides_processed;

SELECT
    SUM(dst_or_invalid_duration = 1) AS non_positive_or_dst_ambiguous,
    SUM(over_24h = 1) AS over_24h,
    SUM(duration_valid = 1) AS valid_duration_rows
FROM rides_processed;

SELECT COUNT(*) AS duplicated_ride_ids_remaining
FROM (
    SELECT ride_id
    FROM rides_processed
    GROUP BY ride_id
    HAVING COUNT(*) > 1
) AS duplicates;
