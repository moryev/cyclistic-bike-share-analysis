# Data

The raw trip data used in this project are **not stored in this repository** because the monthly CSV files are large and are already publicly available from the original source.

## Source

This case study uses public **Divvy historical trip data** as the data source for the fictional Cyclistic bike-share company used in the Google Data Analytics Professional Certificate capstone.

Raw data archive:

https://divvy-tripdata.s3.amazonaws.com/index.html

The analysis covers **October 2025 through September 2026** (12 monthly files).

## Local data layout

To reproduce the analysis, download and extract the corresponding monthly archives and place the CSV files locally in:

```text
data/
├── README.md
└── raw/
    ├── 202510-divvy-tripdata.csv
    ├── 202511-divvy-tripdata.csv
    ├── 202512-divvy-tripdata.csv
    ├── 202501-divvy-tripdata.csv
    ├── 202602-divvy-tripdata.csv
    ├── 202603-divvy-tripdata.csv
    ├── 202604-divvy-tripdata.csv
    ├── 202605-divvy-tripdata.csv
    ├── 202606-divvy-tripdata.csv
    ├── 202607-divvy-tripdata.csv
    ├── 202608-divvy-tripdata.csv
    └── 202609-divvy-tripdata.csv
```

> **January 2026 source-file note:** the `202601-divvy-tripdata.zip` archive used for this analysis contains a CSV named `202501-divvy-tripdata.csv`, although the records correspond to January 2026. The SQL import workflow therefore records its `source_month` as `2026-01-01`.

The import paths used by the project are documented in [`sql/02_import_data.sql`](../sql/02_import_data.sql). Replace the placeholder local path in that script with the location of this repository on your machine before running the imports.

## Dataset scope

The 12 source files contain approximately **6.17 million trip records**. The raw data include fields such as:

- ride ID and bike type;
- ride start and end timestamps;
- start and end station names and IDs;
- start and end coordinates;
- rider type (`member` or `casual`).

The raw files are preserved unchanged locally. Data-quality checks, deduplication, derived fields, and analytical filtering are performed in SQL rather than by editing the source CSVs.

## Repository policy

Only code, documentation, derived summary outputs, and visualizations are intended to be version-controlled. The raw monthly CSV files should remain local and should **not** be committed to GitHub.

See the [`sql/`](../sql/) directory for the complete reproducible processing and analysis workflow.
