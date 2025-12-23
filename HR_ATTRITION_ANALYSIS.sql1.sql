CREATE DATABASE HR_ANALYTICS;

USE HR_ANALYTICS;

SELECT * FROM hr_analytics.hr_employee_attrition limit 10;

DESCRIBE hr_analytics.hr_employee_attrition;

#DATA VALIDATION & CLEANING
#NULL VALUE DETECTION 
SELECT 
SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END ) AS Attrition_null,
SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END ) AS Department_null,
SUM(CASE WHEN JobRole IS NULL THEN 1 ELSE 0 END ) AS JobRole_null,
SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END ) AS MonthlyIncome_null
FROM hr_analytics.hr_employee_attrition;

SET SQL_SAFE_UPDATES = 0; 
UPDATE hr_analytics.hr_employee_attrition
SET YearsSinceLastPromotion = 0
WHERE YearsSinceLastPromotion IS NULL ;

#VALIDATION
SELECT * FROM hr_analytics.hr_employee_attrition
WHERE JobSatisfaction NOT BETWEEN 1 AND 5
    OR WorkLifeBalance NOT BETWEEN 1 AND 5
    OR MonthlyIncome <= 0;

#MISSING VALUE HANDLING
#DROPPING NULLS
DELETE FROM hr_analytics.hr_employee_attrition
WHERE Attrition IS NULL
      OR Department IS NULL
      OR JobRole IS NULL;
      
#SALARY IMPUTATION (ROLE-LEVEL AVERAGE)
UPDATE hr_analytics.hr_employee_attrition h
JOIN (
    SELECT 
        Department, 
        AVG(MonthlyIncome) AS dept_avg
    FROM hr_analytics.hr_employee_attrition
    WHERE MonthlyIncome IS NOT NULL
    GROUP BY Department
) d
ON h.Department = d.Department
SET h.MonthlyIncome = d.dept_avg
WHERE h.MonthlyIncome IS NULL;


#CREATE ATTRITION FLAG
ALTER TABLE hr_analytics.hr_employee_attrition ADD attrition_flag INT;

UPDATE hr_analytics.hr_employee_attrition 
SET attrition_flag = CASE WHEN Attrition = 'YES' THEN 1
                     ELSE 0
                     END ;

#EXPLORATORY & DIAGNOSTIC ANALYSIS
# OVERALL ATTRITION RATE 
SELECT 
      ROUND(AVG(attrition_flag)*100 ,2) AS attrition_rate_percentage
FROM hr_analytics.hr_employee_attrition;

# ATTRITION BY DEPARTMENT
SELECT
      Department,
      COUNT(*),
      SUM(attrition_flag) as employees_left,
	ROUND(AVG(attrition_flag)*100 ,2) AS attrition_rate_percentage
FROM hr_analytics.hr_employee_attrition
GROUP BY Department
ORDER BY attrition_rate_percentage DESC;

# ATTRITION BY JOB_ROLE
SELECT 
      JobRole,
      COUNT(*) as total_employees,
      ROUND(AVG(attrition_flag)*100 ,2) AS attrition_rate_percentage
      FROM hr_analytics.hr_employee_attrition
GROUP BY JobRole
ORDER BY attrition_rate_percentage DESC;



#SALARY BAND VS ATTRITION
SELECT 
      CASE WHEN MonthlyIncome <= 3000 THEN 'Low_Salary'
           WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN 'Medium_Salary'
           ELSE 'High_Salary'
           END AS Salary_Band,
           COUNT(*) AS total_employee,
           ROUND(AVG(attrition_flag)*100 ,2) AS attrition_rate
           FROM hr_analytics.hr_employee_attrition
GROUP BY Salary_Band
ORDER BY attrition_rate DESC;

#TENURE VS ATTRITION
SELECT 
      CASE WHEN YearsAtCompany < 2 THEN '0-2 Years'
           WHEN YearsAtCompany BETWEEN 2 AND 5 THEN '2-5 Years'
           ELSE '5+ Years'
           END AS Tenure_Group,
           COUNT(*) AS total_employee,
           ROUND(AVG(attrition_flag)*100 ,2) AS attrition_rate
           FROM hr_analytics.hr_employee_attrition
GROUP BY Tenure_Group
ORDER BY attrition_rate DESC;

#JOB SATISFATION VS ATTRITION 
SELECT 
      JobSatisfaction,
        COUNT(*) AS total_employee,
		ROUND(AVG(attrition_flag)*100 ,2) AS attrition_rate
		FROM hr_analytics.hr_employee_attrition
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;
     
#HIGH-RISK EMPLOYEE IDENTIFICATION
SELECT 
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    YearsAtCompany,
    YearsSinceLastPromotion,
    JobSatisfaction,
    OverTime
FROM hr_analytics.hr_employee_attrition 
WHERE attrition_flag = 0
  AND OverTime = 'YES'
  AND JobSatisfaction <= 2
  AND YearsSinceLastPromotion >= 3;
      
















