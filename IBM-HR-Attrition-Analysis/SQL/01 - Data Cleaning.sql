-- ============================================================
-- Project : IBM HR Attrition Analysis
-- File    : 01 - Data Cleaning
-- Author  : [FOUZI MOHAMED ELAMIN DJAFFRI]
-- Date    : May 2026
-- Tool    : MySQL 8.0
-- Dataset : IBM HR Analytics (Kaggle) — 1470 employees
-- Steps   : Explore | Duplicates | Nulls | Types | Distinct | Outliers | Drop
-- ============================================================
 
 
-- ============================================================
-- STEP 1: Explore — understand the structure of the data
-- ============================================================
 
SELECT * FROM firstproject1.employee_attrition_cleaning;
describe employee_attrition_cleaning;
 
 
-- ============================================================
-- STEP 2: Check Duplicates
-- Result: no duplicates found in EmployeeNumber
-- Note: dataset originally had 2940 rows (imported twice)
--       fixed using CREATE TABLE temp_clean + DISTINCT *
-- ============================================================
 
SELECT EmployeeNumber, COUNT(*) 
FROM employee_attrition_cleaning
GROUP BY EmployeeNumber 
HAVING COUNT(*) > 1;
 
-- Fix duplicates using temp table
CREATE TABLE temp_clean AS
SELECT DISTINCT * FROM employee_attrition_cleaning;
 
TRUNCATE TABLE employee_attrition_cleaning;
 
INSERT INTO employee_attrition_cleaning
SELECT * FROM temp_clean;
 
DROP TABLE temp_clean;
 
-- Verify row count after fix (expected: 1470)
SELECT COUNT(*) FROM employee_attrition_cleaning;
 
 
-- ============================================================
-- STEP 3: Check Nulls
-- Helper: generate NULL check query using INFORMATION_SCHEMA
-- Result: no NULL values found in any column
-- ============================================================
 
-- Generate NULL check code automatically
SELECT CONCAT(
  'SUM(CASE WHEN ', COLUMN_NAME, ' IS NULL THEN 1 ELSE 0 END) AS null_', COLUMN_NAME, ','
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'employee_attrition_cleaning';
 
-- Fix encoding issue in Age column name
select COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='employee_attrition_cleaning' and COLUMN_NAME like '%age%';
 
ALTER TABLE employee_attrition_cleaning
RENAME COLUMN ï»¿Age TO age;
 
-- Check NULLs across all columns
select
SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age, 
SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END) AS null_Attrition,
SUM(CASE WHEN BusinessTravel IS NULL THEN 1 ELSE 0 END) AS null_BusinessTravel,
SUM(CASE WHEN DailyRate IS NULL THEN 1 ELSE 0 END) AS null_DailyRate,
SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS null_Department,
SUM(CASE WHEN DistanceFromHome IS NULL THEN 1 ELSE 0 END) AS null_DistanceFromHome,
SUM(CASE WHEN Education IS NULL THEN 1 ELSE 0 END) AS null_Education,
SUM(CASE WHEN EducationField IS NULL THEN 1 ELSE 0 END) AS null_EducationField,
SUM(CASE WHEN EmployeeCount IS NULL THEN 1 ELSE 0 END) AS null_EmployeeCount,
SUM(CASE WHEN EmployeeNumber IS NULL THEN 1 ELSE 0 END) AS null_EmployeeNumber,
SUM(CASE WHEN EnvironmentSatisfaction IS NULL THEN 1 ELSE 0 END) AS null_EnvironmentSatisfaction,
SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS null_Gender,
SUM(CASE WHEN HourlyRate IS NULL THEN 1 ELSE 0 END) AS null_HourlyRate,
SUM(CASE WHEN JobInvolvement IS NULL THEN 1 ELSE 0 END) AS null_JobInvolvement,
SUM(CASE WHEN JobLevel IS NULL THEN 1 ELSE 0 END) AS null_JobLevel,
SUM(CASE WHEN JobRole IS NULL THEN 1 ELSE 0 END) AS null_JobRole,
SUM(CASE WHEN JobSatisfaction IS NULL THEN 1 ELSE 0 END) AS null_JobSatisfaction,
SUM(CASE WHEN MaritalStatus IS NULL THEN 1 ELSE 0 END) AS null_MaritalStatus,
SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS null_MonthlyIncome,
SUM(CASE WHEN MonthlyRate IS NULL THEN 1 ELSE 0 END) AS null_MonthlyRate,
SUM(CASE WHEN NumCompaniesWorked IS NULL THEN 1 ELSE 0 END) AS null_NumCompaniesWorked,
SUM(CASE WHEN Over18 IS NULL THEN 1 ELSE 0 END) AS null_Over18,
SUM(CASE WHEN OverTime IS NULL THEN 1 ELSE 0 END) AS null_OverTime,
SUM(CASE WHEN PercentSalaryHike IS NULL THEN 1 ELSE 0 END) AS null_PercentSalaryHike,
SUM(CASE WHEN PerformanceRating IS NULL THEN 1 ELSE 0 END) AS null_PerformanceRating,
SUM(CASE WHEN RelationshipSatisfaction IS NULL THEN 1 ELSE 0 END) AS null_RelationshipSatisfaction,
SUM(CASE WHEN StandardHours IS NULL THEN 1 ELSE 0 END) AS null_StandardHours,
SUM(CASE WHEN StockOptionLevel IS NULL THEN 1 ELSE 0 END) AS null_StockOptionLevel,
SUM(CASE WHEN TotalWorkingYears IS NULL THEN 1 ELSE 0 END) AS null_TotalWorkingYears,
SUM(CASE WHEN TrainingTimesLastYear IS NULL THEN 1 ELSE 0 END) AS null_TrainingTimesLastYear,
SUM(CASE WHEN WorkLifeBalance IS NULL THEN 1 ELSE 0 END) AS null_WorkLifeBalance,
SUM(CASE WHEN YearsAtCompany IS NULL THEN 1 ELSE 0 END) AS null_YearsAtCompany,
SUM(CASE WHEN YearsInCurrentRole IS NULL THEN 1 ELSE 0 END) AS null_YearsInCurrentRole,
SUM(CASE WHEN YearsSinceLastPromotion IS NULL THEN 1 ELSE 0 END) AS null_YearsSinceLastPromotion,
SUM(CASE WHEN YearsWithCurrManager IS NULL THEN 1 ELSE 0 END) AS null_YearsWithCurrManager
FROM employee_attrition_cleaning;
 
 
-- ============================================================
-- STEP 4: Check Data Types
-- Result: all columns are int or text — no conversion needed
-- ============================================================
 
select COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='employee_attrition_cleaning';
 
 
-- ============================================================
-- STEP 5: Check Distinct Values (text columns only)
-- Goal: detect spelling errors or inconsistent values
-- Result: all text columns have clean consistent values
-- ============================================================
 
-- Check Attrition values
select Attrition 
FROM employee_attrition_cleaning
where Attrition like '%NO';
 
-- Check BusinessTravel values manually
SELECT DISTINCT(BusinessTravel)
FROM employee_attrition_cleaning;
 
SELECT distinct BusinessTravel,
CASE WHEN BusinessTravel = 'Non-Travel' THEN 1 ELSE 0 END AS is_correct
FROM employee_attrition_cleaning;
 
SELECT distinct BusinessTravel,
CASE WHEN BusinessTravel = 'Travel_Rarely' THEN 1 ELSE 0 END AS is_correct
FROM employee_attrition_cleaning;
 
SELECT distinct BusinessTravel,
CASE WHEN BusinessTravel = 'Travel_Frequently' THEN 1 ELSE 0 END AS is_correct
FROM employee_attrition_cleaning;
 
-- Stored Procedure to check distinct values for any text column
-- Usage: CALL check_distinct1('column_name', 'expected_value');
DELIMITER $$
CREATE PROCEDURE check_distinct1(
    IN col_name VARCHAR(100),
    IN col_value VARCHAR(100)
)
BEGIN
    SET @sql = CONCAT(
        'SELECT DISTINCT ', col_name, ', ',
        'CASE WHEN ', col_name, ' = ? THEN 1 ELSE 0 END AS is_correct ',
        'FROM employee_attrition_cleaning'
    );
    SET @val = col_value;
    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @val;
    DEALLOCATE PREPARE stmt;
END $$
DELIMITER ;
 
-- Example usage
call check_distinct1('OverTime','Yes');
 
 
-- ============================================================
-- STEP 6: Check Outliers (numeric columns only)
-- Helper: generate MAX/MIN query using INFORMATION_SCHEMA
-- Result: all values within logical range — no outliers found
-- Age: 18-60 | MonthlyIncome: 1009-19999 | all others normal
-- ============================================================
 
-- Generate MAX/MIN code automatically
SELECT CONCAT(
  'max(' , COLUMN_NAME , ')' , ' ' , 'min(' , COLUMN_NAME , ')')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'employee_attrition_cleaning' AND DATA_TYPE='int';
 
-- Check MIN and MAX for all numeric columns
SELECT 
max(age) ,min(age),
max(DailyRate) , min(DailyRate),
max(DistanceFromHome), min(DistanceFromHome),
max(Education) ,min(Education),
max(EmployeeCount), min(EmployeeCount),
max(EmployeeNumber) ,min(EmployeeNumber),
max(EnvironmentSatisfaction), min(EnvironmentSatisfaction),
max(HourlyRate) ,min(HourlyRate),
max(JobInvolvement) ,min(JobInvolvement),
max(JobLevel) ,min(JobLevel),
max(JobSatisfaction), min(JobSatisfaction),
max(MonthlyIncome), min(MonthlyIncome),
max(MonthlyRate) ,min(MonthlyRate),
max(NumCompaniesWorked) ,min(NumCompaniesWorked),
max(PercentSalaryHike) ,min(PercentSalaryHike),
max(PerformanceRating) ,min(PerformanceRating),
max(RelationshipSatisfaction) ,min(RelationshipSatisfaction),
max(StandardHours) ,min(StandardHours),
max(StockOptionLevel) ,min(StockOptionLevel),
max(TotalWorkingYears) ,min(TotalWorkingYears),
max(TrainingTimesLastYear), min(TrainingTimesLastYear),
max(WorkLifeBalance) ,min(WorkLifeBalance),
max(YearsAtCompany) ,min(YearsAtCompany),
max(YearsInCurrentRole) ,min(YearsInCurrentRole),
max(YearsSinceLastPromotion) ,min(YearsSinceLastPromotion),
max(YearsWithCurrManager), min(YearsWithCurrManager)
FROM employee_attrition;
 
 
-- ============================================================
-- STEP 7: Drop Useless Columns
-- Over18: all values = 'Y' — no analytical value
-- EmployeeCount: all values = 1 — no analytical value
-- ============================================================
 
alter table employee_attrition_cleaning
drop column over18;
 
alter table employee_attrition_cleaning
drop column EmployeeCount;
 
-- Final row count verification (expected: 1470)
select count(*)
FROM employee_attrition_cleaning;




