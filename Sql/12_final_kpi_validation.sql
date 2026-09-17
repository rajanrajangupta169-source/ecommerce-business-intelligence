USE ecommerce_bi;

-- ================================================================
-- 12 FINAL KPI VALIDATION
-- ================================================================

-- 12.1 TOTAL ORDERS
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


-- 12.2 TOTAL ITEMS SOLD
SELECT
    COUNT(*) AS total_items_sold
FROM order_items;


-- 12.3 TOTAL REVENUE
SELECT
    ROUND(SUM(price), 2) AS total_revenue
FROM order_items;


-- 12.4 TOTAL CUSTOMERS
SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;


-- 12.5 TOTAL PRODUCTS
SELECT
    COUNT(*) AS total_products
FROM products;


-- 12.6 TOTAL FREIGHT
SELECT
    ROUND(SUM(freight_value), 2) AS total_freight
FROM order_items;


-- 12.7 AVERAGE ORDER VALUE
SELECT
    ROUND(
        SUM(price) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;


-- 12.8 FINAL KPI SUMMARY
SELECT
    (SELECT COUNT(DISTINCT order_id)
     FROM orders) AS total_orders,

    (SELECT COUNT(*)
     FROM order_items) AS total_items_sold,

    (SELECT ROUND(SUM(price), 2)
     FROM order_items) AS total_revenue,

    (SELECT COUNT(DISTINCT customer_unique_id)
     FROM customers) AS total_customers,

    (SELECT COUNT(*)
     FROM products) AS total_products,

    (SELECT ROUND(SUM(freight_value), 2)
     FROM order_items) AS total_freight,

    (SELECT ROUND(
        SUM(price) / COUNT(DISTINCT order_id), 2)
     FROM order_items) AS average_order_value;