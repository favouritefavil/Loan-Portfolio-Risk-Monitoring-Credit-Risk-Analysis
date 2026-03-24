-- ============================================================
-- PROJECT: Loan Portfolio Risk Monitoring & Credit Risk Analysis
-- STAGE:   03 — Portfolio Overview
-- TOOL:    PostgreSQL
-- ============================================================


-- ------------------------------------------------------------
-- Total Loans, Total Exposure & Average Loan Size
-- ------------------------------------------------------------

SELECT
    COUNT(*)          AS total_loans,
    SUM(loan_amnt)    AS total_exposure,
    AVG(loan_amnt)    AS avg_loan_size
FROM loans_clean;


-- ------------------------------------------------------------
-- Overall Portfolio Default Rate
-- ------------------------------------------------------------

SELECT
    COUNT(*)                                                    AS total_loans,
    SUM(default_flag)                                           AS defaulted,
    ROUND(SUM(default_flag)::NUMERIC / COUNT(*) * 100, 2)      AS default_rate
FROM loans_clean;
