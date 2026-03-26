hi# Loan Portfolio Risk Monitoring & Credit Risk Analysis

![Project Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Tool](https://img.shields.io/badge/Tool-PostgreSQL-blue)
![Dashboard](https://img.shields.io/badge/Dashboard-Power%20BI-yellow)
![Dataset](https://img.shields.io/badge/Dataset-LendingClub-lightgrey)

---


## Table of Contents

- [Introduction](#introduction)
- [Business Problem](#business-problem)
- [Dataset Overview](#dataset-overview)
- [Data Cleaning & Preparation](#data-cleaning--preparation)
- [Feature Engineering](#feature-engineering)
- [Analysis Approach](#analysis-approach)
- [Dashboard Overview](#dashboard-overview)
- [Dashboard Preview](#dashboard-preview)
- [Key Insights](#key-insights)
- [Business Recommendations](#business-recommendations)
- [Limitations](#limitations)
- [Conclusion](#conclusion)
- [Repository Structure](#repository-structure)

---

## Introduction

This project delivers a complete, end-to-end credit risk analysis of a consumer lending portfolio using the LendingClub dataset. It simulates the work of a **credit risk analyst responsible for portfolio monitoring and risk reporting** covering data preparation, SQL-based segmentation, loss exposure analysis, and interactive dashboard visualisation.

The project was built using **PostgreSQL** for data engineering and analysis, and **Power BI** for dashboard development and portfolio monitoring.

---

## Business Problem

Lending institutions face a constant challenge: growing their loan book while keeping credit risk under control. Without structured monitoring, portfolios accumulate high-risk borrowers and concentration in vulnerable segments often before the problem is visible in headline metrics.

This project addresses four core business questions:

- What is the **overall risk level** of the loan portfolio?
- Which **borrower segments** carry the highest default rates?
- Where is the **largest financial loss** actually concentrated?
- What **actions** should risk and portfolio teams take?

## 🚨 Key Findings

- 1 in 5 loans defaulted (≈20% default rate)
- Total portfolio exposure: **$19B**
- Estimated loss exposure: **$4B**
- **Grade C is the largest loss driver ($1.3B)** not the highest-risk grade
- **Debt consolidation accounts for 58% of loans and $2.7B in losses**

> This project analyses where risk actually comes from, not just who defaults, but where the money is lost.

---

---

## Dataset Overview

**Source:** LendingClub peer-to-peer lending platform  
**Records:** 1,343,260 completed loans (post-cleaning)  
**Scope:** Loan originations from 2007 to 2018

| Variable | Description |
|---|---|
| `loan_amnt` | Amount of loan issued |
| `annual_inc` | Borrower annual income |
| `grade` | Credit grade assigned by lender |
| `dti` | Debt-to-income ratio |
| `emp_length` | Employment history |
| `purpose` | Stated loan purpose |
| `term` | Loan repayment duration |
| `home_ownership` | Borrower housing status |
| `loan_status` | Final repayment outcome |

Ten variables were deliberately selected from the full dataset (150+ fields) based on their direct relevance to credit risk assessment and borrower characterisation.

---

## Data Cleaning & Preparation

A **two-stage import strategy** was used to safely load the raw CSV into PostgreSQL:

**Stage 1 — Text Staging Table**  
All columns were imported as TEXT to prevent type errors during initial ingestion. This is standard practice when working with raw lending datasets that contain mixed formats, blank fields, and inconsistent values.

**Stage 2 — Clean Analytical Table**  
Data was transferred to a typed analytical table after validation, with blank strings converted to NULL before casting, and dates standardised from `Mon-YYYY` format to SQL DATE.

**Key cleaning steps:**

- Filtered to completed loans only: Fully Paid, Charged Off, and Default
- Removed 33 records with missing annual income
- Removed records with DTI values outside the valid range of 0–60 (flagged as data entry errors)
- Validated DTI min/max post-cleaning

**Final dataset: 1,343,260 clean records ready for analysis.**

---

## Feature Engineering

Four derived variables were created to enable meaningful risk segmentation:

| Feature | Type | Description |
|---|---|---|
| `default_flag` | Binary | 1 = Charged Off or Default, 0 = Fully Paid |
| `dti_risk` | Categorical | Low (0–20), Moderate (20–35), High (35–60) |
| `income_group` | Categorical | Low, Lower Middle, Upper Middle, High income |
| `emp_length_num` | Numeric | Employment tenure mapped from text to integer (0–10) |

**Design rationale:**

- **DTI bands** align with institutional lending thresholds, the 35% upper boundary reflects the qualified mortgage DTI limit used in regulated lending
- **Income segments** use breakpoints at $30K, $60K, and $100K to capture meaningful repayment capacity differences
- **Employment length** was later grouped into five bands (Unknown, <1 year, 1–5 years, 6–9 years, 10+ years) after identifying that unmapped records defaulting at 26.92% required explicit handling as a risk flag

---

## Analysis Approach

The analysis was structured across **eleven SQL queries** covering three analytical themes:

**Portfolio Overview**
- Total loans, total exposure, and average loan size
- Portfolio-wide default rate

**Risk Segmentation**
- Default rate by credit grade
- Default rate by DTI risk band
- Default rate by income group
- Default rate by employment length group
- Default rate by loan purpose
- Total exposure by DTI risk band

**loss exposure Analysis**
- loss exposure by credit grade
- loss exposure by DTI risk band
- loss exposure by loan purpose

loss exposure was calculated as the sum of loan amounts for all defaulted loans within each segment, expressed in millions. This serves as a gross loss proxy, an upper-bound estimate assuming 100% loss given default with no recovery.

---

## Dashboard Overview

The Power BI dashboard is structured across three pages, each addressing a distinct analytical question. All pages share a persistent KPI banner displaying five headline metrics:

> **1.3M Loans | $19bn Total Exposure | $14K Average Loan | 20% Default Rate | $4bn Loss Exposure**

Six interactive filters grade, purpose, income group, DTI risk band, and year allow segment-level drilling across all visuals.

---

### Page 1: Portfolio Overview

**Purpose:** Establish the scale, composition, and borrower profile of the portfolio.

| Visual | What It Shows |
|---|---|
| Loan Distribution by Purpose (bar) | All 14 loan purposes ordered by volume debt consolidation dominates at 779K loans (58%) |
| Loan Volume & Exposure Over Time (dual-axis) | Annual origination bars with total exposure line shows the full 2008–2018 growth and decline cycle |
| Loan Distribution by Income Group (bar) | Lower Middle income leads at 539K; Upper Middle at 477K together 76% of the portfolio |
| Loan Distribution by Employment Length (bar) | 1–5 years (482K) and 10+ years (442K) are the dominant tenure groups |

**Key takeaway:** This is a middle-income, employed borrower portfolio, heavily concentrated in debt consolidation, that peaked in 2015 and has contracted since.

---

### Page 2: Risk Driver Analysis

**Purpose:** Identify which borrower characteristics drive the most default risk.

| Visual | What It Shows |
|---|---|
| Default Rate by Credit Grade (column) | G-to-A gradient: 50% → 6%, a 44-point spread credit grade is the dominant risk predictor |
| Default Rate by DTI Risk Band (bar) | High (31%) vs Low (17%) nearly double across the leverage spectrum |
| Default Rate by Income Group (bar) | Ordered highest-to-lowest: Low income (24%) → High income (16%) |
| Default Rate by Top 5 Loan Purpose (bar) | Small business leads at 30%; renewable energy 24%; moving 23% |
| Default Rate Trend Over Time (line) | ~20% average, spiking to ~27–28% in 2015–2016, declining sharply to 2018 |

**Key takeaway:** Credit grade is the sharpest risk dividing line. DTI and income reinforce the picture higher leverage and lower income consistently predict higher default, but nothing separates borrowers as clearly as the assigned grade.

---

### Page 3: Loss Exposure Analysis

**Purpose:** Quantify where financial damage is actually occurring in dollar terms.

| Visual | What It Shows |
|---|---|
| Loss Exposure by Credit Grade (column) | Grade C leads at $1.3bn not Grade G, which is last at $0.1bn |
| Loss Exposure by DTI Risk Band (bar) | Low DTI leads at $2.1bn despite the lowest default rate |
| Loss Exposure by Income Group (bar) | Upper Middle leads at $1.7bn; Low income last at $0.1bn |
| Loss Exposure by Top 6 Purpose (bar) | Debt consolidation at $2.7bn more than 3× the next category |
| Loss Exposure Trend Over Time (line) | Mirrors the default rate spike, confirming the 2015–2016 event in financial terms |

**Key takeaway:** Volume drives dollar losses, not default rate alone. The segments with the highest default rates (Grades G, F, E; High DTI) generate the smallest absolute losses because their loan counts are small. Grade C, debt consolidation, and the Low-DTI band are where the real money is at risk.

---

## Dashboard Preview

### Page 1 — Portfolio Overview
<img width="1267" height="720" alt="Portfolio Overview" src="https://github.com/user-attachments/assets/66741471-5b4d-4d5a-8060-eb2f5dc86f93" />



---

### Page 2 — Risk Driver Analysis
<img width="1266" height="719" alt="Risk Driver Analysis" src="https://github.com/user-attachments/assets/1b11a199-6725-4af3-b444-cfd5a50e08a4" />

---

### Page 3 — Loss Exposure Analysis
<img width="1269" height="720" alt="Loss Exposure Analysis" src="https://github.com/user-attachments/assets/6c61ca34-8588-46bf-9bf5-c68600b89db1" />


---

## Key Insights

**1. The portfolio carries $4bn in gross loss exposure on a 20% default rate.**  
At $19bn in total exposure, a 1-percentage-point change in the default rate is worth approximately $194M in losses. Segment-level monitoring is not optional at this scale,it is a loss prevention strategy.

**2. Credit grade is the strongest single risk predictor by a wide margin.**  
The 44-point spread from Grade A (6%) to Grade G (50%) is larger than the combined spread of all other segmentation variables. No other single characteristic separates borrowers as clearly as the assigned credit grade.

**3. The highest default rate segments are not the largest loss generators.**  
Grade G defaults at 50% but generates just $0.1bn in losses. Grade C defaults at 22% but generates $1.3bn, the most of any grade. The same pattern holds for DTI and income. Rate risk and dollar loss risk are different problems requiring different management responses.

**4. Debt consolidation is the portfolio's single largest financial risk.**  
One loan purpose, 58% of the portfolio, generates $2.7bn in loss exposurees. That is more than three times the next largest category. The portfolio's financial health is structurally dependent on how well debt consolidation borrowers perform.

**5. The 2015–2016 period was a genuine stress event.**  
Both the default rate trend and the loss exposure trend spike in the same window. This was not a data artefact. Default rates reached approximately 27–28% before declining through 2018, confirming a period of material portfolio deterioration.

**6. Low-DTI borrowers generate more dollar loss than High-DTI borrowers.**  
The Low-DTI band holds 60% of all loans and $11.5bn in exposure. At a 17% default rate, it still generates $2.1bn in losses ,more than the High-DTI band at $0.2bn. Volume at scale turns even below-average default rates into large absolute losses.

---

## Business Recommendations

### Credit Policy

- **Restrict Grades E, F, and G:** require lower loan amounts, shorter terms, and mandatory income verification. Grade D or below combined with High DTI should trigger mandatory review before approval.
- **Apply DTI limits at origination:**  applications above DTI 35 should require a compensating factor (stronger grade or reduced loan amount) to proceed.
- **Treat missing employment data as a risk flag:**  the Unknown employment group defaults at 26.92%, seven points above the portfolio average. Verified employment should be required above a minimum loan threshold.
- **Introduce income-adjusted loan sizing:**  link maximum approved amounts to a multiple of verified annual income, particularly for borrowers under $30K.

### Portfolio Strategy

- **Reduce debt consolidation concentration:**  set an internal cap at 50% for any single loan purpose and actively encourage growth in lower-risk categories such as credit card refinancing (16.92%) and car loans (14.69%).
- **Shift origination toward Grades A and B:**  increase their combined portfolio share from 46.69% to a target of 55% over two years. The loss exposure reduction outweighs the yield cost at the margin.
- **Monitor the 2014–2016 vintage:**  loans originated during the peak stress period that have not yet fully resolved should be tracked separately for residual risk.

### Risk Monitoring

- **Build a grade migration matrix:** tracking borrower movement between grades month-on-month provides early warning of deteriorating credit quality before defaults appear.
- **Set segment-level alert thresholds:** including: any grade default rate rising more than 3 percentage points quarter-on-quarter; debt consolidation exceeding 23%; High-DTI band exceeding 35%.
- **Report loss exposure monthly:** connecting the dashboard to a monthly-refreshed data source converts it from a retrospective tool into a live monitoring system.

### Data Improvements

- **Mandate employment verification:**  eliminating the Unknown employment category removes a risk blind spot that currently covers 77,527 loans.
- **Add delinquency history fields:** 30-day and 60-day past due counts would enable early warning analysis, which is currently impossible with outcome-only data.
- **Include interest rate and loan term:**  Adding these would add material analytical depth to future iterations of this analysis.

---

## Limitations

**1. No forward-looking probability of default model.**  
Default rates are observed historical frequencies, not modelled predictions. They cannot be applied directly as credit scores or pricing inputs for new originations without additional modelling work.

**2. Closed historical period (2007–2018).**  
The dataset reflects a specific economic cycle. Default patterns including the 2015–2016 stress event, may not represent current or future portfolio behaviour.

**3. No payment history data.**  
Only final loan outcomes are recorded. The absence of intermediate delinquency data prevents early warning analysis and limits the framework to outcome-based risk measurement.

**4. Scoped variable selection.**  
10 of 150+ available variables were used. Excluded fields, including number of open credit lines, and public derogatory records, may carry additional predictive power not captured here.

**5. Self-reported borrower data.**  
Income, employment length, and loan purpose are self-reported and unverified. Overstated income in particular could cause the analysis to understate true default risk in lower income segments.

---

## Conclusion

This project produced a complete credit risk analysis of a 1.3 million loan consumer portfolio, covering data preparation, SQL-based risk segmentation, loss exposure quantification, and interactive dashboard monitoring.

The analysis surfaces three findings with direct business implications. First, credit grade is the dominant risk predictor and should anchor all credit policy decisions. Second, dollar loss risk is determined by volume and exposure, not default rate alone, Grade C and debt consolidation are the segments that matter most financially, not the extreme-grade tail. Third, the portfolio carries significant concentration risk in a single loan purpose that a stress scenario could expose rapidly.

The methodology:  separating rate risk from loss risk, tracking loss exposure by segment, and building an interactive monitoring framework is directly transferable to any consumer lending portfolio.

> *In a $19 billion portfolio, knowing which segments to watch is not a reporting exercise, it is a loss prevention strategy.*

---

## Repository Structure

```
lending-credit-risk-analysis/
│
├── sql/
│   ├── 01_data_cleaning.sql          # Raw import, staging table, type conversion
│   ├── 02_feature_engineering.sql    # DTI bands, income groups, default flag
│   ├── 03_portfolio_overview.sql     # Total loans, exposure, default rate
│   ├── 04_risk_segmentation.sql      # Default rates by grade, DTI, income, purpose
│   └── 05_loss_exposure.sql          # loss exposure by grade, DTI, purpose
│
├── images/
│   ├── Portfolio_Overview.png        # Dashboard Page 1 screenshot
│   ├── Risk_Driver_Analysis.png      # Dashboard Page 2 screenshot
│   └── Loss_Exposure_Analysis.png    # Dashboard Page 3 screenshot
│
└── README.md                         # Full project documentation
```

---

## 💡 Key Takeaway

> High default rates do not always drive the largest losses, portfolio exposure and borrower volume are the true drivers of financial risk.

---

*Project by Favour Chegwe - Data Analyst*  
*Tools: PostgreSQL · Power BI · DAX*  
*Dataset: LendingClub (public)*
