-- Cyclistic bike-share analysis
-- 02_import_data.sql
-- Purpose: load the 12 monthly Divvy CSV files into rides_raw while preserving
--          the original raw files outside MySQL.
-- Analysis period: October 2025 through September 2026.
--
-- IMPORTANT:
--   1. Replace C:/REPLACE_WITH_PATH/data/raw/... with your local path.
--   2. local_infile must be enabled in both MySQL Server and the client connection.
--   3. The source CSVs use Windows line endings, so '\r\n' is used deliberately.
--   4. January 2026 has a source-file naming inconsistency: the 202601 archive
--      contains a CSV named 202501-divvy-tripdata.csv. Its source_month is still
--      correctly recorded as 2026-01-01.

USE cyclistic;

SHOW VARIABLES LIKE 'local_infile';

-- Optional when restarting the import from scratch:
-- TRUNCATE TABLE rides_raw;

-- -----------------------------------------------------------------------------
-- Reusable LOAD DATA pattern
-- Each block maps empty CSV fields to NULL and records the month of the source file.
-- -----------------------------------------------------------------------------

-- October 2025
LOAD DATA LOCAL INFILE 'C:/REPLACE_WITH_PATH/data/raw/202510-divvy-tripdata.csv'
INTO TABLE rides_raw
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    @ride_id, @rideable_type, @started_at, @ended_at,
    @start_station_name, @start_station_id,
    @end_station_name, @end_station_id,
    @start_lat, @start_lng, @end_lat, @end_lng,
    @member_casual
)
SET
    ride_id            = NULLIF(@ride_id, ''),
    rideable_type      = NULLIF(@rideable_type, ''),
    started_at         = NULLIF(@started_at, ''),
    ended_at           = NULLIF(@ended_at, ''),
    start_station_name = NULLIF(@start_station_name, ''),
    start_station_id   = NULLIF(@start_station_id, ''),
    end_station_name   = NULLIF(@end_station_name, ''),
    end_station_id     = NULLIF(@end_station_id, ''),
    start_lat          = NULLIF(@start_lat, ''),
    start_lng          = NULLIF(@start_lng, ''),
    end_lat            = NULLIF(@end_lat, ''),
    end_lng            = NULLIF(@end_lng, ''),
    member_casual      = NULLIF(TRIM(BOTH '\r' FROM @member_casual), ''),
    source_month       = '2025-10-01';

-- November 2025
LOAD DATA LOCAL INFILE 'C:/REPLACE_WITH_PATH/data/raw/202511-divvy-tripdata.csv'
INTO TABLE rides_raw
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@ride_id, @rideable_type, @started_at, @ended_at,
 @start_station_name, @start_station_id, @end_station_name, @end_station_id,
 @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = NULLIF(@ride_id, ''), rideable_type = NULLIF(@rideable_type, ''),
    started_at = NULLIF(@started_at, ''), ended_at = NULLIF(@ended_at, ''),
    start_station_name = NULLIF(@start_station_name, ''), start_station_id = NULLIF(@start_station_id, ''),
    end_station_name = NULLIF(@end_station_name, ''), end_station_id = NULLIF(@end_station_id, ''),
    start_lat = NULLIF(@start_lat, ''), start_lng = NULLIF(@start_lng, ''),
    end_lat = NULLIF(@end_lat, ''), end_lng = NULLIF(@end_lng, ''),
    member_casual = NULLIF(TRIM(BOTH '\r' FROM @member_casual), ''),
    source_month = '2025-11-01';

-- December 2025
LOAD DATA LOCAL INFILE 'C:/REPLACE_WITH_PATH/data/raw/202512-divvy-tripdata.csv'
INTO TABLE rides_raw
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@ride_id, @rideable_type, @started_at, @ended_at,
 @start_station_name, @start_station_id, @end_station_name, @end_station_id,
 @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = NULLIF(@ride_id, ''), rideable_type = NULLIF(@rideable_type, ''),
    started_at = NULLIF(@started_at, ''), ended_at = NULLIF(@ended_at, ''),
    start_station_name = NULLIF(@start_station_name, ''), start_station_id = NULLIF(@start_station_id, ''),
    end_station_name = NULLIF(@end_station_name, ''), end_station_id = NULLIF(@end_station_id, ''),
    start_lat = NULLIF(@start_lat, ''), start_lng = NULLIF(@start_lng, ''),
    end_lat = NULLIF(@end_lat, ''), end_lng = NULLIF(@end_lng, ''),
    member_casual = NULLIF(TRIM(BOTH '\r' FROM @member_casual), ''),
    source_month = '2025-12-01';

-- January 2026 (official source archive contains the misnamed 202501 CSV)
LOAD DATA LOCAL INFILE 'C:/REPLACE_WITH_PATH/data/raw/202501-divvy-tripdata.csv'
INTO TABLE rides_raw
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@ride_id, @rideable_type, @started_at, @ended_at,
 @start_station_name, @start_station_id, @end_station_name, @end_station_id,
 @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = NULLIF(@ride_id, ''), rideable_type = NULLIF(@rideable_type, ''),
    started_at = NULLIF(@started_at, ''), ended_at = NULLIF(@ended_at, ''),
    start_station_name = NULLIF(@start_station_name, ''), start_station_id = NULLIF(@start_station_id, ''),
    end_station_name = NULLIF(@end_station_name, ''), end_station_id = NULLIF(@end_station_id, ''),
    start_lat = NULLIF(@start_lat, ''), start_lng = NULLIF(@start_lng, ''),
    end_lat = NULLIF(@end_lat, ''), end_lng = NULLIF(@end_lng, ''),
    member_casual = NULLIF(TRIM(BOTH '\r' FROM @member_casual), ''),
    source_month = '2026-01-01';

-- February 2026
LOAD DATA LOCAL INFILE 'C:/REPLACE_WITH_PATH/data/raw/202602-divvy-tripdata.csv'
INTO TABLE rides_raw
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@ride_id, @rideable_type, @started_at, @ended_at,
 @start_station_name, @start_station_id, @end_station_name, @end_station_id,
 @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = NULLIF(@ride_id, ''), rideable_type = NULLIF(@rideable_type, ''),
    started_at = NULLIF(@started_at, ''), ended_at = NULLIF(@ended_at, ''),
    start_station_name = NULLIF(@start_station_name, ''), start_station_id = NULLIF(@start_station_id, ''),
    end_station_name = NULLIF(@end_station_name, ''), end_station_id = NULLIF(@end_station_id, ''),
    start_lat = NULLIF(@start_lat, ''), start_lng = NULLIF(@start_lng, ''),
    end_lat = NULLIF(@end_lat, ''), end_lng = NULLIF(@end_lng, ''),
    member_casual = NULLIF(TRIM(BOTH '\r' FROM @member_casual), ''),
    source_month = '2026-02-01';

-- March 2026
LOAD DATA LOCAL INFILE 'C:/REPLACE_WITH_PATH/data/raw/202603-divvy-tripdata.csv'
INTO TABLE rides_raw
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@ride_id, @rideable_type, @started_at, @ended_at,
 @start_station_name, @start_station_id, @end_station_name, @end_station_id,
 @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = NULLIF(@ride_id, ''), rideable_type = NULLIF(@rideable_type, ''),
    started_at = NULLIF(@started_at, ''), ended_at = NULLIF(@ended_at, ''),
    start_station_name = NULLIF(@start_station_name, ''), start_station_id = NULLIF(@start_station_id, ''),
    end_station_name = NULLIF(@end_station_name, ''), end_station_id = NULLIF(@end_station_id, ''),
    start_lat = NULLIF(@start_lat, ''), start_lng = NULLIF(@start_lng, ''),
    end_lat = NULLIF(@end_lat, ''), end_lng = NULLIF(@end_lng, ''),
    member_casual = NULLIF(TRIM(BOTH '\r' FROM @member_casual), ''),
    source_month = '2026-03-01';

-- April 2026
LOAD DATA LOCAL INFILE 'C:/REPLACE_WITH_PATH/data/raw/202604-divvy-tripdata.csv'
INTO TABLE rides_raw
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@ride_id, @rideable_type, @started_at, @ended_at,
 @start_station_name, @start_station_id, @end_station_name, @end_station_id,
 @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = NULLIF(@ride_id, ''), rideable_type = NULLIF(@rideable_type, ''),
    started_at = NULLIF(@started_at, ''), ended_at = NULLIF(@ended_at, ''),
    start_station_name = NULLIF(@start_station_name, ''), start_station_id = NULLIF(@start_station_id, ''),
    end_station_name = NULLIF(@end_station_name, ''), end_station_id = NULLIF(@end_station_id, ''),
    start_lat = NULLIF(@start_lat, ''), start_lng = NULLIF(@start_lng, ''),
    end_lat = NULLIF(@end_lat, ''), end_lng = NULLIF(@end_lng, ''),
    member_casual = NULLIF(TRIM(BOTH '\r' FROM @member_casual), ''),
    source_month = '2026-04-01';

-- May 2026
LOAD DATA LOCAL INFILE 'C:/REPLACE_WITH_PATH/data/raw/202605-divvy-tripdata.csv'
INTO TABLE rides_raw
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@ride_id, @rideable_type, @started_at, @ended_at,
 @start_station_name, @start_station_id, @end_station_name, @end_station_id,
 @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = NULLIF(@ride_id, ''), rideable_type = NULLIF(@rideable_type, ''),
    started_at = NULLIF(@started_at, ''), ended_at = NULLIF(@ended_at, ''),
    start_station_name = NULLIF(@start_station_name, ''), start_station_id = NULLIF(@start_station_id, ''),
    end_station_name = NULLIF(@end_station_name, ''), end_station_id = NULLIF(@end_station_id, ''),
    start_lat = NULLIF(@start_lat, ''), start_lng = NULLIF(@start_lng, ''),
    end_lat = NULLIF(@end_lat, ''), end_lng = NULLIF(@end_lng, ''),
    member_casual = NULLIF(TRIM(BOTH '\r' FROM @member_casual), ''),
    source_month = '2026-05-01';

-- June 2026
LOAD DATA LOCAL INFILE 'C:/REPLACE_WITH_PATH/data/raw/202606-divvy-tripdata.csv'
INTO TABLE rides_raw
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@ride_id, @rideable_type, @started_at, @ended_at,
 @start_station_name, @start_station_id, @end_station_name, @end_station_id,
 @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = NULLIF(@ride_id, ''), rideable_type = NULLIF(@rideable_type, ''),
    started_at = NULLIF(@started_at, ''), ended_at = NULLIF(@ended_at, ''),
    start_station_name = NULLIF(@start_station_name, ''), start_station_id = NULLIF(@start_station_id, ''),
    end_station_name = NULLIF(@end_station_name, ''), end_station_id = NULLIF(@end_station_id, ''),
    start_lat = NULLIF(@start_lat, ''), start_lng = NULLIF(@start_lng, ''),
    end_lat = NULLIF(@end_lat, ''), end_lng = NULLIF(@end_lng, ''),
    member_casual = NULLIF(TRIM(BOTH '\r' FROM @member_casual), ''),
    source_month = '2026-06-01';

-- July 2026
LOAD DATA LOCAL INFILE 'C:/REPLACE_WITH_PATH/data/raw/202607-divvy-tripdata.csv'
INTO TABLE rides_raw
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@ride_id, @rideable_type, @started_at, @ended_at,
 @start_station_name, @start_station_id, @end_station_name, @end_station_id,
 @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = NULLIF(@ride_id, ''), rideable_type = NULLIF(@rideable_type, ''),
    started_at = NULLIF(@started_at, ''), ended_at = NULLIF(@ended_at, ''),
    start_station_name = NULLIF(@start_station_name, ''), start_station_id = NULLIF(@start_station_id, ''),
    end_station_name = NULLIF(@end_station_name, ''), end_station_id = NULLIF(@end_station_id, ''),
    start_lat = NULLIF(@start_lat, ''), start_lng = NULLIF(@start_lng, ''),
    end_lat = NULLIF(@end_lat, ''), end_lng = NULLIF(@end_lng, ''),
    member_casual = NULLIF(TRIM(BOTH '\r' FROM @member_casual), ''),
    source_month = '2026-07-01';

-- August 2026
LOAD DATA LOCAL INFILE 'C:/REPLACE_WITH_PATH/data/raw/202608-divvy-tripdata.csv'
INTO TABLE rides_raw
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@ride_id, @rideable_type, @started_at, @ended_at,
 @start_station_name, @start_station_id, @end_station_name, @end_station_id,
 @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = NULLIF(@ride_id, ''), rideable_type = NULLIF(@rideable_type, ''),
    started_at = NULLIF(@started_at, ''), ended_at = NULLIF(@ended_at, ''),
    start_station_name = NULLIF(@start_station_name, ''), start_station_id = NULLIF(@start_station_id, ''),
    end_station_name = NULLIF(@end_station_name, ''), end_station_id = NULLIF(@end_station_id, ''),
    start_lat = NULLIF(@start_lat, ''), start_lng = NULLIF(@start_lng, ''),
    end_lat = NULLIF(@end_lat, ''), end_lng = NULLIF(@end_lng, ''),
    member_casual = NULLIF(TRIM(BOTH '\r' FROM @member_casual), ''),
    source_month = '2026-08-01';

-- September 2026
LOAD DATA LOCAL INFILE 'C:/REPLACE_WITH_PATH/data/raw/202609-divvy-tripdata.csv'
INTO TABLE rides_raw
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@ride_id, @rideable_type, @started_at, @ended_at,
 @start_station_name, @start_station_id, @end_station_name, @end_station_id,
 @start_lat, @start_lng, @end_lat, @end_lng, @member_casual)
SET ride_id = NULLIF(@ride_id, ''), rideable_type = NULLIF(@rideable_type, ''),
    started_at = NULLIF(@started_at, ''), ended_at = NULLIF(@ended_at, ''),
    start_station_name = NULLIF(@start_station_name, ''), start_station_id = NULLIF(@start_station_id, ''),
    end_station_name = NULLIF(@end_station_name, ''), end_station_id = NULLIF(@end_station_id, ''),
    start_lat = NULLIF(@start_lat, ''), start_lng = NULLIF(@start_lng, ''),
    end_lat = NULLIF(@end_lat, ''), end_lng = NULLIF(@end_lng, ''),
    member_casual = NULLIF(TRIM(BOTH '\r' FROM @member_casual), ''),
    source_month = '2026-09-01';

-- Import verification: one row per source month plus the total row count.
SELECT
    source_month,
    COUNT(*) AS rides
FROM rides_raw
GROUP BY source_month
ORDER BY source_month;

SELECT COUNT(*) AS total_rows
FROM rides_raw;
