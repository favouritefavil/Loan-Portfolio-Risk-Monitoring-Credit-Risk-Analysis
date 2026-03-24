# 01 — Data Cleaning & Preparation

## Objective
Safely import the raw LendingClub CSV into PostgreSQL and produce a clean, typed analytical table ready for analysis.

## Queries Included
- Create TEXT staging table for safe CSV ingestion
- Import raw CSV using `COPY` command
- Inspect raw data and date format
- Convert `issue_d` from `Mon-YYYY` text to SQL `DATE`
- Create typed `loans_clean` analytical table
- Load and cast data from staging to clean table
- Filter to completed loans only (Fully Paid, Charged Off, Default)
- Remove records with missing `annual_inc`
- Validate and remove invalid DTI values (outside 0–60 range)
- Final row count validation

## Why It Matters
Raw lending data contains mixed formats, blank fields, and invalid values that break direct imports. A two-stage approach — TEXT staging then typed insertion — ensures no data is silently dropped or miscasted before analysis begins.

---
*For full project documentation, methodology, and insights see the main [README.md](../../README.md).*
