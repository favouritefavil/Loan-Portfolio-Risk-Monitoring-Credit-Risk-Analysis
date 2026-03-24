-- ============================================================
-- PROJECT: Loan Portfolio Risk Monitoring & Credit Risk Analysis
-- STAGE:   02 — Feature Engineering
-- TOOL:    PostgreSQL
-- ============================================================


-- ------------------------------------------------------------
-- FEATURE 1: Default Flag (Binary)
-- ------------------------------------------------------------

ALTER TABLE loans_clean
ADD COLUMN default_flag INT;

UPDATE loans_clean
SET default_flag =
CASE
    WHEN loan_status IN ('Charged Off', 'Default') THEN 1
    ELSE 0
END;


-- ------------------------------------------------------------
-- FEATURE 2: DTI Risk Band (Categorical)
-- ------------------------------------------------------------

ALTER TABLE loans_clean
ADD COLUMN dti_risk_band TEXT;

UPDATE loans_clean
SET dti_risk_band =
CASE
    WHEN dti <= 20              THEN 'Low'
    WHEN dti > 20 AND dti <= 35 THEN 'Moderate'
    WHEN dti > 35 AND dti <= 60 THEN 'High'
END;


-- ------------------------------------------------------------
-- FEATURE 3: Income Group (Categorical)
-- ------------------------------------------------------------

ALTER TABLE loans_clean
ADD COLUMN income_group TEXT;

UPDATE loans_clean
SET income_group =
CASE
    WHEN annual_inc < 30000                            THEN 'Low income'
    WHEN annual_inc >= 30000 AND annual_inc <= 60000   THEN 'Lower middle'
    WHEN annual_inc > 60000  AND annual_inc <= 100000  THEN 'Upper middle'
    WHEN annual_inc > 100000                           THEN 'High income'
END;


-- ------------------------------------------------------------
-- FEATURE 4: Employment Length (Numeric)
-- ------------------------------------------------------------

ALTER TABLE loans_clean
ADD COLUMN emp_length_num INT;

UPDATE loans_clean
SET emp_length_num =
CASE
    WHEN emp_length = '< 1 year'  THEN 0
    WHEN emp_length = '1 year'    THEN 1
    WHEN emp_length = '2 years'   THEN 2
    WHEN emp_length = '3 years'   THEN 3
    WHEN emp_length = '4 years'   THEN 4
    WHEN emp_length = '5 years'   THEN 5
    WHEN emp_length = '6 years'   THEN 6
    WHEN emp_length = '7 years'   THEN 7
    WHEN emp_length = '8 years'   THEN 8
    WHEN emp_length = '9 years'   THEN 9
    WHEN emp_length = '10+ years' THEN 10
END;


-- ------------------------------------------------------------
-- FEATURE 5: Employment Length Group (Categorical Bands)
-- ------------------------------------------------------------

ALTER TABLE loans_clean
ADD COLUMN emp_length_group TEXT;

UPDATE loans_clean
SET emp_length_group =
CASE
    WHEN emp_length_num IS NULL             THEN 'Unknown'
    WHEN emp_length_num = 0                 THEN '< 1 year'
    WHEN emp_length_num BETWEEN 1 AND 5     THEN '1-5 Yrs'
    WHEN emp_length_num BETWEEN 6 AND 9     THEN '6-9 Yrs'
    WHEN emp_length_num = 10                THEN '10+ years'
END;


-- ------------------------------------------------------------
-- VALIDATION: Check for NULLs in engineered features
-- ------------------------------------------------------------

SELECT
    COUNT(*) FILTER (WHERE default_flag   IS NULL) AS null_default_flag,
    COUNT(*) FILTER (WHERE dti_risk_band  IS NULL) AS null_dti_risk,
    COUNT(*) FILTER (WHERE income_group   IS NULL) AS null_income_group,
    COUNT(*) FILTER (WHERE emp_length_num IS NULL) AS null_emp_length_num,
    COUNT(*) FILTER (WHERE emp_length_group IS NULL) AS null_emp_length_group
FROM loans_clean;
