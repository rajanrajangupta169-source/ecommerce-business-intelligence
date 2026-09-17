USE ecommerce_bi;

-- 4.1 ROW COUNT EXPLORATION

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers

UNION ALL
SELECT 'orders', COUNT(*) FROM orders

UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items

UNION ALL
SELECT 'payments', COUNT(*) FROM payments

UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews

UNION ALL
SELECT 'products', COUNT(*) FROM products

UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers

UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation

UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation;



-- 4.2 COLUMN STRUCTURE INSPECTION

DESCRIBE customers;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE payments;
DESCRIBE reviews;
DESCRIBE products;
DESCRIBE sellers;
DESCRIBE geolocation;
DESCRIBE category_translation;



-- 4.3 DISTINCT / CATEGORICAL VALUE EXPLORATION

-- Order Status
SELECT DISTINCT order_status
FROM orders
ORDER BY order_status;


-- Payment Types
SELECT DISTINCT payment_type
FROM payments
ORDER BY payment_type;


-- Customer States
SELECT DISTINCT customer_state
FROM customers
ORDER BY customer_state;


-- Seller States
SELECT DISTINCT seller_state
FROM sellers
ORDER BY seller_state;


-- Product Categories
SELECT DISTINCT product_category_name
FROM products
ORDER BY product_category_name;


-- English Product Categories
SELECT DISTINCT product_category_name_english
FROM category_translation
ORDER BY product_category_name_english;



-- 4.4 DATE RANGE EXPLORATION

-- Order Purchase Date Range
SELECT
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date
FROM orders;


-- Order Delivery Date Range
SELECT
    MIN(order_delivered_customer_date) AS first_delivery_date,
    MAX(order_delivered_customer_date) AS last_delivery_date
FROM orders;


-- Estimated Delivery Date Range
SELECT
    MIN(order_estimated_delivery_date) AS first_estimated_date,
    MAX(order_estimated_delivery_date) AS last_estimated_date
FROM orders;


-- Review Creation Date Range
SELECT
    MIN(review_creation_date) AS first_review_date,
    MAX(review_creation_date) AS last_review_date
FROM reviews;





-- 4.5 IMPORTANT NULL VALUE EXPLORATION

SELECT
    'orders' AS table_name,
    SUM(order_purchase_timestamp IS NULL) AS null_purchase_date,
    SUM(order_approved_at IS NULL) AS null_approved_date,
    SUM(order_delivered_customer_date IS NULL) AS null_delivery_date
FROM orders

UNION ALL

SELECT
    'products',
    SUM(product_category_name IS NULL),
    SUM(product_weight_g IS NULL),
    SUM(product_length_cm IS NULL)
FROM products

UNION ALL

SELECT
    'reviews',
    SUM(review_score IS NULL),
    SUM(review_comment_title IS NULL),
    SUM(review_comment_message IS NULL)
FROM reviews;





-- 4.6 IMPORTANT NUMERIC SUMMARY


-- Order Items Price & Freight
SELECT
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(SUM(price), 2) AS total_sales_value,
    ROUND(SUM(freight_value), 2) AS total_freight_value
FROM order_items;


-- Review Score Distribution
SELECT
    review_score,
    COUNT(*) AS review_count
FROM reviews
GROUP BY review_score
ORDER BY review_score;