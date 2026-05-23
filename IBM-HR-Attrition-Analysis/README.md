# IBM HR Employee Attrition Analysis

## Overview
SQL-based analysis of IBM HR data to identify the key factors driving employee attrition. The dataset contains 1,470 employees, of which 237 (16%) left the company.

---

## Tools
- **MySQL 8.0** — data cleaning & analysis
- **MySQL Workbench** — query execution

---

## Dataset
- **Source:** [IBM HR Analytics Employee Attrition & Performance — Kaggle](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)
- **Rows:** 1,470 employees
- **Columns:** 35 features

---

## Project Structure

```
IBM-HR-Attrition-Analysis/
├── README.md
├── sql/
│   ├── 01_data_cleaning.sql
│   └── 02_analysis.sql
└── results/
    ├── 01_attrition_overview.png
    ├── 02_demographics.png
    ├── 03_salary_impact.png
    ├── 04_overtime_impact.png
    ├── 05_travel_impact.png
    ├── 06_department_analysis.png
    ├── 07_jobrole_analysis.png
    ├── 08_worklife_balance.png
    ├── 09_training_impact.png
    └── 10_tenure_impact.png
```

---

## Data Cleaning Summary

| Step | Action | Result |
|------|--------|--------|
| Explore | Reviewed structure and data types | 35 columns, int & text only |
| Duplicates | Used DISTINCT * via temp table | Fixed 2940 → 1470 rows |
| Nulls | Checked all 35 columns | No NULL values found |
| Data Types | Reviewed all column types | No conversion needed |
| Distinct Values | Checked all text columns | No spelling errors found |
| Outliers | Checked MIN/MAX for all numeric columns | All values within logical range |
| Drop Columns | Removed useless columns | Dropped `Over18` and `EmployeeCount` |

---

## Analysis — 15 Questions

### Descriptive: Who leaves?

| # | Question | Key Finding |
|---|----------|-------------|
| 1 | Overall attrition rate | **16%** attrited (237 of 1470) |
| 2 | Which age group leaves most? | Age **26-35** has highest attrition |
| 3 | Which gender leaves most? | **Male** employees leave more (150 vs 87) |
| 4 | Which marital status leaves most? | **Single** employees leave most (120) |

### Diagnostic: Why do they leave?

| # | Question | Key Finding |
|---|----------|-------------|
| 5 | Does low salary cause attrition? | Below avg salary: **18.9%** vs above avg: **10.5%** |
| 6 | Does overtime cause attrition? | Overtime employees leave **3x more** (30.5% vs 10.4%) |
| 7 | Does travel frequency cause attrition? | Travel Frequently: **24.9%** vs Non-Travel: **8%** |
| 8 | Does job satisfaction affect attrition? | No strong correlation — all levels ~16% |
| 9 | Does work-life balance affect attrition? | Level 1 (Bad): **31.2%** attrition rate |
| 10 | Which department has highest attrition? | **Sales**: 20.6% — highest rate |
| 11 | Which job role has highest attrition? | **Sales Representative**: 39.7% |
| 12 | Does lack of promotion cause attrition? | No clear pattern found |
| 13 | Do newer employees leave more? | **1-5 years** tenure = 61.6% of all attrition |
| 14 | Does lack of training cause attrition? | 0 trainings: **27.8%** vs 6 trainings: **9.2%** |
| 15 | Is low performance related to attrition? | No significant correlation found |

---

## Key Findings

- **Overtime** is the strongest predictor — employees working overtime leave **3x more**
- **Sales** is the highest-risk department (20.6%) and Sales Representatives have a 39.7% attrition rate
- Employees with **1-5 years** at the company are at the highest risk (61.6% of all who left)
- **Low salary** doubles the attrition risk compared to above-average salary
- **Frequent travel** increases attrition significantly (24.9% vs 8%)
- More **training** is directly linked to lower attrition

---

## Recommendations

1. **Reduce overtime** — introduce workload limits or hire additional staff in high-pressure teams
2. **Focus on Sales department** — review compensation and career growth paths for Sales roles
3. **Invest in early retention** — create onboarding and mentorship programs for employees in their first 5 years
4. **Increase training** — employees with more training are significantly less likely to leave
5. **Review travel policies** — offer compensation or flexibility for frequently traveling employees
6. **Adjust salary structure** — ensure below-average earners receive competitive pay reviews

---

## SQL Techniques Used

- `GROUP BY` / `HAVING` / `ORDER BY`
- `CASE WHEN` for conditional aggregation
- `UNION` for combining result sets
- `Subqueries` for percentage calculations
- `CTEs` (WITH clause) for readable multi-step queries
- `Window Functions` — `SUM() OVER()`, `ROW_NUMBER() OVER()`
- `Stored Procedures` with Dynamic SQL (`PREPARE` / `EXECUTE`)
- `INFORMATION_SCHEMA` for metadata queries
- `CONCAT` for dynamic query generation

---

*This project is part of my Data Analyst portfolio.*
