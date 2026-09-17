USE ecommerce_bi;

-- ================================================================
-- 11 ADVANCED SQL ANALYSIS
-- ================================================================


-- 11.1 CUSTOMER LIFETIME VALUE (CLV)
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS lifetime_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY lifetime_value DESC
LIMIT 20;


-- 11.2 RFM ANALYSIS
-- Recency, Frequency, Monetary Value

WITH customer_rfm AS (
    SELECT
        c.customer_unique_id,
        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp) FROM orders),
            MAX(o.order_purchase_timestamp)
        ) AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        ROUND(SUM(oi.price), 2) AS monetary
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    recency,
    frequency,
    monetary,
    CASE
        WHEN recency <= 90 AND frequency >= 2 AND monetary >= 500
            THEN 'High Value'
        WHEN recency <= 180 AND frequency >= 2
            THEN 'Loyal'
        WHEN recency > 365
            THEN 'At Risk'
        ELSE 'Regular'
    END AS customer_segment
FROM customer_rfm
ORDER BY monetary DESC
LIMIT 50;


-- 11.3 PRODUCT REVENUE RANKING
WITH product_sales AS (
    SELECT
        oi.product_id,
        p.product_category_name,
        COUNT(*) AS items_sold,
        ROUND(SUM(oi.price), 2) AS revenue
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        oi.product_id,
        p.product_category_name
)
SELECT
    product_id,
    product_category_name,
    items_sold,
    revenue,
    DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM product_sales
ORDER BY revenue_rank
LIMIT 20;


-- 11.4 MONTHLY REVENUE WITH RUNNING TOTAL
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
        ROUND(SUM(oi.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT
    sales_month,
    monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER (
            ORDER BY sales_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS running_revenue
FROM monthly_sales
ORDER BY sales_month;


-- 11.5 CATEGORY REVENUE CONTRIBUTION
WITH category_sales AS (
    SELECT
        p.product_category_name AS category,
        ROUND(SUM(oi.price), 2) AS revenue
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
)
SELECT
    category,
    revenue,
    ROUND(
        revenue * 100.0 / SUM(revenue) OVER (),
        2
    ) AS revenue_percentage
FROM category_sales
ORDER BY revenue DESC;