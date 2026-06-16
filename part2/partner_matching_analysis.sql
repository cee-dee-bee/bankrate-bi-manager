/* 
Bankrate matches personal-loan customers with partners most likely to approve them at the best possible deal. 
We collect customer data to understand approvability and optimize both approval rate and revenue. 
We hypothesize that our current matching processes are suboptimal and resulting in lost revenue.

Assume three partners (A, B, C) offering identical loan terms (same interest rate, term length, and fees). 
For each approved loan, Bankrate earns:
- $250 from A
- $350 from B
- $150 from C.

Leadership wants to know whether better matching specific customer segments to partners could increase revenue per application.

Below are three broad questions to explore. 
Treat them as starting points—use your judgment, statistics, and visualizations to investigate the data and surface insights.

1. What factors determine approvability?
2. What differences are there in partner approval rates?
3. What else would you want to tell leadership?
*/

--# PARTNER SUMMARY 
--# B has the highest payout but the lowest approval and revenue per application, indicating a segmentation opportunity 
SELECT
	partner_id,
    CASE 
    	WHEN partner_id = 'A' 
  		THEN 250 
        WHEN partner_id = 'B' 
        THEN 350 
        WHEN partner_id = 'C' 
        THEN 150 
        END AS revenue_per_loan,
 	COUNT(application_id) AS cnt_applications,
	ROUND(1.0 * COUNT(application_id) 
		/ (SELECT COUNT(application_id) FROM bankrate_applications), 4) 
  		AS pct_applications,
  ROUND(1.0 * SUM(application_status) 
    / COUNT(application_id), 4) 
    AS approval_rate,
	SUM(application_status
    * (CASE 
       WHEN partner_id = 'A' 
       THEN 250 
       WHEN partner_id = 'B' 
       THEN 350 
       WHEN partner_id = 'C' 
       THEN 150 
       END)) 
       AS revenue,
  ROUND(SUM(application_status) 
        * (CASE 
           WHEN partner_id = 'A' 
           THEN 250 
           WHEN partner_id = 'B' 
           THEN 350 
           WHEN partner_id = 'C' 
           THEN 150 
           END) * 1.0 / COUNT(*), 2) 
           AS revenue_per_application
FROM bankrate_applications
GROUP BY 1
;

--# OVERALL SUMMARY 
SELECT
  'All Partners' AS partner,
	COUNT(application_id) AS cnt_applications,
  ROUND(1.0 * SUM(application_status) 
        / COUNT(application_id), 4) 
        AS total_approval_rate,
  SUM(application_status 
    * (CASE 
       WHEN partner_id = 'A' 
       THEN 250 
       WHEN partner_id = 'B' 
       THEN 350 
       WHEN partner_id = 'C' 
       THEN 150 ELSE 0
       END)) 
       AS total_revenue,
  ROUND(SUM(application_status * (CASE 
       WHEN partner_id = 'A' 
       THEN 250 
       WHEN partner_id = 'B' 
       THEN 350 
       WHEN partner_id = 'C' 
       THEN 150 ELSE 0
       END))  * 1.0 / COUNT(*), 2) AS total_rpa
FROM bankrate_applications
GROUP BY 1
;

--# FICO SCORE SUMMARY
SELECT 
	app.fico_score_group, 
  COUNT(app.application_id) AS cnt_applications, 
  SUM(rev.revenue_amount) AS revenue,
  ROUND(1.0* SUM(app.application_status)/COUNT(app.application_id),3) AS approval_rate
FROM bankrate_applications AS app  
LEFT JOIN bankrate_revenue AS rev 
	ON app.application_id = rev.application_id
GROUP BY app.fico_score_group
ORDER BY approval_rate
;

--# HOUSING RATIO SUMMARY
SELECT
  CASE
    WHEN 1.0 * monthly_housing_payment / monthly_gross_income <= 0.28 THEN '1. <= 28%'
    WHEN 1.0 * monthly_housing_payment / monthly_gross_income > 0.28  
    AND 1.0 * monthly_housing_payment / monthly_gross_income <= 0.45 THEN '2. 29-45%'
    WHEN 1.0 * monthly_housing_payment / monthly_gross_income > 0.45 THEN '3. 46%+'
    END AS housing_ratio_bucket,
  COUNT(application_id) AS cnt_applications,
  ROUND(1.0* SUM(application_status)/COUNT(application_id),3) AS approval_rate
FROM bankrate_applications
GROUP BY 1
ORDER BY 1
;

--# PRIOR BANKRUPTCY OR FORECLOSURE SUMMARY
SELECT 
  ever_bankrupt_or_foreclose, 
  COUNT(application_id) AS cnt_applications, 
  ROUND(1.0* SUM(application_status)/COUNT(application_id),3) AS approval_rate
FROM bankrate_applications
GROUP BY 1
  ;

--# EMPLOYMENT STATUS SUMMARY
SELECT 
  employment_status, 
  COUNT(application_id) AS applications, 
  ROUND(1.0* SUM(application_status)/COUNT(application_id),3) AS approval_rate
FROM bankrate_applications
GROUP BY employment_status
ORDER BY approval_rate DESC
;

--# PARTNER AND FICO SCORE DISTRIBUTION
SELECT 
  fico_score_group, 
  SUM(CASE WHEN partner_id = 'A' THEN 1 ELSE 0 END) AS cnt_applications_partner_a,
  SUM(CASE WHEN partner_id = 'B' THEN 1 ELSE 0 END) AS cnt_applications_partner_b,
  SUM(CASE WHEN partner_id = 'C' THEN 1 ELSE 0 END) AS cnt_applications_partner_c,  
  COUNT(application_id) AS cnt_applications_fico,
  ROUND(1.0* SUM(CASE WHEN partner_id = 'A' THEN application_status ELSE 0 END)
        /SUM(CASE WHEN partner_id = 'A' THEN 1 ELSE 0 END),3) AS approval_rate_partner_a,  
  ROUND(1.0* SUM(CASE WHEN partner_id = 'B' THEN application_status ELSE 0 END)
        /SUM(CASE WHEN partner_id = 'B' THEN 1 ELSE 0 END),3) AS approval_rate_partner_b,  
  ROUND(1.0* SUM(CASE WHEN partner_id = 'C' THEN application_status ELSE 0 END)
        /SUM(CASE WHEN partner_id = 'C' THEN 1 ELSE 0 END),3) AS approval_rate_partner_c,
  ROUND(1.0* SUM(CASE WHEN partner_id = 'A' THEN application_stat ELSE 0 END)
	  	/SUM(CASE WHEN partner_id = 'A' THEN 1 ELSE 0 END),3) * 250 AS expected_value_a,
  ROUND(1.0* SUM(CASE WHEN partner_id = 'B' THEN application_stat ELSE 0 END)
	  	/SUM(CASE WHEN partner_id = 'B' THEN 1 ELSE 0 END),3) * 350 AS expected_value_b,
  ROUND(1.0* SUM(CASE WHEN partner_id = 'C' THEN application_stat ELSE 0 END)
	  	/SUM(CASE WHEN partner_id = 'C' THEN 1 ELSE 0 END),3) * 150 AS expected_value_c    
FROM bankrate_applications  
GROUP BY 1
ORDER BY 5 DESC
;



