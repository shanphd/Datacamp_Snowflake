--------------- 
SELECT

	-- Return the vehicle model and battery capacity
    vehicle_model,
    battery_capacity,
    
    -- Use a window function to return a ranking without gaps
    DENSE_RANK() OVER(
      	-- Battery capacity from greatest to least
        partition by vehicle_model order by battery_capacity desc
    ) AS battery_capacity_rank
    
FROM ELECTRIC_VEHICLES.charging;
--------------- 

--------------- 
SELECT
    charger_type,
    charging_duration * 60 AS charging_minutes,
	
    -- Assign a ranking to reach record based on charging
    -- duration, from shortest to longest
    rank() over(
      	-- Segment the result set by charger type
        partition by charger_type
        ORDER BY charging_duration desc
    ) AS charging_duration_rank_1

FROM ELECTRIC_VEHICLES.charging;
--------------- 

--------------- 
SELECT
    charger_type,
    charging_duration * 60 AS charging_minutes,

    RANK() OVER(
        PARTITION BY charger_type
        ORDER BY charging_duration
    ) AS charging_duration_rank_1,
	
    -- Assign a ranking to record based on charging duration
    -- WITHOUT gaps
    DENSE_RANK() OVER(
        PARTITION BY charger_type
        ORDSELECT
    charger_type,
    charging_duration * 60 AS charging_minutes,

    RANK() OVER(
        PARTITION BY charger_type
        ORDER BY charging_duration
    ) AS charging_duration_rank_1,
	
---------------  

-------------- 
SELECT
    charger_type,
    charging_duration * 60 AS charging_minutes,

    RANK() OVER(
        PARTITION BY charger_type
        ORDER BY charging_duration
    ) AS charging_duration_rank_1,
	
    -- Assign a ranking to record based on charging duration
    -- WITHOUT gaps
    DENSE_RANK() OVER(
        PARTITION BY charger_type
        ORDER BY charging_duration
    ) AS charging_duration_rank_2

FROM ELECTRIC_VEHICLES.charging;
-------------- 

------------- 
SELECT
	charging_station_location,
	user_id,
	charging_cost,
    
    -- Find the tenth-smallest charging cost
    NTH_VALUE(charging_cost, 10) OVER(
      	-- Segment the data by charging_station_location
		partition by charging_station_location
    	ORDER BY charging_cost
    -- Alias the result as minimum_cost
    ) as minimum_cost
    
FROM ELECTRIC_VEHICLES.charging;
------------- 

-------------- 
SELECT
    user_id,
    charging_station_location,
    charging_cost,
    
    -- Break records into 100 equally-sized buckets based on
    -- charging_cost
    NTILE(100) OVER(
      ORDER BY charging_cost
    ) AS survey_group
    
FROM ELECTRIC_VEHICLES.charging

-- Order by survey_group and charging_station_location
ORDER BY survey_group, charging_station_location;
-------------- 

----------------
SELECT
    user_id,
    charging_station_location,
    charging_cost,
    
    NTILE(100) OVER(
      
      -- Evenly distribute records in each bucket by 
      -- charging_station_location
      partition by charging_station_location
      ORDER BY charging_cost
    ) AS survey_group
    
FROM ELECTRIC_VEHICLES.charging

-- Order by survey_group and charging_station_location
order by survey_group,charging_station_location;


------------------- 

-------------
SELECT
    user_id,
    charging_station_id,
    charging_duration * 60,
	
    -- Find the cumulative distribution of records in the result set
    CUME_DIST() OVER (
      
      	-- Segment records by charging station id
        partition by charging_station_id
      	
      	-- Create the cumulative distribution using charging duration
        order by charging_duration
      
    ) AS charging_duration_dist

FROM ELECTRIC_VEHICLES.charging
ORDER BY charging_station_id, charging_duration_dist;
------------ 

---------------- 
SELECT
    user_id,
    charging_station_location,
    charging_start_time,
    charging_rate,
	
    -- Difference between current charging rate versus three sessions ago
    charging_rate - LAG(charging_rate, 3, 0) OVER(
      	
      	-- Make sure results are partitioned by charging_station_location
        partition by charging_station_location
      
      	-- Sessions should be ordered by when charging began
        order by charging_start_time
      
    ) AS change_in_charging_rate

FROM ELECTRIC_VEHICLES.charging;


------------------- 

-----------------
SELECT
    user_id,
    charging_station_id,
    charging_start_time,
    
    -- Retrieve the time_of_day, charging_rate and energy_consumed fields
	time_of_day,
    charging_rate,
    energy_consumed,
	
    -- "Look ahead" to the energy consumed in the next session
    LEAD(energy_consumed,1,0) OVER(
      
      	-- Segment the records by charging station and sequence
      	-- records by the start time of the charge
        PARTITION BY charging_station_id
        order by charging_start_time
      
    ) AS next_session_energy_consumed

FROM ELECTRIC_VEHICLES.charging;
----------------