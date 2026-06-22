
---------------
Chapter 1 
SELECT
	name,
    composer,
    -- Begin a CASE statement
    ___
        -- A song priced at 0.99 should be a 'Standard Song'
    	WHEN ___ = ___ THEN '___'
        -- Songs costing 1.99 should be denoted as 'Premium Song'
        ___ unit_price = 1.99 ___ '___'
    END AS song_description
FROM store.track; 

SELECT
name,
composer,
CASE
WHEN unit_price = 0.99 THEN 'Standard Song'
WHEN unit_price = 1.99 THEN 'Premium Song'
END AS song_description
from store.track;

------------------- 

--------------- 
SELECT
	customer_id,
    total,
    CASE
        -- Check if total is either 0.99 or 1.99 using IN
    	WHEN ___ IN (0.99, ___) THEN '___'
        -- Catch the scenarios when the above is not true
        ___ '2+ Songs'
    -- End the CASE statement and name the new column
    ___ AS ___
FROM store.invoice;

SELECT 
customer_id,
total,
CASE
WHEN total IN (0.99, 1.99) THEN '1 Song'
ELSE '2+ Songs'
END AS number_of_songs
from store.invoice;

--------------- 

-------------- 
SELECT
	name,
    milliseconds,
    CASE
    	___ milliseconds < ___ THEN '___'
        WHEN ___ BETWEEN ___ AND ___ ___ '___'
        ___ '___'
    END AS song_length
FROM store.track;

SELECT
name,
milliseconds,
CASE
WHEN milliseconds < 180000 THEN 'Short Song'
WHEN milliseconds BETWEEN 180000 AND 300000 THEN 'Normal Length'
ELSE 'Long Song'
END AS song_length
from store.track;
-------------- 

-----------------
SELECT
    name,
    unit_price,
    CASE
        -- Inexpensive Rock and Pop songs are always high-intent
        WHEN ___ = ___ AND genre_id IN (___, ___) THEN '___'
        -- Shorter, non-EDM tracks have neutral buyer intent
        ___ milliseconds < ___ ___ ___ != ___ ___ '___'
		-- Everything else is low
        ___ '___'
    END AS buyer_intent
FROM store.track;

SELECT
name,
unit_price,
CASE
WHEN unit_price = 0.99 AND genre_id IN (5, 9) THEN 'High'
WHEN milliseconds < 300000 AND genre_id != 15 THEN 'Neutral'
ELSE 'Low'
END AS buyer_intent
from store.track;

----------------- 

----------------
SELECT
	customer_id,
    total,
    CASE
    	WHEN total IN (0.99, 1.99) THEN '1 Song'
        ELSE '2+ Songs'
    END as number_of_songs
FROM store.invoice;

SELECT
    CASE
    	WHEN total IN (0.99, 1.99) THEN '1 Song'
        ELSE '2+ Songs'
    END as number_of_songs,
    -- Find the average value of the total field
    ___
FROM store.invoice
-- Group by the field you built using CASE
___
;

SELECT
    CASE
    	WHEN total IN (0.99, 1.99) THEN '1 Song'
        ELSE '2+ Songs'
    END as number_of_songs,
    AVG(total) AS average_total
FROM store.invoice
Group BY number_of_songs;
------------------ 

--------------------


When the track.composer field is NULL, then label as 'Track Lacks Detail'.
If the track.composer field matches the artist.name, then return 'Matching Artist'.
Finally, LEFT JOIN the artist table to album using the field


SELECT
    track.name,
    track.composer,
    artist.name,
    CASE
    	-- A 'Track Lacks Detail' if the composer field is NULL
        WHEN track.composer ___ ___ THEN 'Track Lacks Detail'
        -- Use the composer and artist name to determine if a match exists
        ___ track.composer = ___.name ___ '___'
        ELSE 'Inconsistent Data'
    END AS data_quality
FROM store.track AS track
LEFT JOIN store.album AS album ON track.album_id = album.album_id
-- Join the album table to artist using the artist_id field
___ JOIN store.___ AS artist ON album.___ = ___.___;

SELECT
track.name,
track.composer,
artist.name,
CASE
WHEN track.composer IS NULL THEN 'Track Lacks Detail'
WHEN track.composer = artist.name THEN 'Matching Artist'
ELSE 'Inconsistent Data'
END AS data_quality
FROM store.track AS track
LEFT JOIN store.album AS album ON track.album_id = album.album_id
LEFT JOIN store.artist AS artist ON album.album_id = store.artist_id 
-------------------------