-- ============================================================
-- PROJECT: Loan Portfolio Risk Monitoring & Credit Risk Analysis
-- STAGE:   05 — Loss Exposure Analysis
-- TOOL:    PostgreSQL
-- ============================================================
-- NOTE: Loss exposure is calculated as the sum of loan amounts
--       for all defaulted loans within each segment.
--       This is a gross loss proxy assuming 100% LGD (no recovery).
-- ============================================================


-- ------------------------------------------------------------
-- Loss Exposure by Credit Grade
-- ------------------------------------------------------------

SELECT
    grade,
    COUNT(*)                                                                AS total_loans,
    SUM(loan_amnt)                                                          AS total_exposure,
    SUM(default_flag)                                                       AS defaults,
    ROUND(SUM(default_flag)::NUMERIC / COUNT(*) * 100, 2)                  AS default_rate,
    ROUND(SUM(loan_amnt * default_flag)::NUMERIC / 1000000, 2)             AS loss_exposure_million
FROM loans_clean
GROUP BY grade
ORDER BY default_rate DESC;


-- ------------------------------------------------------------
-- Loss Exposure by DTI Risk Band
-- ------------------------------------------------------------

SELECT
    dti_risk_band,
    COUNT(*)                                                                AS total_loans,
    SUM(loan_amnt)                                                          AS total_exposure,
    SUM(default_flag)                                                       AS defaults,
    ROUND(SUM(default_flag)::NUMERIC / COUNT(*) * 100, 2)                  AS default_rate,
    ROUND(SUM(loan_amnt * default_flag)::NUMERIC / 1000000, 2)             AS loss_exposure_million
FROM loans_clean
GROUP BY dti_risk_band
ORDER BY default_rate DESC;


-- ------------------------------------------------------------
-- Loss Exposure by Loan Purpose
-- ------------------------------------------------------------

SELECT
    purpose,
    COUNT(*)                                                                AS total_loans,
    SUM(loan_amnt)                                                          AS total_exposure,
    SUM(default_flag)                                                       AS defaults,
    ROUND(SUM(default_flag)::NUMERIC / COUNT(*) * 100, 2)                  AS default_rate,
    ROUND(SUM(loan_amnt * default_flag)::NUMERIC / 1000000, 2)             AS loss_exposure_million
FROM loans_clean
GROUP BY purpose
ORDER BY loss_exposure_million DESC;
