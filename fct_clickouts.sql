-- Create a combined clickout table upstream before use in Looker to simplify the data model
-- This helps avoid heavy joins at the Looker layer and improve performance
CREATE OR REPLACE TABLE analytics.fct_clickouts AS
SELECT 
    MD5(CONCAT_WS('|', 'mortgage', clickout_id)) AS clickout_key,
    clickout_id,
    user_id,
    partner_id,
    clickout_time,
    'mortgage' AS product_type,
    apr,
    fees
FROM analytics.mortgage_clickouts

UNION ALL

SELECT 
    MD5(CONCAT_WS('|', 'non_mortgage', clickout_id)) AS clickout_key,
    clickout_id,
    user_id,
    partner_id,
    clickout_time,
    product_type,
    NULL AS apr,
    NULL AS fees
FROM analytics.clickouts
;
