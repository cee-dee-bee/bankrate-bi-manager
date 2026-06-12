-- Create a combined revenue table upstream before use in Looker to simplify the data model
-- This helps avoid heavy joins at the Looker layer and improve performance
-- The application/clickout relationship is 1:1, but can adjust model if not the case in practice.
-- Every application will have a clickout, but not every clickout will have an application 
CREATE OR REPLACE TABLE analytics.fct_revenue AS 
SELECT 
    MD5(CONCAT_WS('|', 'non_mortgage', rev.application_id)) AS revenue_key,
    COALESCE(cot.product_type, 'unknown') AS product_type,
    rev.application_id AS application_id,
    app.clickout_id AS clickout_id,
    rev.partner_id AS partner_id,
    rev.revenue_amount AS revenue_amount,
    rev.revenue_date AS revenue_date
FROM analytics.revenue AS rev 
LEFT JOIN analytics.applications AS app
    ON rev.application_id = app.application_id
LEFT JOIN analytics.clickouts AS cot
    ON app.clickout_id = cot.clickout_id

UNION ALL

SELECT 
    MD5(CONCAT_WS('|', 'mortgage', rev.application_id)) AS revenue_key,
    'mortgage' AS product_type,
    NULL AS application_id,
    mrev.clickout_id AS clickout_id,
    mrev.partner_id AS partner_id,
    mrev.revenue_amount AS revenue_amount,
    mrev.revenue_date AS revenue_date
FROM analytics.mortgage_revenue AS mrev 
;
