USE ecommerce_bi;

-- ================================================================
-- 06 SALES ANALYSIS
-- ================================================================

-- 6.1 OVERALL SALES KPIs
SELECT
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_sales_value,
    ROUND(AVG(oi.price), 2) AS average_item_price
FROM order_items oi;


-- 6.2 AVERAGE ORDER VALUE (AOV)
SELECT
    ROUND(SUM(price) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM order_items;


-- 6.3 MONTHLY SALES TREND
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(oi.order_id) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(SUM(oi.freight_value), 2) AS freight
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY sales_month;


-- 6.4 YEARLY SALES PERFORMANCE
SELECT
    YEAR(o.order_purchase_timestamp) AS sales_year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(oi.order_id) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY sales_year;


-- 6.5 SALES BY ORDER STATUS
SELECT
    o.order_status,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_status
ORDER BY total_orders DESC;


-- 6.6 MONTHLY REVENUE GROWTH
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
        ROUND(SUM(oi.price), 2) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT
    sales_month,
    revenue,
    LAG(revenue) OVER (ORDER BY sales_month) AS previous_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY sales_month))
        / NULLIF(LAG(revenue) OVER (ORDER BY sales_month), 0) * 100,
        2
    ) AS growth_percentage
FROM monthly_sales
ORDER BY sales_month;


-- 6.7 TOP 10 ORDERS BY REVENUE
SELECT
    o.order_id,
    o.order_purchase_timestamp,
    ROUND(SUM(oi.price), 2) AS order_revenue,
    ROUND(SUM(oi.freight_value), 2) AS freight_value,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS order_total
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.order_purchase_timestamp
ORDER BY order_revenue DESC
LIMIT 10;