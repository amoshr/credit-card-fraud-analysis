DROP SCHEMA IF EXISTS finance_new;
CREATE SCHEMA finance_new
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE finance_new;


DROP TABLE cc_data;
CREATE TABLE cc_data (
    index_id        INT,
    trans_date      VARCHAR(20),
    trans_time      VARCHAR(10),
    merchant        VARCHAR(200),
    category        VARCHAR(100),
    amt             DECIMAL(10,2),
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    gender          CHAR(1),
    street          VARCHAR(200),
    city            VARCHAR(100),
    state           CHAR(2),
    zip             INT,
    lat             DECIMAL(10,6),
    long_coord      DECIMAL(10,6),
    city_pop        INT,
    job             VARCHAR(100),
    dob             VARCHAR(20),
    trans_num       VARCHAR(100),
    is_fraud            INT
);

SELECT DISTINCT is_fraud FROM cc_data;

SET SQL_SAFE_UPDATES = 0;

UPDATE cc_data
SET is_fraud = CASE
    WHEN is_fraud = 'Fraud' THEN 1
    WHEN is_fraud = 'Legitimate' THEN 0
END;

SELECT COUNT(*) FROM cc_data WHERE is_fraud = 1;
SELECT COUNT(*) FROM cc_data WHERE is_fraud = 0;

SET SQL_SAFE_UPDATES = 0;

UPDATE cc_data
SET trans_date = STR_TO_DATE(trans_date, '%d-%m-%Y');

ALTER TABLE cc_data MODIFY trans_date DATE;

UPDATE cc_data
SET dob = STR_TO_DATE(dob, '%d-%m-%Y');

ALTER TABLE cc_data MODIFY dob DATE;

UPDATE cc_data
SET trans_time = STR_TO_DATE(trans_time, '%H:%i');

ALTER TABLE cc_data MODIFY trans_time TIME;

SELECT index_id, trans_date, dob, trans_time
FROM cc_data
LIMIT 10;

ALTER TABLE cc_data ADD trans_hour INT;

UPDATE cc_data
SET trans_hour = HOUR(trans_time);

ALTER TABLE cc_data ADD trans_day VARCHAR(10);

UPDATE cc_data
SET trans_day = DAYNAME(trans_date);

ALTER TABLE cc_data ADD age INT;

UPDATE cc_data
SET age = TIMESTAMPDIFF(YEAR, dob, trans_date);

ALTER TABLE cc_data ADD is_weekend TINYINT;

UPDATE cc_data
SET is_weekend = CASE
    WHEN DAYOFWEEK(trans_date) IN (1,7) THEN 1
    ELSE 0
END;

ALTER TABLE cc_data ADD trans_month INT;

UPDATE cc_data
SET trans_month = MONTH(trans_date);

-- ===========================
--   Fraud Count Summary
-- ===========================

SELECT 
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS total_fraud,
    ROUND(SUM(is_fraud) / COUNT(*) * 100, 2) AS fraud_rate_percent
FROM cc_data;

-- ===========================
--   Top Fraud Merchants
-- ===========================

SELECT merchant, COUNT(*) AS fraud_cases
FROM cc_data
WHERE is_fraud = 1
GROUP BY merchant
ORDER BY fraud_cases DESC
LIMIT 10;

-- ===========================
--   Fraud by Category
-- ===========================

SELECT category, COUNT(*) AS fraud_cases
FROM cc_data
WHERE is_fraud = 1
GROUP BY category
ORDER BY fraud_cases DESC;

-- ===========================
--  Fraud by State
-- ===========================

SELECT state, COUNT(*) AS fraud_cases
FROM cc_data
WHERE is_fraud = 1
GROUP BY state
ORDER BY fraud_cases DESC;

-- ===========================
--   Fraud by Hour (using your new trans_hour)
-- ===========================

SELECT trans_hour, COUNT(*) AS fraud_cases
FROM cc_data
WHERE is_fraud = 1
GROUP BY trans_hour
ORDER BY trans_hour;

-- ===========================
--   Fraud by Day of Week
-- ===========================

SELECT trans_day, COUNT(*) AS fraud_cases
FROM cc_data
WHERE is_fraud = 1
GROUP BY trans_day
ORDER BY fraud_cases DESC;

-- ===========================
--   Fraud by Age Group
-- ===========================
SELECT 
    CASE 
        WHEN age < 25 THEN 'Under 25'
        WHEN age BETWEEN 25 AND 40 THEN '25-40'
        WHEN age BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS fraud_cases
FROM cc_data
WHERE is_fraud = 1
GROUP BY age_group
ORDER BY fraud_cases DESC;


























































 
 




















