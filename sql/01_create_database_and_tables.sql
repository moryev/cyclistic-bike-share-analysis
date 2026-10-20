-- Cyclistic bike-share analysis
-- 01_create_database_and_tables.sql
-- Purpose: create the MySQL database and raw staging table used by the project.
-- Tested with MySQL 8.x.

CREATE DATABASE IF NOT EXISTS cyclistic;
USE cyclistic;

DROP TABLE IF EXISTS rides_raw;

CREATE TABLE rides_raw (
    ride_id            VARCHAR(32),
    rideable_type      VARCHAR(32),
    started_at         DATETIME(3),
    ended_at           DATETIME(3),
    start_station_name VARCHAR(255),
    start_station_id   VARCHAR(64),
    end_station_name   VARCHAR(255),
    end_station_id     VARCHAR(64),
    start_lat          DOUBLE,
    start_lng          DOUBLE,
    end_lat            DOUBLE,
    end_lng            DOUBLE,
    member_casual      VARCHAR(16),
    source_month       DATE
) ENGINE = InnoDB;

DESCRIBE rides_raw;
