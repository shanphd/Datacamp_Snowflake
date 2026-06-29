------------- 
select * from COURSE_52051_DB_C68B7B45F81149C9B38E7D008B1038DC.product.in_app_purchases;
------------- 

--------------- 
-- Return plan and monthly_fee for subscriptions at or above $min_fee
SELECT plan, monthly_fee
FROM snowy_peak.subscriptions
WHERE monthly_fee >= $min_fee;
---------------