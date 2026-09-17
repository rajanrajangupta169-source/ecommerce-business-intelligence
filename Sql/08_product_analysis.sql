USE ecommerce_bi;

-- 08 PRODUCT ANALYSIS


-- 8.1 PRODUCT PERFORMANCE OVERVIEW
SELECT
    COUNT(DISTINCT oi.product_id) AS products_sold,
    COUNT(*) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS average_product_price
FROM order_items oi;


-- 8.2 TOP 10 PRODUCTS BY REVENUE
SELECT
    oi.product_id,
    p.product_category_name,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    oi.product_id,
    p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;


-- 8.3 TOP 10 PRODUCTS BY QUANTITY SOLD
SELECT
    oi.product_id,
    p.product_category_name,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    oi.product_id,
    p.product_category_name
ORDER BY items_sold DESC
LIMIT 10;


-- 8.4 CATEGORY PERFORMANCE
SELECT
    COALESCE(p.product_category_name, 'Unknown') AS category,
    COUNT(*) AS items_sold,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS average_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    COALESCE(p.product_category_name, 'Unknown')
ORDER BY total_revenue DESC
LIMIT 20;


-- 8.5 CATEGORY TRANSLATION - TOP ENGLISH CATEGORIES
SELECT
    ct.product_category_name_english AS category,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 20;


-- 8.6 PRODUCT FREIGHT ANALYSIS
SELECT
    oi.product_id,
    p.product_category_name,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.freight_value), 2) AS total_freight,
    ROUND(AVG(oi.freight_value), 2) AS average_freight
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    oi.product_id,
    p.product_category_name
ORDER BY total_freight DESC
LIMIT 10;