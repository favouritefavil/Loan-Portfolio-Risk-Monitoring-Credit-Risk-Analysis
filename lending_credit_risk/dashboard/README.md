# Dashboard

Contains the Power BI dashboard used for portfolio risk monitoring and loss analysis.

## File

| File | Description |
|---|---|
| `Credit_Risk_Dashboard.pbix` | Power BI dashboard — 3 pages: Portfolio Overview, Risk Driver Analysis, Loss Exposure Analysis |

## Pages

1. **Portfolio Overview** — KPI banner, loan distribution by purpose, volume and exposure trends, borrower profile by income and employment
2. **Risk Driver Analysis** — Default rates by grade, DTI, income group, loan purpose, and trend over time
3. **Loss Exposure Analysis** — Expected loss by grade, DTI, income group, loan purpose, and trend over time

## Requirements

- Power BI Desktop (free download from Microsoft)
- The `.pbix` file connects to the cleaned PostgreSQL dataset (`loans_clean` table)
- Screenshots of all three pages are available in the `/images` folder
