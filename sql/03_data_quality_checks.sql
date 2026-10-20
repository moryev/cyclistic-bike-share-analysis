-- Cyclistic bike-share analysis
-- 03_data_quality_checks.sql
-- Purpose: inspect the combined raw dataset before constructing the analytical table.

USE cyclistic;

-- -----------------------------------------------------------------------------
-- 1. Row counts by source month
-- -----------------------------------------------------------------------------
SELECT
    source_month,
    COUNT(*) AS rides
FROM rides_raw
GROUP BY source_month
ORDER BY source_month;

-- -----------------------------------------------------------------------------
-- 2. Overall row count versus unique ride IDs
-- -----------------------------------------------------------------------------
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ride_id) AS unique_ride_ids
FROM rides_raw;

-- -----------------------------------------------------------------------------
-- 3. Expected categorical values
-- -----------------------------------------------------------------------------
SELECT
    member_casual,
    COUNT(*) AS rides
FROM rides_raw
GROUP BY member_casual
ORDER BY member_casual;

SELECT
    rideable_type,
    COUNT(*) AS rides
FROM rides_raw
GROUP BY rideable_type
ORDER BY rideable_type;

-- -----------------------------------------------------------------------------
-- 4. Missing-value profile
-- -----------------------------------------------------------------------------
SELECT
    COUNT(*) AS total_rows,
    SUM(ride_id IS NULL)            AS missing_ride_id,
    SUM(rideable_type IS NULL)      AS missing_rideable_type,
    SUM(started_at IS NULL)         AS missing_started_at,
    SUM(ended_at IS NULL)           AS missing_ended_at,
    SUM(start_station_name IS NULL) AS missing_start_station_name,
    SUM(start_station_id IS NULL)   AS missing_start_station_id,
    SUM(end_station_name IS NULL)   AS missing_end_station_name,
    SUM(end_station_id IS NULL)     AS missing_end_station_id,
    SUM(start_lat IS NULL)          AS missing_start_lat,
    SUM(start_lng IS NULL)          AS missing_start_lng,
    SUM(end_lat IS NULL)            AS missing_end_lat,
    SUM(end_lng IS NULL)            AS missing_end_lng,
    SUM(member_casual IS NULL)      AS missing_member_casual
FROM rides_raw;

-- -----------------------------------------------------------------------------
-- 5. Add an index once all monthly files are loaded.
--    This substantially speeds up duplicate-ID checks on the ~6.17M-row table.
--    Run this statement only once on a fresh rides_raw table.
-- -----------------------------------------------------------------------------
ALTER TABLE rides_raw
ADD INDEX idx_ride_id (ride_id);

SHOW INDEX
FROM rides_raw
WHERE Key_name = 'idx_ride_id';

-- -----------------------------------------------------------------------------
-- 6. Duplicate ride IDs
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS duplicated_ride_ids
FROM (
    SELECT ride_id
    FROM rides_raw FORCE INDEX (idx_ride_id)
    GROUP BY ride_id
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT
    ride_id,
    COUNT(*) AS occurrences,
    GROUP_CONCAT(
        DATE_FORMAT(source_month, '%Y-%m')
        ORDER BY source_month
    ) AS source_months
FROM rides_raw
GROUP BY ride_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC, ride_id;

-- Inspect all records associated with duplicated IDs without creating a temp table.
WITH duplicate_ids AS (
    SELECT ride_id
    FROM rides_raw FORCE INDEX (idx_ride_id)
    GROUP BY ride_id
    HAVING COUNT(*) > 1
)
SELECT r.*
FROM rides_raw AS r
JOIN duplicate_ids AS d
    ON r.ride_id = d.ride_id
ORDER BY
    r.ride_id,
    r.source_month,
    r.started_at;

-- -----------------------------------------------------------------------------
-- 7. Ride-duration quality checks
-- -----------------------------------------------------------------------------
SELECT
    COUNT(*) AS non_positive_duration
FROM rides_raw
WHERE ended_at <= started_at;

SELECT
    ride_id,
    started_at,
    ended_at,
    TIMESTAMPDIFF(SECOND, started_at, ended_at) AS duration_seconds,
    source_month
FROM rides_raw
WHERE ended_at <= started_at
ORDER BY started_at;

SELECT
    MIN(TIMESTAMPDIFF(SECOND, started_at, ended_at) / 60.0) AS min_minutes,
    AVG(TIMESTAMPDIFF(SECOND, started_at, ended_at) / 60.0) AS avg_minutes,
    MAX(TIMESTAMPDIFF(SECOND, started_at, ended_at) / 60.0) AS max_minutes
FROM rides_raw;

SELECT
    SUM(TIMESTAMPDIFF(SECOND, started_at, ended_at) >  3600) AS over_1_hour,
    SUM(TIMESTAMPDIFF(SECOND, started_at, ended_at) > 21600) AS over_6_hours,
    SUM(TIMESTAMPDIFF(SECOND, started_at, ended_at) > 43200) AS over_12_hours,
    SUM(TIMESTAMPDIFF(SECOND, started_at, ended_at) > 86400) AS over_24_hours
FROM rides_raw;

SELECT
    ride_id,
    member_casual,
    rideable_type,
    started_at,
    ended_at,
    TIMESTAMPDIFF(SECOND, started_at, ended_at) / 3600.0 AS duration_hours,
    source_month
FROM rides_raw
ORDER BY duration_hours DESC
LIMIT 20;
