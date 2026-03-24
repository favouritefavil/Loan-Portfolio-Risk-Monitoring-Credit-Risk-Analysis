-- ============================================================
-- PROJECT: Loan Portfolio Risk Monitoring & Credit Risk Analysis
-- STAGE:   01 — Data Cleaning & Preparation
-- TOOL:    PostgreSQL
-- ============================================================


-- ------------------------------------------------------------
-- STEP 1: Create Raw Staging Table (TEXT format)
-- ------------------------------------------------------------

CREATE TABLE loans_text (
    loan_amnt      TEXT,
    term           TEXT,
    grade          TEXT,
    emp_length     TEXT,
    home_ownership TEXT,
    annual_inc     TEXT,
    issue_d        TEXT,
    loan_status    TEXT,
    purpose        TEXT,
    dti            TEXT
);


-- ------------------------------------------------------------
-- STEP 2: Import CSV into Staging Table
-- ------------------------------------------------------------

COPY loans_text
FROM 'C:/Users/user/Documents/Data Analysis/MY PROJECT/LENDING/EXTRACT/loans.csv'
DELIMITER ','
CSV HEADER;


-- ------------------------------------------------------------
-- STEP 3: Inspect Raw Data
-- ------------------------------------------------------------

SELECT * FROM loans_text LIMIT 20;

SELECT DISTINCT issue_d FROM loans_text LIMIT 20;


-- ------------------------------------------------------------
-- STEP 4: Add and Populate Clean Date Column
-- ------------------------------------------------------------

ALTER TABLE loans_text
ADD COLUMN issue_d_clean DATE;

UPDATE loans_text
SET issue_d_clean = TO_DATE(issue_d, 'Mon-YYYY');


-- ------------------------------------------------------------
-- STEP 5: Create Clean Analytical Table (Typed Schema)
-- ------------------------------------------------------------

CREATE TABLE loans_clean (
    loan_amnt      NUMERIC,
    term           TEXT,
    grade          TEXT,
    emp_length     TEXT,
    home_ownership TEXT,
    annual_inc     NUMERIC,
    issue_d        DATE,
    loan_status    TEXT,
    purpose        TEXT,
    dti            NUMERIC
);


-- ------------------------------------------------------------
-- STEP 6: Load Clean Data from Staging Table
-- ------------------------------------------------------------

INSERT INTO loans_clean (
    loan_amnt,
    term,
    grade,
    emp_length,
    home_ownership,
    annual_inc,
    issue_d,
    loan_status,
    purpose,
    dti
)
SELECT
    NULLIF(loan_amnt, '')::NUMERIC,
    term,
    grade,
    emp_length,
    home_ownership,
    NULLIF(annual_inc, '')::NUMERIC,
    issue_d_clean,
    loan_status,
    purpose,
    NULLIF(dti, '')::NUMERIC
FROM loans_text;


-- ------------------------------------------------------------
-- STEP 7: Filter to Completed Loans Only
-- ------------------------------------------------------------

DELETE FROM loans_clean
WHERE loan_status NOT IN ('Fully Paid', 'Charged Off', 'Default');


-- ------------------------------------------------------------
-- STEP 8: Remove Missing Income Records
-- ------------------------------------------------------------

DELETE FROM loans_clean
WHERE annual_inc IS NULL;


-- ------------------------------------------------------------
-- STEP 9: Validate and Clean DTI Values
-- ------------------------------------------------------------

-- Check range before cleaning
SELECT MIN(dti), MAX(dti) FROM loans_clean;

-- Remove invalid DTI values
DELETE FROM loans_clean
WHERE dti < 0
   OR dti > 60;

-- Confirm cleaned range
SELECT MIN(dti), MAX(dti) FROM loans_clean;


-- ------------------------------------------------------------
-- STEP 10: Final Row Count Validation
-- ------------------------------------------------------------

SELECT COUNT(*) AS total_records FROM loans_clean;
