# 02 — Feature Engineering

## Objective
Create derived variables that enable meaningful credit risk segmentation across the loan portfolio.

## Queries Included
- `default_flag` — Binary indicator (1 = defaulted, 0 = fully paid)
- `dti_risk_band` — DTI segmented into Low (0–20), Moderate (20–35), High (35–60)
- `income_group` — Annual income grouped into four tiers ($30K / $60K / $100K breakpoints)
- `emp_length_num` — Employment length converted from text to integer (0–10)
- `emp_length_group` — Employment tenure banded into five groups including Unknown
- Validation query to check for NULLs across all engineered columns

## Why It Matters
Raw variables like employment length (stored as text) and DTI (continuous) cannot be directly used for segment-level risk analysis. These features transform raw borrower data into risk-relevant categories that power all downstream queries and dashboard visuals.

---
*For full project documentation, methodology, and insights see the main [README.md](../../README.md).*
