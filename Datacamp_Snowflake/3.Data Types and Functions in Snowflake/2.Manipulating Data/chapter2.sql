-----------
SELECT
    user_id,
    
    -- Return all the text after user_ in the user_id field
    SPLIT(user_id, '_')[1] AS split_user_id
    
FROM CORE_GYM.members;
------------ 

-------------
SELECT
    user_id,
    SPLIT(user_id, '_')[1] AS split_user_id,
    
    -- Use a different function to remove all data after 
    -- user_ in the user_id field
    TRIM(USER_ID, 'user_') AS trimmed_user_id
    
FROM CORE_GYM.members;
------------- 

-------------
SELECT
    user_id,
    SPLIT(user_id, '_')[1] AS split_user_id,
    TRIM(user_id, 'user_') AS trimmed_user_id,
    
    -- Create a new member ID using the user_location,
    -- subscription_plan, and the second half of the SPLIT user_id
    CONCAT(
        user_location,
        subscription_plan,
        SPLIT(user_id, '_')[1]
    ) AS new_member_id
    
FROM CORE_GYM.members;
-------------- 

------------- 
SELECT
    v.user_id,
    g.location,
    
    -- Concatenate the following strings to create a sentence
    CONCAT(
        'Congrats! On ', 
        DATE(v.checkin_time), 
        ' you burned ', 
        v.calories_burned,  -- Add the calories burned
        ' calories via ', 
        v.workout_type  -- Add the workout type
    ) AS message

FROM CORE_GYM.visits AS v
JOIN CORE_GYM.gyms AS g
    ON v.gym_id = g.gym_id;
-------------- 

-------------- 
SELECT
    m.user_id,
    m.sign_up_date,
    m.subscription_plan,
    sp.price_per_month AS original_price,

	-- Add a 25% uplift to the existing price per month
    price_per_month * 1.25 AS twenty_five_percent_uplist,
    
    -- Increase the price_per_month by $5.00 
    price_per_month + 5 AS plus_five_dollars, 
    
    -- Divide the price per month by 2
    price_per_month / 2 AS half_off

FROM CORE_GYM.subscription_plans AS sp
JOIN CORE_GYM.members AS m
    ON sp.subscription_plan = m.subscription_plan;
-------------- 

-------------
SELECT
    workout_type,
    
    -- Find the total number of calories burned
    sum(calories_burned) AS total_calories_burned,
    
    -- Store the average calories burned
    avg(calories_burned) AS avg_calories_burned,
    
    -- Round the average calories burned to 2 decimal points
    round(avg(calories_burned), 2) AS rounded_avg_calories_burned
    
FROM CORE_GYM.visits

-- Aggregate records by workout_type
group by workout_type;
------------- 

-----------
SELECT
    v.user_id,
    m.user_location,
    v.checkin_time,
    
    -- Extract the day name from checkin_time
    DAYNAME(checkin_time) AS day_name
    
FROM CORE_GYM.visits AS v
JOIN CORE_GYM.members AS m
    ON v.user_id = m.user_id;

-----------  

-------------
SELECT
    v.user_id,
    m.user_location,
    v.checkin_time,
    DAYNAME(v.checkin_time) AS day_name,
    
    -- Extract the month name from checkin_time
    MONTHNAME(v.checkin_time) AS month_name
    
FROM CORE_GYM.visits AS v
JOIN CORE_GYM.members AS m
    ON v.user_id = m.user_id;
-------------
------------- 
SELECT
    v.user_id,
    m.user_location,
    v.checkin_time,
    DAYNAME(v.checkin_time) AS day_name,
    MONTHNAME(v.checkin_time) AS month_name,
    
    -- Extract the numeric day from checkin_time
    day(v.checkin_time) AS numeric_day
    
FROM CORE_GYM.visits AS v
JOIN CORE_GYM.members AS m
    ON v.user_id = m.user_id;

-------------

--------------- 
SELECT
	
    -- Retrieve the user_id, as well as check in/out times
    user_id,
    checkin_time,
    checkout_time,
	
    -- Find the number of minutes each member was at the gym for
    DATEDIFF(MINUTE, checkin_time, checkout_time) AS workout_duration

FROM CORE_GYM.visits;

---------------- 

--------------- 
SELECT
    m.personal_info:name.first AS first_name,
    m.personal_info:name.last AS last_name,
    v.gym_id,
    v.checkin_time AS last_appointment,
	
    -- Propose a next appointment in one week
DATEADD(WEEK, 1, v.checkin_time) AS in_one_week,
    
    -- Propose a next appointment in two weeks
    DATEADD(WEEK, 2, v.checkin_time) AS in_two_weeks,
    
    -- Propose a next appointment in one month
    DATEADD(MONTH, 1, v.checkin_time) AS in_one_month,

FROM CORE_GYM.visits AS v
JOIN CORE_GYM.members AS m
    ON v.user_id = m.user_id;

--------------- 

---------- 
-- calories_per_minute should take a start_time, end_time, and calories_burned
CREATE OR REPLACE FUNCTION calories_per_minute(
    start_time TIMESTAMP, end_time TIMESTAMP, calories_burned NUMBER
)

-- Make sure the function returns a NUMBER
RETURNS NUMBER

AS

$$
-- Use DATEDIFF to calculate the efficiency of a workout
DATEDIFF(MINUTE, start_time, end_time) / calories_burned
$$;

----------- 

-------------
SELECT
    user_id,
    gym_id,
    checkin_time,

	-- Determine workout efficiency for each user using the check in/out
    -- time, as well as the number of calories burned
    calories_per_minute(
        checkin_time, 
        checkout_time, 
        calories_burned
    ) AS workout_efficiency  -- Alias the results as workout_efficiency

FROM CORE_GYM.visits

-- Order the results by workout_efficiency
order by workout_efficiency DESC;

-------------