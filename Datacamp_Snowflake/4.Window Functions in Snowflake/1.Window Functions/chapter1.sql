-----------------
SELECT
	-- Return the charging_station_location and user_id
    charging_station_location,
    user_id,
    charging_start_time,
    charging_cost,
    
    -- Assign a row number to each record, ordering by charging_cost
    row_number() over(order by charging_cost)
    
FROM ELECTRIC_VEHICLES.charging;
---------------- 

---------------
SELECT
    user_id,
    charging_station_id,
    charging_duration,
	
    -- Rank records by charging duration
    RANK() OVER(
        order by charging_duration
    ) AS quickest_charges

FROM ELECTRIC_VEHICLES.charging
WHERE charging_station_id = 'Station_108';
---------------- 

------------------ 
SELECT
    user_id,
    charging_station_id,
    charging_duration,
	
    -- Rank records by charging duration from largest to smallest
    rank() over(
        order by charging_duration desc
    ) AS slowest_chargest

FROM ELECTRIC_VEHICLES.charging
WHERE charging_station_id = 'Station_310';

-------------------- 

------------------- 
SELECT
    user_id,
    charging_station_location,
    charger_type,
    energy_consumed,
	
    -- Find the least energy consumed in a charging session
    LAST_VALUE(energy_consumed) OVER(
        ORDER BY energy_consumed desc
    ) AS least_energy_consumed

FROM ELECTRIC_VEHICLES.charging;

------------------- 



------------------- 
SELECT
    user_id,
    charging_station_location,
    charger_type,
    energy_consumed,
    FIRST_VALUE(energy_consumed) OVER(
        ORDER BY energy_consumed
    ) AS least_energy_consumed,
    
    -- Now, find the maximum energy consumed in a charging session
    LAST_VALUE(energy_consumed) OVER (
    ORDER BY energy_consumed	
    ) AS most_energy_consumed

FROM ELECTRIC_VEHICLES.charging
WHERE energy_consumed IS NOT NULL;

------------------- 

----------------------
SELECT
    user_id,
    charging_station_id,
    charging_cost,
    
    -- Create a window function to rank each session based on charging cost
    rank() over(
        order by charging_cost DESC
    ) AS expensive_charges
    
FROM ELECTRIC_VEHICLES.charging;
---------------------- 


--------------- 
SELECT
    user_id,
    charging_station_id,
    charging_cost,
    
    RANK() OVER(
      
        -- Partition records by charging station to determine
      	-- rankings for each charging station
      	Partition by charging_station_id
        ORDER BY charging_cost DESC
    ) AS expensive_charges
    
FROM ELECTRIC_VEHICLES.charging;
--------------- 

-----------------
SELECT
    user_id,
    charging_station_id,
    charging_cost,
    
    -- Based on the charging_start_time, find the first 
    -- charging cost for each location
	first_value(charging_cost) OVER(
    	PARTITION BY charging_station_id
      	ORDER BY charging_start_time
    ) AS first_charging_cost,

	-- Find the average charging cost for charging station id
    avg(charging_cost) OVER(
        PARTITION BY charging_station_id
    ) AS average_charging_cost
    
FROM ELECTRIC_VEHICLES.charging
ORDER BY charging_station_id;

-------------------