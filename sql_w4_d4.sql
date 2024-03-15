Use sakila;
-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
CREATE VIEW customer_rental_summary AS
SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;
-- Step 2: Create a Temporary Table to calculate the total amount paid by each customer:
CREATE TEMPORARY TABLE temp_customer_payment AS
SELECT crs.customer_id, SUM(p.amount) AS total_paid
FROM customer_rental_summary crs
JOIN payment p ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;
-- Step 3: Create a CTE and the Customer Summary Report:
WITH customer_summary_cte AS (
    SELECT crs.first_name || ' ' || crs.last_name AS customer_name,
           crs.email,
           crs.rental_count,
           tcp.total_paid,
           tcp.total_paid / crs.rental_count AS average_payment_per_rental
    FROM customer_rental_summary crs
    JOIN temp_customer_payment tcp ON crs.customer_id = tcp.customer_id
)
SELECT *
FROM customer_summary_cte;

