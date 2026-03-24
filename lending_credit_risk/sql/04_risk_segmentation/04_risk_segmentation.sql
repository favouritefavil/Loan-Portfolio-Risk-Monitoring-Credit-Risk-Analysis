-- ============================================================
-- PROJECT: Loan Portfolio Risk Monitoring & Credit Risk Analysis
-- STAGE:   04 — Risk Segmentation
-- TOOL:    PostgreSQL
-- ============================================================


-- ------------------------------------------------------------
-- Default Rate by Credit Grade
-- ------------------------------------------------------------

SELECT
    grade,
    COUNT(*)                                                            AS loans,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)                  AS portfolio_share_percent,
    SUM(loan_amnt)                                                      AS total_exposure,
    SUM(default_flag)                                                   AS defaults,
    ROUND(SUM(default_flag)::NUMERIC / COUNT(*) * 100, 2)              AS default_rate
FROM loans_clean
GROUP BY grade
ORDER BY grade;


-- ------------------------------------------------------------
-- Default Rate by DTI Risk Band
-- ------------------------------------------------------------

SELECT
    dti_risk_band,
    COUNT(*)                                                            AS total_loans,
    SUM(loan_amnt)                                                      AS total_exposure,
    SUM(default_flag)                                                   AS defaulted,
    ROUND(SUM(default_flag)::NUMERIC / COUNT(*) * 100, 2)              AS default_rate
FROM loans_clean
GROUP BY dti_risk_band
ORDER BY dti_risk_band;


-- ------------------------------------------------------------
-- Default Rate by Income Group
-- ------------------------------------------------------------

SELECT
    income_group,
    COUNT(*)                                                            AS loans,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)                  AS portfolio_share_percent,
    SUM(loan_amnt)                                                      AS total_exposure,
    SUM(default_flag)                                                   AS defaults,
    ROUND(SUM(default_flag)::NUMERIC / COUNT(*) * 100, 2)              AS default_rate
FROM loans_clean
GROUP BY income_group
ORDER BY loans DESC;


-- ------------------------------------------------------------
-- Default Rate by Employment Length Group
-- ------------------------------------------------------------

SELECT
    emp_length_group,
    SUM(loan_amnt)                                                      AS total_exposure,
    COUNT(*)                                                            AS loans,
    ROUND(SUM(default_flag)::NUMERIC / COUNT(*) * 100, 2)              AS default_rate
FROM loans_clean
GROUP BY emp_length_group
ORDER BY default_rate DESC;


-- ------------------------------------------------------------
-- Default Rate by Loan Purpose
-- ------------------------------------------------------------

SELECT
    purpose,
    COUNT(*)                                                            AS loans,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)                  AS portfolio_share_percent,
    SUM(loan_amnt)                                                      AS total_exposure,
    SUM(default_flag)                                                   AS defaults,
    ROUND(SUM(default_flag)::NUMERIC / COUNT(*) * 100, 2)              AS default_rate
FROM loans_clean
GROUP BY purpose
ORDER BY loans DESC;


-- ------------------------------------------------------------
-- Total Exposure by DTI Risk Band
-- ------------------------------------------------------------

SELECT
    dti_risk_band,
    SUM(loan_amnt)                                                      AS total_exposure
FROM loans_clean
GROUP BY dti_risk_band
ORDER BY total_exposure;
