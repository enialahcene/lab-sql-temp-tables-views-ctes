CREATE VIEW rental_summary AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email;


CREATE TEMPORARY TABLE payment_summary AS
SELECT 
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM 
    rental_summary rs
JOIN 
    payment p ON rs.customer_id = p.customer_id
GROUP BY 
    rs.customer_id;

WITH customer_summary AS (
    SELECT 
        rs.customer_id,
        rs.first_name,
        rs.last_name,
        rs.email,
        rs.rental_count,
        ps.total_paid
    FROM 
        rental_summary rs
    JOIN 
        payment_summary ps ON rs.customer_id = ps.customer_id
)
SELECT 
    cs.first_name,
    cs.last_name,
    cs.email,
    cs.rental_count,
    cs.total_paid,
    (cs.total_paid / cs.rental_count) AS average_payment_per_rental
FROM 
    customer_summary cs
ORDER BY 
    cs.first_name, cs.last_name;

