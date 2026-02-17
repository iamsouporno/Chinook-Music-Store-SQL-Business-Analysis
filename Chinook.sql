USE chinook;

-- 1. Checking for Nul values and duplicate values and handling them

SELECT * FROM album; -- album_id, title, artist_id
SELECT * FROM artist; -- artist_id, name
SELECT * FROM customer; -- customer_id, first_name, last_name, company, address, city, state, country, postal_code, phone, fax, email, support_rep_id
SELECT * FROM employee; -- employee_id, last_name, first_name, title, reports_to, birthdate, hire_date, address, city, state, country, postal_code, phone, fax, email
SELECT * FROM genre; -- genre_id, name
SELECT * FROM invoice; -- invoice_id, customer_id, invoice_date, billing_address, billing_city, billing_state, billing_country, billing_postal_code, total
SELECT * FROM invoice_line; -- invoice_line_id, invoice_id, track_id, unit_price, quantity
SELECT * FROM media_type; -- media_type_id, name
SELECT * FROM playlist; -- playlist_id, name
SELECT * FROM playlist_track; -- playlist_id, track_id
SELECT * FROM track; -- track_id, name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price

-- checking missing values in album table

SELECT * FROM album
WHERE album_id IS NULL
OR title IS NULL
OR artist_id IS NULL;              
-- NO MISSING VALUES
 
-- checking for duplicate values in album table

SELECT album_id,title,artist_id , COUNT(*) AS count
FROM album
GROUP BY album_id,title,artist_id
HAVING COUNT(*) > 1;                  
-- NO DUPLICATE VALUES
 
-- checking for missing values in artist

SELECT * FROM artist
WHERE artist_id IS NULL 
OR name IS NULL;                        
-- NO MISSING VALUES

-- checking for duplicate values
SELECT artist_id,name,COUNT(*) as count
FROM artist
GROUP BY artist_id,name
HAVING COUNT(*) > 1;          
-- NO DUPLICATE VALUES

-- checking for missing values in customer

SELECT * FROM customer
WHERE customer_id IS NULL
OR first_name IS NULL
OR last_name IS NULL
OR company IS NULL
OR address IS NULL
OR city IS NULL
OR state IS NULL
OR country IS NULL
OR postal_code IS NULL
OR phone IS NULL
OR fax IS NULL
OR email IS NULL
OR support_rep_id IS NULL;    
-- HAVING MISSING VALUES

-- checking for duplicate values

SELECT *,COUNT(*) as count
FROM customer
GROUP BY customer_id,email
HAVING COUNT(*) > 1;                    
-- NO DUPLICATE VALUES

-- checking for missing values in employee

SELECT * FROM employee
WHERE employee_id IS NULL
OR last_name IS NULL
OR first_name IS NULL
OR title IS NULL 
OR reports_to IS NULL
OR birthdate IS NULL
OR hire_date IS NULL
OR address IS NULL
OR city IS NULL
OR state IS NULL
OR country IS NULL
OR postal_code IS NULL
OR phone IS NULL
OR fax IS NULL
OR email IS NULL;                
-- HAVING MISSING VALUES	

-- checking for duplicates
SELECT * , COUNT(*) as count
FROM employee
GROUP BY employee_id,email
HAVING COUNT(*) >1;                     
-- NO DUPLICATE VALUES

-- checking for missing values in genre

SELECT * FROM genre
WHERE genre_id IS NULL
OR name IS NULL;                 
-- NO MISSING VALUES

-- checking for duplicates

SELECT *, COUNT(*) as count 
FROM genre
GROUP BY genre_id,name
HAVING count(*)>1;                  
-- NO DUPLICATE VALUES

-- checking for missing values in invoice
select * from invoice
where invoice_id is null
or customer_id is null
or invoice_date is null
or billing_address is null
or billing_city is null
or billing_state is null
or billing_country is null
or billing_postal_code is null
or total is null;                     /* NO MISSING VALUES */

 -- checking for duplicates

 select * , count(*) from invoice
 group by invoice_id,customer_id
 having count(*) >1;             /* NO DUPLICATE VALUES*/
 
--  checking for missing values in invoice_line

select * from invoice_line
where invoice_line_id is null
or invoice_id is null
or track_id is null
or unit_price is null
or quantity is null;               /* NO MISSING VALUES */

-- checking for duplicates
select *,count(*) as count
from invoice_line
group by invoice_line_id
having count(*) > 1;         /* NO DUPLICATE VALUES*/

-- checking for missing values in media_type

select * from media_type
where media_type_id is null
or name is null;                   /* NO MISSING VALUES */

-- checking for duplicates
select * , count(*)
from media_type
group by media_type_id,name
having count(*) >1;              /* NO DUPLICATE VALUES*/

-- checking for missing values in playlist

select * from playlist
where playlist_id is null
or name is null;                 /* NO MISSING VALUES */

-- cheking for duplicates
select * , count(*) as count
from playlist
group by playlist_id,name
having count(*) > 1;             /* NO DUPLICATE VALUES*/

 -- checking for missing values in playlist_track

 select * from playlist_track
 where playlist_id is null
 or track_id is null;                 /* NO MISSING VALUES */

--  checking for duplicates

select * , count(*) as count 
from playlist_track
group by playlist_id,track_id
having count(*) > 1;           /* NO DUPLICATE VALUES*/

-- checking for missing values in track

select * from track
where track_id is null
or name is null
or album_id is null
or media_type_id is null
or genre_id is null
or composer is  null
or milliseconds is null
or bytes is null
or unit_price is null;           /* HAVING MISSING VALUES*/

-- Handling missing values
SET SQL_SAFE_UPDATES = 0;
UPDATE customer SET company = 'Unknown' WHERE company IS NULL; -- 49 row(s) affected
UPDATE customer SET state = 'None' WHERE state IS NULL; -- 29 row(s) affected
UPDATE customer SET phone = '+0 000 000 0000' WHERE phone IS NULL; -- 1 row(s) affected
UPDATE customer SET fax = '+0 000 000 0000' WHERE fax IS NULL; -- 47 row(s) affected
UPDATE customer SET postal_code = '0' WHERE postal_code IS NULL ; -- 1 row affected
UPDATE employee SET reports_to ='0' WHERE reports_to IS NULL; -- 1 row affected
UPDATE track SET composer = 'Unknown' WHERE composer IS NULL; -- 978 row(s) affected


-- checking for duplicates

select * , count(*) as count from track
group by track_id,name
having count(*)>1;     /* NO DUPLICATE VALUES*/

-- 2.	Find the top-selling tracks and top artist in the USA and identify their most famous genres

-- Top-selling tracks in the USA

SELECT 
    t.name AS track_name,
    ar.name AS artist_name,
    g.name AS genre_name,
    SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist ar ON al.artist_id = ar.artist_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE i.billing_country = 'USA'
GROUP BY t.track_id, t.name, ar.name, g.name
ORDER BY total_sales DESC
LIMIT 10;  -- Top 10 tracks

-- Top-selling artist in the USA

SELECT 
    ar.name AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist ar ON al.artist_id = ar.artist_id
WHERE i.billing_country = 'USA'
GROUP BY ar.artist_id, ar.name
ORDER BY total_sales DESC
LIMIT 1;

-- Most famous genre of the top artist

WITH top_artist AS (
    SELECT 
        ar.artist_id
    FROM invoice i
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN album al ON t.album_id = al.album_id
    JOIN artist ar ON al.artist_id = ar.artist_id
    WHERE i.billing_country = 'USA'
    GROUP BY ar.artist_id
    ORDER BY SUM(il.unit_price * il.quantity) DESC
    LIMIT 1
)
SELECT 
    g.name AS genre_name,
    SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist ar ON al.artist_id = ar.artist_id
JOIN genre g ON t.genre_id = g.genre_id
JOIN top_artist ta ON ar.artist_id = ta.artist_id
WHERE i.billing_country = 'USA'
GROUP BY g.genre_id, g.name
ORDER BY total_sales DESC;

-- 3. What is the customer demographic breakdown (age, gender, location) of Chinook's customer base?

-- Customer count by country

SELECT 
    country,
    COUNT(*) AS customer_count
FROM customer
GROUP BY country
ORDER BY customer_count DESC;

-- Customer count by city

SELECT 
    country,
    city,
    COUNT(*) AS customer_count
FROM customer
GROUP BY country, city
ORDER BY country, customer_count DESC;

-- 4. Calculate the total revenue and number of invoices for each country, state, and city */

SELECT 
    billing_country AS country,
    billing_state AS state,
    billing_city AS city,
    SUM(total) AS total_revenue,
    COUNT(*) AS invoice_count
FROM invoice
GROUP BY billing_country, billing_state, billing_city
ORDER BY total_revenue DESC;

--  5. Find the top 5 customers by total revenue in each country

WITH cus_revenue_countrywise AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, " ", c.last_name) AS customer_name,
        i.billing_country,
        SUM(i.total) AS total_revenue,
        RANK() OVER(
            PARTITION BY i.billing_country 
            ORDER BY SUM(i.total) DESC
        ) AS rnk
    FROM 
        customer c 
    JOIN 
        invoice i ON c.customer_id = i.customer_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name, i.billing_country
)
SELECT 
    customer_id,
    customer_name,
    billing_country,
    total_revenue
FROM 
    cus_revenue_countrywise
WHERE 
    rnk <= 5
ORDER BY 
    billing_country;

-- 6. Identify the top-selling track for each customer

WITH customer_track_sales AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        t.track_id,
        t.name AS track_name,
        SUM(il.quantity) AS total_quantity,
        SUM(il.unit_price * il.quantity) AS total_revenue
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    GROUP BY c.customer_id, c.first_name, c.last_name, t.track_id, t.name
),
ranked_tracks AS (
    SELECT 
        customer_id,
        customer_name,
        track_name,
        total_quantity,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id 
            ORDER BY total_quantity DESC, total_revenue DESC, track_name ASC
        ) AS rank_in_customer
    FROM customer_track_sales
)
SELECT 
    customer_id,
    customer_name,
    track_name,
    total_quantity,
    total_revenue
FROM ranked_tracks
WHERE rank_in_customer = 1
ORDER BY customer_name;

-- 7. Are there any patterns or trends in customer purchasing behavior (e.g., frequency of purchases, preferred payment methods, average order value)?

-- A. Frequency of Purchases per Customer

WITH customer_stats AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        COUNT(i.invoice_id) AS invoice_count,
        SUM(i.total) AS total_spent,
        AVG(i.total) AS avg_order_value,
        MIN(i.invoice_date) AS first_purchase,
        MAX(i.invoice_date) AS last_purchase
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
segments AS (
    SELECT 
        customer_id,
        customer_name,
        invoice_count,
        total_spent,
        avg_order_value,
        CASE 
            WHEN invoice_count >= 5 THEN 'Long-Term'
            ELSE 'New'
        END AS segment
    FROM customer_stats
)
SELECT 
    segment,
    ROUND(AVG(invoice_count), 2) AS avg_frequency,
    ROUND(AVG(avg_order_value), 2) AS avg_order_value,
    ROUND(AVG(total_spent), 2) AS avg_total_spent,
    COUNT(*) AS customer_count
FROM segments
GROUP BY segment;

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(i.invoice_id) AS invoice_count,
    MIN(i.invoice_date) AS first_purchase,
    MAX(i.invoice_date) AS last_purchase,
    DATEDIFF(CURDATE(), MAX(i.invoice_date)) AS days_since_last_purchase
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY invoice_count DESC;

-- B. Average Order Value (AOV) per Customer

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    AVG(i.total) AS avg_order_value,
    SUM(i.total) AS total_spent,
    COUNT(i.invoice_id) AS total_orders
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- C. Country-Level Trends

SELECT 
    i.billing_country,
    COUNT(DISTINCT i.customer_id) AS customer_count,
    COUNT(i.invoice_id) AS total_invoices,
    ROUND(SUM(i.total) / COUNT(i.invoice_id), 2) AS avg_invoice_value,
    ROUND(COUNT(i.invoice_id) / COUNT(DISTINCT i.customer_id), 2) AS avg_orders_per_customer,
    SUM(i.total) AS total_revenue
FROM invoice i
GROUP BY i.billing_country
ORDER BY total_revenue DESC;

-- 8. What is the customer churn rate?

WITH last_purchase AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        MAX(i.invoice_date) AS last_invoice_date
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id
),
dataset_end AS (
    SELECT MAX(invoice_date) AS max_date FROM invoice
)
SELECT 
    COUNT(CASE WHEN DATEDIFF(d.max_date, lp.last_invoice_date) > 180 THEN 1 END) AS churned_customers,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(CASE WHEN DATEDIFF(d.max_date, lp.last_invoice_date) > 180 THEN 1 END) * 100.0 / COUNT(*), 
        2
    ) AS churn_rate_percent
FROM last_purchase lp
CROSS JOIN dataset_end d;

-- 9. Calculate the percentage of total sales contributed by each genre in the USA and identify the best-selling genres and artists.

-- A. Percentage of Sales by Genre (USA)

WITH genre_sales AS (
    SELECT 
        g.name AS genre_name,
        SUM(il.unit_price * il.quantity) AS genre_revenue
    FROM invoice i
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    WHERE i.billing_country = 'USA'
    GROUP BY g.genre_id, g.name
),
total_sales AS (
    SELECT SUM(genre_revenue) AS total_revenue FROM genre_sales
)
SELECT 
    gs.genre_name,
    gs.genre_revenue,
    ROUND(gs.genre_revenue * 100.0 / ts.total_revenue, 2) AS pct_of_total_sales
FROM genre_sales gs
CROSS JOIN total_sales ts
ORDER BY gs.genre_revenue DESC;

-- B. Best-Selling Artists by Genre (USA)

WITH artist_sales AS (
    SELECT 
        g.name AS genre_name,
        ar.name AS artist_name,
        SUM(il.unit_price * il.quantity) AS artist_revenue
    FROM invoice i
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN album al ON t.album_id = al.album_id
    JOIN artist ar ON al.artist_id = ar.artist_id
    JOIN genre g ON t.genre_id = g.genre_id
    WHERE i.billing_country = 'USA'
    GROUP BY g.genre_id, g.name, ar.artist_id, ar.name
),
top_genres AS (
    SELECT 
        genre_name,
        SUM(artist_revenue) AS genre_revenue
    FROM artist_sales
    GROUP BY genre_name
    ORDER BY genre_revenue DESC
    LIMIT 5
)
SELECT 
    a.genre_name,
    a.artist_name,
    a.artist_revenue,
    RANK() OVER (PARTITION BY a.genre_name ORDER BY a.artist_revenue DESC) AS artist_rank
FROM artist_sales a
JOIN top_genres tg ON a.genre_name = tg.genre_name
ORDER BY a.genre_name, artist_rank;

-- 10. Find customers who have purchased tracks from at least 3 different genres

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT g.genre_id) AS genre_count
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT g.genre_id) >= 3
ORDER BY genre_count DESC, customer_name;

-- 11.	Rank genres based on their sales performance in the USA

SELECT 
    g.name AS genre_name,
    SUM(il.unit_price * il.quantity) AS total_sales,
    RANK() OVER (ORDER BY SUM(il.unit_price * il.quantity) DESC) AS genre_rank
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE i.billing_country = 'USA'
GROUP BY g.genre_id, g.name
ORDER BY total_sales DESC;

-- 12.	Identify customers who have not made a purchase in the last 3 months

WITH last_purchase AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.country,
        MAX(i.invoice_date) AS last_invoice_date
    FROM customer c
    LEFT JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.country
),
dataset_end AS (
    SELECT MAX(invoice_date) AS max_invoice_date FROM invoice
)
SELECT 
    lp.customer_id,
    lp.customer_name,
    lp.country,
    lp.last_invoice_date,
    d.max_invoice_date,
    DATEDIFF(d.max_invoice_date, lp.last_invoice_date) AS days_since_last_purchase
FROM last_purchase lp
CROSS JOIN dataset_end d
WHERE lp.last_invoice_date IS NULL OR DATEDIFF(d.max_invoice_date, lp.last_invoice_date) > 90
ORDER BY days_since_last_purchase DESC;

/* Subjective Question */

-- 1. Recommend the three albums from the new record label that should be prioritised for advertising and promotion in the USA based on genre sales analysis.

WITH genre_sales AS (
    SELECT 
        g.genre_id,
        g.name AS genre_name,
        SUM(il.unit_price * il.quantity) AS genre_revenue
    FROM invoice i
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    WHERE i.billing_country = 'USA'
    GROUP BY g.genre_id, g.name
    ORDER BY genre_revenue DESC
    LIMIT 3  -- Top 3 genres in USA
),
album_sales AS (
    SELECT 
        al.album_id,
        al.title AS album_title,
        ar.name AS artist_name,
        t.genre_id,
        SUM(il.unit_price * il.quantity) AS album_revenue
    FROM invoice i
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN album al ON t.album_id = al.album_id
    JOIN artist ar ON al.artist_id = ar.artist_id
    WHERE i.billing_country = 'USA'
    GROUP BY al.album_id, al.title, ar.name, t.genre_id
)
SELECT 
    a.album_title,
    a.artist_name,
    g.genre_name,
    a.album_revenue
FROM album_sales a
JOIN genre_sales g ON a.genre_id = g.genre_id
ORDER BY a.album_revenue DESC
LIMIT 3;

-- 2. Determine the top-selling genres in countries other than the USA and identify any commonalities or differences.

WITH genre_sales AS (
    SELECT 
        i.billing_country,
        g.name AS genre_name,
        SUM(il.unit_price * il.quantity) AS total_revenue
    FROM invoice i
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    WHERE i.billing_country <> 'USA'
    GROUP BY i.billing_country, g.genre_id, g.name
),
ranked_genres AS (
    SELECT 
        billing_country,
        genre_name,
        total_revenue,
        RANK() OVER (PARTITION BY billing_country ORDER BY total_revenue DESC) AS genre_rank
    FROM genre_sales
)
SELECT 
    billing_country,
    genre_name,
    total_revenue,
    genre_rank
FROM ranked_genres
WHERE genre_rank = 1
ORDER BY billing_country;

-- 3.	Customer Purchasing Behavior Analysis: How do the purchasing habits (frequency, basket size, spending amount) of long-term customers differ from those of new customers? What insights can these patterns provide about customer loyalty and retention strategies?

WITH customer_profile AS (
    SELECT 
        c.customer_id,
        MIN(i.invoice_date) AS first_purchase_date,
        MAX(i.invoice_date) AS last_purchase_date,
        COUNT(DISTINCT i.invoice_id) AS total_invoices,
        SUM(i.total) AS lifetime_spend,
        AVG(i.total) AS avg_order_value,
        SUM(il.quantity) AS total_items,
        AVG(il.quantity) AS avg_items_per_invoice
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    GROUP BY c.customer_id
),
dataset_end AS (
    SELECT MAX(invoice_date) AS max_date FROM invoice
)
SELECT 
    cp.customer_id,
    CASE 
        WHEN DATEDIFF(d.max_date, cp.first_purchase_date) <= 365 THEN 'New Customer'
        ELSE 'Long-Term Customer'
    END AS customer_type,
    cp.total_invoices,
    cp.total_items,
    cp.lifetime_spend,
    ROUND(cp.avg_order_value, 2) AS avg_order_value,
    ROUND(cp.avg_items_per_invoice, 2) AS avg_items_per_invoice
FROM customer_profile cp
CROSS JOIN dataset_end d
ORDER BY customer_type, cp.lifetime_spend DESC;

-- 4. Product Affinity Analysis: Which music genres, artists, or albums are frequently purchased together by customers? How can this information guide product recommendations and cross-selling initiatives?

-- A. Genre-Level Affinity

WITH genre_pairs AS (
    SELECT 
        g1.name AS genre_1,
        g2.name AS genre_2,
        COUNT(DISTINCT il1.invoice_id) AS co_purchase_count
    FROM invoice_line il1
    JOIN track t1 ON il1.track_id = t1.track_id
    JOIN genre g1 ON t1.genre_id = g1.genre_id
    JOIN invoice_line il2 ON il1.invoice_id = il2.invoice_id AND il1.track_id < il2.track_id
    JOIN track t2 ON il2.track_id = t2.track_id
    JOIN genre g2 ON t2.genre_id = g2.genre_id
    GROUP BY g1.name, g2.name
    HAVING COUNT(DISTINCT il1.invoice_id) > 1
    ORDER BY co_purchase_count DESC
    LIMIT 10
)
SELECT * FROM genre_pairs;

-- B. Artist-Level Affinity

SELECT 
    ar1.name AS artist_1,
    ar2.name AS artist_2,
    COUNT(DISTINCT il1.invoice_id) AS co_purchase_count
FROM invoice_line il1
JOIN track t1 ON il1.track_id = t1.track_id
JOIN album al1 ON t1.album_id = al1.album_id
JOIN artist ar1 ON al1.artist_id = ar1.artist_id
JOIN invoice_line il2 ON il1.invoice_id = il2.invoice_id AND il1.track_id < il2.track_id
JOIN track t2 ON il2.track_id = t2.track_id
JOIN album al2 ON t2.album_id = al2.album_id
JOIN artist ar2 ON al2.artist_id = ar2.artist_id
GROUP BY ar1.name, ar2.name
HAVING COUNT(DISTINCT il1.invoice_id) > 1
ORDER BY co_purchase_count DESC
LIMIT 10;

-- 5.	Regional Market Analysis: Do customer purchasing behaviors and churn rates vary across different geographic regions or store locations? How might these correlate with local demographic or economic factors?

-- A. Regional Purchasing Behavior

WITH customer_metrics AS (
    SELECT 
        c.country,
        c.customer_id,
        COUNT(DISTINCT i.invoice_id) AS total_invoices,
        SUM(i.total) AS lifetime_spend,
        AVG(i.total) AS avg_order_value,
        SUM(il.quantity) AS total_items,
        AVG(il.quantity) AS avg_items_per_invoice
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    GROUP BY c.country, c.customer_id
)
SELECT 
    country,
    ROUND(AVG(total_invoices), 2) AS avg_invoices_per_customer,
    ROUND(AVG(lifetime_spend), 2) AS avg_lifetime_spend,
    ROUND(AVG(avg_order_value), 2) AS avg_order_value,
    ROUND(AVG(avg_items_per_invoice), 2) AS avg_items_per_invoice
FROM customer_metrics
GROUP BY country
ORDER BY avg_lifetime_spend DESC;

-- B. Regional Churn Rates

WITH last_purchase AS (
    SELECT 
        c.customer_id,
        c.country,
        MAX(i.invoice_date) AS last_invoice_date
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.country
),
dataset_end AS (SELECT MAX(invoice_date) AS max_date FROM invoice)
SELECT 
    lp.country,
    COUNT(lp.customer_id) AS total_customers,
    COUNT(CASE WHEN DATEDIFF(d.max_date, lp.last_invoice_date) > 180 THEN 1 END) AS churned_customers,
    ROUND(COUNT(CASE WHEN DATEDIFF(d.max_date, lp.last_invoice_date) > 180 THEN 1 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM last_purchase lp
CROSS JOIN dataset_end d
GROUP BY lp.country
ORDER BY churn_rate_percent DESC;

-- 6.	Customer Risk Profiling: Based on customer profiles (age, gender, location, purchase history), which customer segments are more likely to churn or pose a higher risk of reduced spending? What factors contribute to this risk?

WITH customer_profile AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country,
        COUNT(DISTINCT i.invoice_id) AS total_invoices,
        SUM(i.total) AS lifetime_spend,
        AVG(i.total) AS avg_order_value,
        MAX(i.invoice_date) AS last_purchase_date,
        MIN(i.invoice_date) AS first_purchase_date
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.country
),
dataset_end AS (
    SELECT MAX(invoice_date) AS max_date FROM invoice
)
SELECT 
    cp.customer_id,
    CONCAT(cp.first_name, ' ', cp.last_name) AS customer_name,
    cp.country,
    cp.total_invoices,
    ROUND(cp.lifetime_spend, 2) AS lifetime_spend,
    ROUND(cp.avg_order_value, 2) AS avg_order_value,
    DATEDIFF(d.max_date, cp.last_purchase_date) AS days_since_last_purchase,
    CASE 
        WHEN DATEDIFF(d.max_date, cp.last_purchase_date) > 180 THEN 'Churned'
        WHEN DATEDIFF(d.max_date, cp.last_purchase_date) BETWEEN 90 AND 180 THEN 'At Risk'
        ELSE 'Active'
    END AS risk_status
FROM customer_profile cp
CROSS JOIN dataset_end d
ORDER BY risk_status, cp.country, lifetime_spend DESC;

-- 7. Customer Lifetime Value Modeling: How can you leverage customer data (tenure, purchase history, engagement) to predict the lifetime value of different customer segments? This could inform targeted marketing and loyalty program strategies. Can you observe any common characteristics or purchase patterns among customers who have stopped purchasing?

WITH customer_profile AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country,
        MIN(i.invoice_date) AS first_purchase_date,
        MAX(i.invoice_date) AS last_purchase_date,
        COUNT(DISTINCT i.invoice_id) AS total_invoices,
        SUM(i.total) AS lifetime_spend,
        AVG(i.total) AS avg_order_value,
        SUM(il.quantity) AS total_items,
        AVG(il.quantity) AS avg_items_per_invoice
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.country
),
dataset_end AS (
    SELECT MAX(invoice_date) AS max_date FROM invoice
)
SELECT 
    cp.customer_id,
    CONCAT(cp.first_name, ' ', cp.last_name) AS customer_name,
    cp.country,
    DATEDIFF(cp.last_purchase_date, cp.first_purchase_date) / 365.0 AS tenure_years,
    cp.total_invoices,
    cp.lifetime_spend,
    ROUND(cp.avg_order_value, 2) AS avg_order_value,
    ROUND(cp.avg_items_per_invoice, 2) AS avg_items_per_invoice,
    DATEDIFF(d.max_date, cp.last_purchase_date) AS days_since_last_purchase,
    CASE 
        WHEN DATEDIFF(d.max_date, cp.last_purchase_date) > 180 THEN 'Churned'
        ELSE 'Active'
    END AS churn_status,
    ROUND(cp.lifetime_spend / NULLIF(DATEDIFF(cp.last_purchase_date, cp.first_purchase_date) / 365.0, 0), 2) AS clv_proxy
FROM customer_profile cp
CROSS JOIN dataset_end d
ORDER BY clv_proxy DESC;

-- 10.	How can you alter the "Albums" table to add a new column named "ReleaseYear" of type INTEGER to store the release year of each album?

SHOW COLUMNS FROM album;
ALTER TABLE album MODIFY ReleaseYear INTEGER NOT NULL;
SELECT * FROM album;

-- 11.	Chinook is interested in understanding the purchasing behavior of customers based on their geographical location. They want to know the average total amount spent by customers from each country, along with the number of customers and the average number of tracks purchased per customer. Write an SQL query to provide this information.

WITH customer_spending AS (
    SELECT 
        c.customer_id,
        c.country,
        SUM(i.total) AS total_spent,
        SUM(il.quantity) AS total_tracks
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    GROUP BY c.customer_id, c.country
)
SELECT 
    country,
    COUNT(customer_id) AS num_customers,
    ROUND(AVG(total_spent), 2) AS avg_total_spent_per_customer,
    ROUND(AVG(total_tracks), 2) AS avg_tracks_per_customer
FROM customer_spending
GROUP BY country
ORDER BY avg_total_spent_per_customer DESC;
