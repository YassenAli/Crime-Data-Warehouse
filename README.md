# Crime Data Warehouse Project

## Project Overview
This repository contains the SSIS-based ETL solution for loading, transforming, and analyzing the Los Angeles crime dataset (2020–present). The goal is to build a dimensional data warehouse (star schema) with multiple fact tables and dimensions, and to demonstrate key performance indicators (KPIs) extraction and analytics.

## Dataset
- **Source:** Crime Data from 2020 to Present (Catalog: https://catalog.data.gov/dataset/crime-data-from-2020-to-present)
- **Kaggle:** https://www.kaggle.com/datasets/shubhrarana/crimedatasetla
- **Files:**
  - `CSVNormalized/AreaCodeDescription.csv`
  - `CSVNormalized/CrimeCodeDescription.csv`
  - `CSVNormalized/PremiseCodeDescription.csv`
  - `CSVNormalized/StatusCodeDescription.csv`
  - `CSVNormalized/WeaponCodeDescription.csv`
  - `CSVNormalized/CrimeDataNormalized.csv`

## Architecture & Design
1. **Staging Layer:** Raw CSV files loaded verbatim into `stg.*` tables using SSIS Data Flow Tasks.
2. **Dimensional Model:** Star schema with:
   - Dimensions: Date, Time, Area, CrimeCode, Weapon, Premise, Status, Victim
   - Fact Tables: CrimeIncident, CrimeArrest, MonthlySnapshot
3. **ETL Process:** SSIS packages to extract from staging, perform lookups, cast/clean data, and load into `dwh.*` tables.
4. **Analytics:** T-SQL queries for trends, KPIs, and insights (e.g., top crime types, arrest rates, reporting lag).
5. **Visualization:** Power BI dashboard connected to the `dwh` database for interactive reports.

## Prerequisites
- Microsoft SQL Server 2019 or later
- SQL Server Integration Services (SSIS)
- Visual Studio 2019/2022 with SSIS extension
- Power BI Desktop (for dashboard)

## Project Structure
```
/CrimeStagingLoad
  Load_Staging.dtsx           # Load CSVs into staging tables
  Scripts/                    # DDL scripts for staging
/DWHLoad
  Load_Dimensions.dtsx        # Transform & load dimensions
  Load_Facts.dtsx             # Transform & load fact tables
  Scripts/                    # DDL scripts for DWH
/Scripts
  create_staging.sql          # CREATE TABLE stg.CrimeDataNormalized
  create_dwh_model.sql        # Dimensional model DDL
/Reports
  SSIS_Screenshots/           # Screenshots of Data Flow & Control Flow
/Dashboard
  PowerBI_CrimeAnalytics.pbix # Power BI report file
README.md
```

## ETL Workflow
1. **Staging Load**
   - Run `Load_Staging.dtsx` to import each CSV into `stg.*` tables.
2. **Dimension Load**
   - Execute `Load_Dimensions.dtsx`:
     - Lookup code descriptions, assign surrogate keys.
     - Populate dimension tables.
3. **Fact Load**
   - Execute `Load_Facts.dtsx`:
     - Clean dates, times, numeric fields.
     - Perform lookups to dimension keys.
     - Populate fact tables.
4. **Deployment & Scheduling**
   - Deploy SSIS packages to SSIS Catalog.
   - Schedule nightly runs via SQL Server Agent.

## Usage
1. Create and restore the `CrimeDB` database.
2. Execute the DDL scripts in `/Scripts` in order.
3. Open the SSIS project in Visual Studio and update connection managers to point to your SQL Server instance.
4. Run the packages in the sequence: `Load_Staging.dtsx` → `Load_Dimensions.dtsx` → `Load_Facts.dtsx`.
5. Open the Power BI report in `/Dashboard` and point it at the `CrimeDB.dwh` model.
