# Hr-Attrition-Analysis-SQL
End-To-End SQL project analyzing employee attrition with business insights

## Business Problem
Employee attrition increases hiring costs, reduces productivity, and impacts team morale.
This project analyzes attrition patterns to identify high-risk segments.

## Objective
- Identify key drivers of employee attrition
- Quantify department and tenure-level risks
- Provide actionable recommendations for HR leadership

## Dataset Overview
- Source: IBM HR Analytics Dataset
- Records: 1470 employees
- Key tables: employee_details, performance, compensation

## Data Cleaning & Validation
- Handled NULL values using COALESCE
- Removed duplicate employee records
- Standardized department and role names

## Key Analysis Performed
- Overall attrition rate calculation
- Department-wise attrition trends
- Attrition by tenure and salary band
- High-risk employee segmentation

## Tools & Skills Used
- SQL (MySQL)
- Joins, Common Table Expressions, Window Functions
- Aggregations and subqueries

## Business Insights
- Employees with tenure < 2 years show highest attrition risk
- Sales and Support departments have above-average churn
- Low salary bands correlate strongly with exits

## Recommendations
- Improve onboarding for first 24 months
- Review compensation for high-risk roles
- Introduce targeted retention programs

## Future Enhancements
- Automate reporting
- Add cost-of-attrition estimation
- Integrate dashboard visualization
