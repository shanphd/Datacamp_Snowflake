------------- 
SELECT
    user_id,
    vehicle_model,
    energy_consumed,
    charging_duration,
	
    -- Count the total number of charging sessions by vehicle_model
    count(*) OVER(
        PARTITION BY vehicle_model
    ) AS total_number_of_charges
    
FROM ELECTRIC_VEHICLES.charging
ORDER BY vehicle_model;
-------------

----------------
SELECT
    user_id,
    vehicle_model,
    energy_consumed,
    charging_duration,
	
    -- Find the total charging duration, partitioned by vehicle model
    SUM(charging_duration) OVER(
        partition by vehicle_model
    ) AS total_charging_duration

FROM ELECTRIC_VEHICLES.charging
ORDER BY vehicle_model;
---------------- 

-------------------
SELECT
    user_id,
    vehicle_model,
    energy_consumed,
    charging_duration,
	
    -- Determine the average energy consumed for each vehicle model
    charging_duration-avg(charging_duration) over(
        PARTITION BY vehicle_model
    ) AS average_energy_consumed

FROM ELECTRIC_VEHICLES.charging
ORDER BY vehicle_model;
-------------------- 

---------------------
SELECT
    charging_station_location,
    TO_DATE(charging_start_time) AS charging_date,
    charging_duration,
    charging_cost,
	
    -- Find the proportion of total charging duration charging location
    charging_duration / sum(charging_duration) OVER(
        PARTITION BY charging_station_location
    ) AS proportion_of_daily_charging_duration,
	
    -- Determine the difference between each session's charging 
    -- cost and the average charging cost for each charging station location
    charging_cost - avg(charging_cost) OVER (
        PARTITION BY  charging_station_location
    ) AS cost_vs_avg

FROM ELECTRIC_VEHICLES.charging

-- Order the results by charging station location and charging date
ORDER BY charging_station_location, charging_date;
--------------------- 

------------------------ 
SELECT
	user_id,
    charging_station_location,
	TO_DATE(charging_start_time),
    charging_duration,

    -- Find the running average of charging duration
    avg(charging_duration) OVER(
      	-- Partition the results by charging_station_location
      	Partition by charging_station_location

        -- Sequence the results by charging start time in ascending order
        ORDER BY charging_start_time

        -- Create the window of records to always be between the 
      	-- first row and the current row
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 

    ) AS running_average
FROM ELECTRIC_VEHICLES.charging;
-------------------------- 

---------------
SELECT
    user_id,
    TO_DATE(charging_start_time), 
    charging_station_location,
    charging_rate,
	
    -- Find the average charging rate, by charging station location
  	-- using a window frame between the first row and current row
    avg(charging_rate) OVER(
        PARTITION BY charging_station_location  
        ORDER BY charging_start_time
       ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS running_average_charging_rate,
	
    -- Count the number of records by charging station location
    COUNT(*) OVER(
        PARTITION BY charging_station_location
      	
      	-- Create a window frame between the current row and the 
      	-- last row, ordered by charging start time
        ORDER BY charging_start_time
        ROWS BETWEEN  UNBOUNDED PRECEDING AND CURRENT ROW
      
    ) AS remaining_charges

FROM ELECTRIC_VEHICLES.charging
ORDER BY charging_station_location, charging_start_time;
---------------- 

----------------
 SELECT
    vehicle_model,
    charger_type,
    temperature,
    charging_rate,
	
    -- Create a moving average of temperature using the two preceding and following records
    avg(temperature) OVER(
        PARTITION BY vehicle_model
        ORDER BY temperature
        ROWS BETWEEN 2 PRECEDING  AND 2 following
    ) AS moving_average_temperature,
    
    -- Find the moving average charging rate for the preceding four charging sessions
    avg(charging_rate) OVER(
        PARTITION BY vehicle_model
        ORDER BY temperature
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS moving_average_charging_rate

FROM ELECTRIC_VEHICLES.charging

-- Only include non-NULL charging rates
WHERE charging_rate is NOT NULL
ORDER BY vehicle_model, charger_type, temperature;
----------------- 

-------------
SELECT
    charging_station_location,
    TO_DATE(charging_start_time),
    charging_cost,
    energy_consumed,
	
    -- Provide a ranking for each charging session based on energy consumed, from greatest to least
    RANK() OVER(
        PARTITION BY charging_station_location
        ORDER BY energy_consumed DESC
    ) AS rank_energy_consumed,
	
    -- Generate a "running total" of charging costs by charging station location
    SUM(charging_cost) OVER(
        PARTITION BY charging_station_location
        ORDER BY charging_start_time
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_charging_cost,
	
    -- Build a window frame using the two preceding and two following sessions to find a moving average of energy consumed
    avg(energy_consumed) OVER(
        PARTITION BY charging_station_location
        ORDER BY charging_start_time
        ROWS BETWEEN 2 PRECEDING  AND 2 following
    ) AS moving_average_energy_consumed

FROM ELECTRIC_VEHICLES.charging
WHERE energy_consumed IS NOT NULL
ORDER BY charging_station_location, charging_start_time;
-------------SELECT
    