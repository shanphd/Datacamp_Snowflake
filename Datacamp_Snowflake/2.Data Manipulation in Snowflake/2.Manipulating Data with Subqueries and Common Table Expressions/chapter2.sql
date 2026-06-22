Chapter2.sql 

---------------- 
SELECT
	-- Find the genre name and average milliseconds
    ___,
    ___ AS average_milliseconds
-- Retrieve records from the result of the subquery
___ (
    SELECT
        genre.name AS genre_name,
        track.genre_id,
        track.milliseconds
    FROM store.track
    JOIN store.genre ON track.genre_id = genre.genre_id
)
-- Group the results by the genre name
___ ___ ___; 


SELECT
	genre_name,
    AVG(milliseconds) AS average_milliseconds
FROM  (
    SELECT
        genre.name AS genre_name,
        track.genre_id,
        track.milliseconds
    FROM store.track
    JOIN store.genre ON track.genre_id = genre.genre_id
)
-- Group the results by the genre name
GROUP BY genre_name;
----------------- 

--------------
SELECT
    invoice_id,
    COUNT(invoice_id) AS total_invoice_lines
FROM store.invoiceline
GROUP BY invoice_id
-- Only pull records with more than 10 total invoice lines
HAVING total_invoice_lines > 10;

SELECT
	billing_country,
    SUM(total) AS total_invoice_amount
FROM store.invoice
WHERE invoice_id IN  (
  SELECT
      invoice_id,
  FROM store.invoiceline
  GROUP BY invoice_id
  HAVING COUNT(invoice_id) > 10
)
GROUP BY billing_country;
--------------- 

----------------
-- Create a CTE named track_lengths
WITH track_lengths AS  (
	SELECT
        genre.name,
        track.genre_id,
        track.milliseconds / 1000 AS num_seconds
    FROM store.track
    JOIN store.genre ON track.genre_id = genre.genre_id
)

SELECT
    track_lengths.name,
    -- Find the average length of each track in seconds
    AVG(track_lengths.num_seconds) AS avg_track_length
FROM track_lengths
GROUP BY track_lengths.name
-- Sort the results by average track_length
ORDER BY avg_track_length DESC;


---------------- 

-----------------
-- Create a CTE called track_metrics, convert milliseconds to seconds
WITH track_metrics AS (
    SELECT 
        composer,
        milliseconds / 1000 AS num_seconds,
        unit_price
    FROM store.track
 	-- Retrieve records where composer is not NULL
    where composer IS NOT NULL
)

SELECT
    composer,
    -- Find the average price-per-second
    AVG(unit_price/num_seconds) AS cost_per_second
FROM track_metrics
GROUP BY composer
ORDER BY cost_per_second DESC;

------------------ 


------------------ 
WITH cleaned_invoices AS (
    SELECT
        invoice_id,
        invoice_date
    FROM store.invoice
    WHERE billing_country = 'Germany'
)

SELECT * FROM cleaned_invoices;

WITH cleaned_invoices AS (
    SELECT
        invoice_id,
        invoice_date
    FROM store.invoice
    WHERE billing_country = 'Germany'

) 
-- Create the detailed_invoice_lines CTE
,detailed_invoice_lines AS  (
  SELECT
        invoiceline.invoice_id,
        invoiceline.invoice_line_id,
        track.name,
        invoiceline.unit_price,
        invoiceline.quantity,
    FROM store.invoiceline
    LEFT JOIN store.track ON invoiceline.track_id = track.track_id
)

SELECT * FROM detailed_invoice_lines;

WITH cleaned_invoices AS (
    SELECT
        invoice_id,
        invoice_date
    FROM store.invoice
    WHERE billing_country = 'Germany'
), 

detailed_invoice_lines AS (
    SELECT
        invoiceline.invoice_id,
        invoiceline.invoice_line_id,
        track.name,
        invoiceline.unit_price,
        invoiceline.quantity,
    FROM store.invoiceline
    LEFT JOIN store.track ON invoiceline.track_id = track.track_id
)

SELECT
    ci.invoice_id,
    ci.invoice_date,
    dil.name,
    -- Find the total amount for the line
    dil.unit_price * dil.quantity AS line_amount
FROM detailed_invoice_lines AS dil

-- JOIN the cleaned_invoices and detailed_invoice_lines CTEs
LEFT JOIN cleaned_invoices AS ci ON dil.invoice_id = ci.invoice_id
ORDER BY ci.invoice_id, line_amount;
------------------ 


-------------- 

-- Define an album_map CTE to combine albums and artists
WITH album_map AS (
    SELECT
        album.album_id, album.title AS album_name, artist.name AS artist_name,
  		-- Determine if an album is a "Greatest Hits" album
        CASE 
            WHEN album_name ILIKE '%greatest%' THEN TRUE
            ELSE FALSE
        END  AS is_greatest_hits
    FROM store.album
    JOIN store.artist ON album.artist_id = artist.artist_id
), trimmed_invoicelines AS (
    SELECT
        invoiceline.invoice_id, track.album_id, invoice.total
    FROM store.invoiceline
    LEFT JOIN store.invoice ON invoiceline.invoice_id = invoice.invoice_id
    LEFT JOIN store.track ON invoiceline.track_id = track.track_id
)

SELECT
    album_map.album_name,
    album_map.artist_name,
    SUM(ti.total) AS total_sales_driven
FROM trimmed_invoicelines AS ti
JOIN album_map ON ti.album_id = album_map.album_id
-- Use a subquery to only "Greatest Hits" records
WHERE  ti.album_id IN (SELECT album_id FROM album_map WHERE is_greatest_hits)
GROUP BY album_map.album_name, album_map.artist_name, is_greatest_hits
ORDER BY total_sales_driven DESC;
-----------------