USE ecommerce_bi;
-- 07 CUSTOMER ANALYSIS
-- ================================================================

-- 7.1 CUSTOMER OVERVIEW
SELECT
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,
    ROUND(
        COUNT(DISTINCT customer_id) /
        COUNT(DISTINCT customer_unique_id), 2
    ) AS avg_customer_ids_per_unique_customer
FROM customers;

-- 7.2 TOP 10 CUSTOMERS BY REVENUE
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY total_revenue DESC
LIMIT 10;


-- 7.3 CUSTOMER ORDERS AND SPENDING
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_spent,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 20;

-- 7.4 REPEAT VS ONE-TIME CUSTOMERS
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM customer_orders
GROUP BY
    CASE
        WHEN order_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END;
    
    -- 7.5 CUSTOMER REVENUE SEGMENTATION
WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        ROUND(SUM(oi.price), 2) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN total_revenue < 100 THEN 'Low Value'
        WHEN total_revenue < 500 THEN 'Medium Value'
        ELSE 'High Value'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_revenue), 2) AS segment_revenue
FROM customer_revenue
GROUP BY
    CASE
        WHEN total_revenue < 100 THEN 'Low Value'
        WHEN total_revenue < 500 THEN 'Medium Value'
        ELSE 'High Value'
    END
ORDER BY segment_revenue DESC;

