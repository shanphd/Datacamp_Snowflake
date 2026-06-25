------------- 
SELECT
    personal_info,
	
    -- Use the TO_NUMBER function to convert the age to a NUMBER
    TO_NUMBER(personal_info:age),
    
    -- Use bracket-notation to retrieve the member's gender
    personal_info['gender'] AS gender,

FROM CORE_GYM.members

-- Only retrieve members who are at least 25
WHERE TO_NUMBER(personal_info:age) >= 25;

-------------- 

------------ 
SELECT
    user_id,

	-- Retrieve the member's first name using dot-notation
    personal_info:name.first AS first_name,

FROM CORE_GYM.members;
------------- 

------------ 
SELECT
    user_id,
    CONCAT(
        personal_info:name.first,
        ' ',
      
		-- Add the last name to the CONCAT function call using bracket-notation
		personal_info['name']['last']
      
    ) AS member_description

FROM CORE_GYM.members;

------------- 

-------------- 
SELECT
    user_id,
    CONCAT(
        personal_info:name.first,
        ' ',
        personal_info['name']['last'],
        ' is a ',
      
      	-- Add the age to the description
        personal_info:age,
        ' year-old gym member.'
      
    ) AS member_description

FROM CORE_GYM.members;

-------------- 
-- Retrieves the user_id, first name, and last name from the members table
with flattened_members AS (
    SELECT
        user_id,
        personal_info:name.first AS first_name,
        personal_info:name.last AS last_name,
    FROM CORE_GYM.members),
  
-- high_performers should return all visits where > 500 calories were burned
high_performers AS (
    SELECT 
        user_id,
        TO_DATE(checkin_time) AS workout_date,
        workout_type,
        calories_burned
    FROM CORE_GYM.visits
    WHERE calories_burned > 500)

SELECT
    CONCAT(flattened_members.first_name, ' ', flattened_members.last_name) AS full_name,
    high_performers.workout_date,
    high_performers.workout_type,
    high_performers.calories_burned
FROM high_performers
-- JOIN flattened_members to high_performers on the user_id field
JOIN flattened_members ON 
flattened_members.user_id = high_performers.user_id;
---------------

-------------- 
with senior_members AS (
    SELECT
        user_id
    FROM CORE_GYM.members
    WHERE personal_info:age::NUMBER > 60
)

SELECT * FROM senior_members;
-------------- 

--------------- 
WITH senior_members AS (
    SELECT
        user_id
    FROM CORE_GYM.members
    WHERE personal_info:age::NUMBER > 60
), senior_member_visits AS (
    SELECT
        gym_id,
        workout_type,
        calories_burned
    FROM CORE_GYM.visits
  
  	-- Filter records
    WHERE user_id IN (SELECT user_id FROM senior_members)
)

SELECT * FROM senior_member_visits;

---------------

------------
WITH senior_members AS (
    SELECT
        user_id
    FROM CORE_GYM.members
    WHERE personal_info:age::NUMBER > 60
), senior_member_visits AS (
    SELECT
        gym_id,
        workout_type,
        calories_burned
    FROM CORE_GYM.visits
    WHERE user_id IN (SELECT user_id FROM senior_members)
)

SELECT
    gyms.location,
    senior_member_visits.workout_type,
    
    -- Find the average calories burned for all senior member visits
    avg(senior_member_visits.calories_burned) AS avg_calories_burned

FROM senior_member_visits
LEFT JOIN CORE_GYM.gyms ON senior_member_visits.gym_id = gyms.gym_id
GROUP BY gyms.location, senior_member_visits.workout_type;
------------ 

------------ 
-- Create a CTE called workout_durations to prepare data to be pivoted
with workout_durations AS (
    SELECT
        gym_id,
        workout_type,
        DATEDIFF(MINUTES, checkin_time, checkout_time) AS workout_length
    from core_gym.visits
)

SELECT
    *
FROM workout_durations

-- Pivot the results, find the average workout length for each gym and workout type
PIVOT(
    AVG(workout_length) 
    FOR workout_type IN (ANY ORDER BY workout_type)
);

------------- 
-- Create a CTE called gym_workouts returns the user_id, gym_id, 
-- workout_type, calories_burned and location for 'Premium' gym types
with gym_workouts AS (
    SELECT
  		visits.user_id,
        visits.gym_id,
        visits.workout_type,
  		visits.calories_burned,
        gyms.location
    FROM CORE_GYM.visits
    JOIN CORE_GYM.gyms ON visits.gym_id = gyms.gym_id
    WHERE CORE_GYM.gyms.gym_type = 'Premium'
)

SELECT
	-- Do NOT include the gym_id field in the final output
    * EXCLUDE gym_id
FROM gym_workouts
-- Pivot gym_workouts, find the sum of calories_burned for each 
-- type of workout in workout_type
PIVOT(
    sum(calories_burned) 
    FOR workout_type IN (ANY ORDER BY workout_type)
);
-----------------


