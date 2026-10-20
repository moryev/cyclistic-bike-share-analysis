-- Cyclistic bike-share analysis
-- 05_analysis.sql
-- Purpose: reproduce the final analysis and the aggregated outputs used for Tableau.
-- Analysis window is applied consistently: 2025-10-01 <= ride_date < 2026-10-01.

USE cyclistic;

-- =============================================================================
-- A. CORE ANALYSIS
-- =============================================================================

-- 1. Overall ride volume and rider-type share
SELECT
    member_casual,
    COUNT(*) AS total_rides,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_rides
FROM rides_processed
WHERE ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
GROUP BY member_casual
ORDER BY member_casual;

-- 2. Ride duration by rider type (valid durations only)
SELECT
    member_casual,
    COUNT(*) AS valid_rides,
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_minutes,
    ROUND(MIN(ride_length_minutes), 2) AS min_ride_minutes,
    ROUND(MAX(ride_length_minutes), 2) AS max_ride_minutes
FROM rides_processed
WHERE duration_valid = 1
  AND ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
GROUP BY member_casual
ORDER BY member_casual;

-- 3. Monthly ride volume
SELECT
    ride_month,
    member_casual,
    COUNT(*) AS rides
FROM rides_processed
WHERE ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
GROUP BY
    ride_month,
    member_casual
ORDER BY
    ride_month,
    member_casual;

-- 4. Monthly average ride duration
SELECT
    ride_month,
    member_casual,
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_minutes
FROM rides_processed
WHERE duration_valid = 1
  AND ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
GROUP BY
    ride_month,
    member_casual
ORDER BY
    ride_month,
    member_casual;

-- 5. Ride volume by day of week
SELECT
    day_of_week_num,
    day_of_week,
    member_casual,
    COUNT(*) AS rides
FROM rides_processed
WHERE ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
GROUP BY
    day_of_week_num,
    day_of_week,
    member_casual
ORDER BY
    day_of_week_num,
    member_casual;

-- 6. Average duration by day of week
SELECT
    day_of_week_num,
    day_of_week,
    member_casual,
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_minutes
FROM rides_processed
WHERE duration_valid = 1
  AND ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
GROUP BY
    day_of_week_num,
    day_of_week,
    member_casual
ORDER BY
    day_of_week_num,
    member_casual;

-- 7. Average daily rides: weekday versus weekend
WITH daily_rides AS (
    SELECT
        ride_date,
        CASE
            WHEN is_weekend = 1 THEN 'Weekend'
            ELSE 'Weekday'
        END AS day_type,
        member_casual,
        COUNT(*) AS rides
    FROM rides_processed
    WHERE ride_date >= '2025-10-01'
      AND ride_date <  '2026-10-01'
    GROUP BY
        ride_date,
        day_type,
        member_casual
)
SELECT
    day_type,
    member_casual,
    ROUND(AVG(rides), 0) AS avg_rides_per_day
FROM daily_rides
GROUP BY
    day_type,
    member_casual
ORDER BY
    day_type,
    member_casual;

-- 8. Ride volume by hour of day
SELECT
    hour_of_day,
    member_casual,
    COUNT(*) AS rides
FROM rides_processed
WHERE ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
GROUP BY
    hour_of_day,
    member_casual
ORDER BY
    hour_of_day,
    member_casual;

-- 9. Bike type within each rider type
SELECT
    member_casual,
    rideable_type,
    COUNT(*) AS rides,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY member_casual),
        2
    ) AS percentage_within_rider_type
FROM rides_processed
WHERE ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
GROUP BY
    member_casual,
    rideable_type
ORDER BY
    member_casual,
    rideable_type;

-- 10. Station-data coverage by rider type
SELECT
    member_casual,
    COUNT(*) AS total_rides,
    SUM(start_station_name IS NOT NULL) AS rides_with_start_station,
    ROUND(
        100.0 * SUM(start_station_name IS NOT NULL) / COUNT(*),
        2
    ) AS start_station_coverage_pct,
    SUM(end_station_name IS NOT NULL) AS rides_with_end_station,
    ROUND(
        100.0 * SUM(end_station_name IS NOT NULL) / COUNT(*),
        2
    ) AS end_station_coverage_pct
FROM rides_processed
WHERE ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
GROUP BY member_casual
ORDER BY member_casual;

-- 11. Top 10 start stations for each rider type
WITH station_counts AS (
    SELECT
        member_casual,
        start_station_name,
        COUNT(*) AS rides
    FROM rides_processed
    WHERE ride_date >= '2025-10-01'
      AND ride_date <  '2026-10-01'
      AND start_station_name IS NOT NULL
    GROUP BY
        member_casual,
        start_station_name
),
ranked_stations AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY member_casual
            ORDER BY rides DESC
        ) AS station_rank
    FROM station_counts
)
SELECT
    member_casual,
    station_rank,
    start_station_name,
    rides
FROM ranked_stations
WHERE station_rank <= 10
ORDER BY
    member_casual,
    station_rank;

-- 12. Top 10 end stations for each rider type
WITH station_counts AS (
    SELECT
        member_casual,
        end_station_name,
        COUNT(*) AS rides
    FROM rides_processed
    WHERE ride_date >= '2025-10-01'
      AND ride_date <  '2026-10-01'
      AND end_station_name IS NOT NULL
    GROUP BY
        member_casual,
        end_station_name
),
ranked_stations AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY member_casual
            ORDER BY rides DESC
        ) AS station_rank
    FROM station_counts
)
SELECT
    member_casual,
    station_rank,
    end_station_name,
    rides
FROM ranked_stations
WHERE station_rank <= 10
ORDER BY
    member_casual,
    station_rank;

-- 13. Rider mix at high-traffic start stations
SELECT
    start_station_name,
    SUM(member_casual = 'member') AS member_rides,
    SUM(member_casual = 'casual') AS casual_rides,
    COUNT(*) AS total_rides,
    ROUND(
        100.0 * SUM(member_casual = 'casual') / COUNT(*),
        1
    ) AS casual_pct,
    ROUND(
        100.0 * SUM(member_casual = 'member') / COUNT(*),
        1
    ) AS member_pct
FROM rides_processed
WHERE ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
  AND start_station_name IS NOT NULL
GROUP BY start_station_name
HAVING COUNT(*) >= 1000
ORDER BY total_rides DESC
LIMIT 30;

-- =============================================================================
-- B. TABLEAU EXPORT QUERIES
-- Run each result separately and export the result grid to CSV.
-- =============================================================================

-- Tableau 01: monthly_rides.csv
SELECT
    ride_month,
    member_casual,
    COUNT(*) AS rides
FROM rides_processed
WHERE ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
GROUP BY
    ride_month,
    member_casual
ORDER BY
    ride_month,
    member_casual;

-- Tableau 02: weekday_weekend_rides.csv
WITH daily_rides AS (
    SELECT
        ride_date,
        CASE
            WHEN is_weekend = 1 THEN 'Weekend'
            ELSE 'Weekday'
        END AS day_type,
        member_casual,
        COUNT(*) AS rides
    FROM rides_processed
    WHERE ride_date >= '2025-10-01'
      AND ride_date <  '2026-10-01'
    GROUP BY
        ride_date,
        day_type,
        member_casual
)
SELECT
    day_type,
    member_casual,
    ROUND(AVG(rides), 0) AS avg_rides_per_day
FROM daily_rides
GROUP BY
    day_type,
    member_casual
ORDER BY
    day_type,
    member_casual;

-- Tableau 03: hourly_rides.csv
SELECT
    hour_of_day,
    member_casual,
    COUNT(*) AS rides
FROM rides_processed
WHERE ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
GROUP BY
    hour_of_day,
    member_casual
ORDER BY
    hour_of_day,
    member_casual;

-- Tableau 04: average_duration.csv
SELECT
    member_casual,
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_minutes
FROM rides_processed
WHERE duration_valid = 1
  AND ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
GROUP BY member_casual
ORDER BY member_casual;

-- Tableau 05: station_usage.csv
SELECT
    start_station_name,
    SUM(member_casual = 'member') AS member_rides,
    SUM(member_casual = 'casual') AS casual_rides,
    COUNT(*) AS total_rides,
    ROUND(
        100.0 * SUM(member_casual = 'casual') / COUNT(*),
        1
    ) AS casual_pct,
    ROUND(
        100.0 * SUM(member_casual = 'member') / COUNT(*),
        1
    ) AS member_pct
FROM rides_processed
WHERE ride_date >= '2025-10-01'
  AND ride_date <  '2026-10-01'
  AND start_station_name IS NOT NULL
GROUP BY start_station_name
HAVING COUNT(*) >= 1000
ORDER BY total_rides DESC
LIMIT 30;
