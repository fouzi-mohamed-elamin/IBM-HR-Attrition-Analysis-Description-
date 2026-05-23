 -- ===========================================================
 -- Project : IBM HR Attrition Analysis
-- File    : 02 - Exploratory Analysis
-- Author  : [FOUZI MOHAMED ELAMIN DJAFFRI]
-- Date    : May 2026
-- Tool    : MySQL 8.0
-- Dataset : IBM HR Analytics (Kaggle) — 1470 employees
-- Goal    : Identify key factors causing employee attrition
-- Result  : 237 attrited (16%) | 1233 stayed (84%)
-- ============================================================
-- Q1: What is the overall attrition rate?
-- Result: 16% attrited | 84% stayed
-- ============================================================
 
SELECT 'Yes' AS attrition,
COUNT(*) AS Total,
COUNT(*) * 100 / (SELECT COUNT(*) FROM analyse_employee_attrition) AS Percentage
FROM analyse_employee_attrition
WHERE Attrition = 'Yes'
UNION
SELECT 'No',
COUNT(*),
COUNT(*) * 100 / (SELECT COUNT(*) FROM analyse_employee_attrition)
FROM analyse_employee_attrition
WHERE Attrition = 'No';
 
 
-- ============================================================
-- Q2, Q3, Q4: Who leaves? — Age, Gender, Marital Status
-- Result: Age 26-35 | Male | Single employees leave most
-- Note: percentage is relative to 237 attrited employees
-- ============================================================
 
SELECT * FROM ( SELECT age , COUNT(*) AS  'NUMBER OF attrited FROM COMPANY','AGE' AS 'DATA TYPE'
FROM analyse_employee_attrition
WHERE attrition = 'Yes'
GROUP BY age
ORDER BY COUNT(*) DESC) AS GOOD
UNION 
SELECT * FROM (SELECT gender AS GENDER_CALC, COUNT(*) AS attrited,'GENDER' AS ALBEL
FROM analyse_employee_attrition
WHERE attrition = 'Yes'
GROUP BY gender
ORDER BY COUNT(*) DESC) AS GOO
UNION 
SELECT * FROM(  SELECT MaritalStatus , COUNT(*) AS attrited , 'MARIEDSTATE' AS ALB
FROM analyse_employee_attrition
WHERE attrition = 'Yes'
GROUP BY MaritalStatus
ORDER BY COUNT(*) DESC) AS GII;
 
 
-- ============================================================
-- Q5: Does low salary cause attrition?
-- min income=1009$ | max income=19999$ | avg income=6502$
-- Above avg (>6502$): 52 attrited / 442 stayed → 10.5% rate
-- Below avg (<6502$): 185 attrited / 792 stayed → 18.9% rate
-- Result: employees with lower salary leave almost twice as much
-- ============================================================
 
SELECT count(*)
FROM analyse_employee_attrition
where MonthlyIncome between 6502 and 19999  and Attrition='No';
 
 
-- ============================================================
-- Q6: Does overtime cause attrition?
-- No Overtime: 110/1054 → 10.4% attrition rate
-- Overtime:    127/416  → 30.5% attrition rate
-- Result: overtime employees leave 3x more
-- ============================================================
 
SELECT count(OverTime),count(*) * 100 / 1054 persentage, 'no overtime'
FROM analyse_employee_attrition
WHERE OverTime='No' AND Attrition='Yes'
UNION
SELECT count(OverTime),count(*) * 100 / 416, 'overtime'
FROM analyse_employee_attrition
WHERE OverTime='Yes' AND Attrition='Yes';
 
 
-- ============================================================
-- Q7: Does business travel cause attrition?
-- Non-Travel: 8% | Travel Rarely: 15% | Travel Frequently: 24.9%
-- Result: more travel = higher attrition rate
-- ============================================================
 
select BusinessTravel,count(BusinessTravel) num_travel,'attrited' state 
,    COUNT(*) * 100 / (SELECT COUNT(*) FROM analyse_employee_attrition b 
                      WHERE b.BusinessTravel = a.BusinessTravel) AS percentage
FROM analyse_employee_attrition a
WHERE Attrition='Yes'
GROUP BY BusinessTravel
UNION 
select BusinessTravel,count(BusinessTravel),'no Attrition' state,
    COUNT(*) * 100 / (SELECT COUNT(*) FROM analyse_employee_attrition b 
                      WHERE b.BusinessTravel = a.BusinessTravel) AS percentage
FROM analyse_employee_attrition a
WHERE  attrition='No'
GROUP BY  BusinessTravel;
 
 
-- ============================================================
-- Q8: Does job satisfaction affect attrition?
-- Scale: 1=Low | 2=Medium | 3=High | 4=Very High
-- Result: no strong correlation — all levels similar rate ~16%
-- ============================================================
 
SELECT 
    JobSatisfaction,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS attrited,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*) AS attrition_rate
FROM analyse_employee_attrition
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;
 
SELECT * from( select JobSatisfaction,
COUNT(*) AS attrition,
COUNT(*) * 100 / SUM(COUNT(*)) OVER() AS percentage,'attrited' as state
FROM analyse_employee_attrition
WHERE Attrition = 'Yes'
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction) as tab1
UNION
SELECT * from(select  JobSatisfaction,
COUNT(*),
COUNT(*) * 100 / SUM(COUNT(*)) OVER() AS percentage,'no attrition' as state
FROM analyse_employee_attrition
WHERE Attrition = 'No'
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction) as tab2;
 
 
-- ============================================================
-- Q9: Does work life balance affect attrition?
-- Scale: 1=Bad | 2=Good | 3=Better | 4=Best
-- Result: Level 1 (Bad) has 31.2% attrition rate — highest risk
-- ============================================================
 
SELECT * from( select WorkLifeBalance,
COUNT(*) AS attrtion,
COUNT(*) * 100 / SUM(COUNT(*)) OVER() AS percentage,'attrited' as state
FROM analyse_employee_attrition
WHERE Attrition = 'Yes'
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance) as tab1
UNION
SELECT * from(select  WorkLifeBalance,
COUNT(*),
COUNT(*) * 100 / SUM(COUNT(*)) OVER() AS percentage,'no attrition' as state
FROM analyse_employee_attrition
WHERE Attrition = 'No'
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance) as tab2;
 
 
-- ============================================================
-- STORED PROCEDURE: attrtion_analyse
-- Used in Q9, Q10, Q11, Q14, Q15
-- Accepts any column name → returns full attrition analysis
-- Usage: CALL attrtion_analyse('column_name');
-- ============================================================
 
DELIMITER $$
CREATE PROCEDURE attrtion_analyse (IN col_name VARCHAR(250))
BEGIN
SET @sql = CONCAT('
WITH fct AS (
    SELECT ', col_name, ',
    SUM(CASE WHEN Attrition=''Yes'' THEN 1 ELSE 0 END) AS attrited,
    SUM(CASE WHEN Attrition=''Yes'' THEN 1 ELSE 0 END) * 100 / 
        (SELECT COUNT(*) FROM analyse_employee_attrition WHERE Attrition=''Yes'') AS pct_of_total_attrited,
    SUM(CASE WHEN Attrition=''Yes'' THEN 1 ELSE 0 END) * 100 / COUNT(*) AS attrition_rate
    FROM analyse_employee_attrition
    GROUP BY ', col_name, '),
ct2 AS (
    SELECT ', col_name, ',
    SUM(CASE WHEN Attrition=''No'' THEN 1 ELSE 0 END) AS stayed,
    SUM(CASE WHEN Attrition=''No'' THEN 1 ELSE 0 END) * 100 / 
        (SELECT COUNT(*) FROM analyse_employee_attrition WHERE Attrition=''No'') AS pct_of_total_stayed,
    SUM(CASE WHEN Attrition=''No'' THEN 1 ELSE 0 END) * 100 / COUNT(*) AS retention_rate,
    COUNT(*) AS total_employees
    FROM analyse_employee_attrition
    GROUP BY ', col_name, ')
SELECT 
    fct.', col_name, ',
    fct.attrited,
    fct.pct_of_total_attrited,
    fct.attrition_rate,
    ct2.stayed,
    ct2.pct_of_total_stayed,
    ct2.retention_rate,
    ct2.total_employees
FROM fct
JOIN ct2 ON fct.', col_name, ' = ct2.', col_name, '
ORDER BY attrition_rate DESC'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
END $$
DELIMITER ;
 
 
-- ============================================================
-- Q10: Which department has highest attrition rate?
-- Sales: 20.6% | HR: 19% | R&D: 13.8%
-- Result: Sales department has highest attrition
-- ============================================================
 
CALL attrtion_analyse('Department');
 
 
-- ============================================================
-- Q11: Which job role has highest attrition rate?
-- Sales Representative: 39.7% — highest risk
-- Manager: 4.9% — lowest risk
-- ============================================================
 
CALL attrtion_analyse('JobRole');
 
 
-- ============================================================
-- Q12: Does lack of promotion cause attrition?
-- Result: recently promoted (0 years) have highest COUNT
-- but rate increases after 7+ years without promotion
-- ============================================================
 
SELECT 
CASE WHEN YearsSinceLastPromotion=0 THEN '0 years'
     WHEN YearsSinceLastPromotion BETWEEN 1 AND 3 THEN '1-3 years'
     WHEN YearsSinceLastPromotion BETWEEN 4 AND 9 THEN '4-9 years'
     ELSE '10-15 years'
END AS promo_group,
COUNT(*),
COUNT(*)*100/SUM(COUNT(*)) OVER() AS percentage
FROM analyse_employee_attrition
WHERE Attrition='Yes'
GROUP BY promo_group;
 
 
-- ============================================================
-- Q13: Do newer employees leave more than experienced ones?
-- Result: 1-5 years tenure = 61.6% of all attrition — critical period
-- ============================================================
 
SELECT 
CASE WHEN YearsAtCompany=0 THEN '0 years'
     WHEN YearsAtCompany BETWEEN 1 AND 5 THEN '1-5 years'
     WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10 years'
     WHEN YearsAtCompany BETWEEN 11 AND 15 THEN '11-15 years'
     WHEN YearsAtCompany BETWEEN 16 AND 20 THEN '16-20 years'
     ELSE '21-27 years'
END AS tenure_group,
COUNT(*),
COUNT(*)*100/SUM(COUNT(*)) OVER() AS percentage
FROM analyse_employee_attrition
WHERE Attrition='Yes'
GROUP BY tenure_group;
 
 
-- ============================================================
-- Q14: Does lack of training cause attrition?
-- 0 trainings: 27.8% rate | 6 trainings: 9.2% rate
-- Result: more training = less attrition
-- ============================================================
 
CALL attrtion_analyse('TrainingTimesLastYear');
 
 
-- ============================================================
-- Q15: Is low performance related to attrition?
-- Rating 3: 16.1% | Rating 4: 16.4%
-- Result: no significant correlation found
-- ============================================================
 
CALL attrtion_analyse('PerformanceRating');