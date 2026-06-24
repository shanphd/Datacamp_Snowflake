----------------- 
SELECT
    gym_id,
    CASE
        -- Update the locations classified as a Major City
        WHEN location IN ('New York', 'Los Angeles', 'Dallas') 
        THEN 'Major City'
        
        -- Otherwise, it's a Non-Major City
        ELSE 'Non-Major City'
    END AS gym_city
FROM CORE_GYM.gyms

-- Complete the WHERE clause to only return Premium gym types
WHERE gym_type = 'Premium';
----------------- 

---------------- 
CREATE OR REPLACE TABLE retail (
  	-- transaction_id stores 16 total digits with 0 right of the decimal point
    transaction_id NUMBER(16, 0),
  	-- pre_tax_amount stores up to 6 digits with 2 right of the decimal point
    pre_tax_amount NUMBER(6, 2),
  	-- tax_rate stores up to 5 digits with 3 right of the decimal point
    tax_rate NUMBER(5, 3),
    transaction_total NUMBER(6, 2)
);
---------------- 

------------------- 
SELECT
	-- Return '2007-06-13' as a DATE
    To_Date('2007-06-13') AS the_date
;
------------------- 

--------------
SELECT
    TO_DATE('2007-06-13') AS the_date,
    
    -- Return '09:53:18' as a TIME
    To_TIME('09:53:18') AS TIME
;

--------------- 

--------------
SELECT
    TO_DATE('2007-06-13') AS the_date,
    
    -- Return '09:53:18' as a TIME
    To_TIME('09:53:18') AS the_time
;

--------------- 

----------------- 
SELECT
    TO_DATE('2007-06-13') AS the_date,
    TO_TIME('09:53:18') AS the_time,
    
    -- Cast the string to a timestamp
    '2007-06-13 09:53:18'::TIMESTAMP AS the_timestamp
;

----------------- 

--------------- 
SELECT
    checkin_time,
    
    -- Cast checkin_time to DATE
    checkin_time::DATE AS the_date,
    
    -- Cast checkin_time to TIME
    checkin_time::TIME AS the_time

    
FROM CORE_GYM.visits
;

---------------
