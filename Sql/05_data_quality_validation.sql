USE ecommerce_bi;

-- 5.1 PRIMARY KEY VALIDATION
-- Check for NULL and Duplicate Primary Keys

-- Customers
SELECT
    'customers' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_ids,
    SUM(customer_id IS NULL) AS null_ids,
    COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_count
FROM customers;


-- Orders
SELECT
    'orders' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_ids,
    SUM(order_id IS NULL) AS null_ids,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_count
FROM orders;


-- Products
SELECT
    'products' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_ids,
    SUM(product_id IS NULL) AS null_ids,
    COUNT(*) - COUNT(DISTINCT product_id) AS duplicate_count
FROM products;


-- Sellers
SELECT
    'sellers' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_ids,
    SUM(seller_id IS NULL) AS null_ids,
    COUNT(*) - COUNT(DISTINCT seller_id) AS duplicate_count
FROM sellers;


-- Reviews
SELECT
    'reviews' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_ids,
    SUM(review_id IS NULL) AS null_ids,
    COUNT(*) - COUNT(DISTINCT review_id) AS duplicate_count
FROM reviews;


-- 5.2 COMPOSITE PRIMARY KEY VALIDATION


-- Order Items
SELECT
    'order_items' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(order_id, '-', order_item_id)) AS unique_keys,
    SUM(order_id IS NULL OR order_item_id IS NULL) AS null_key_values,
    COUNT(*) - COUNT(DISTINCT CONCAT(order_id, '-', order_item_id)) AS duplicate_keys
FROM order_items;


-- Payments
SELECT
    'payments' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(order_id, '-', payment_sequential)) AS unique_keys,
    SUM(order_id IS NULL OR payment_sequential IS NULL) AS null_key_values,
    COUNT(*) - COUNT(DISTINCT CONCAT(order_id, '-', payment_sequential)) AS duplicate_keys
FROM payments;


USE ecommerce_bi;

-- 5.3 FOREIGN KEY / ORPHAN RECORD VALIDATION

SELECT
    'orders → customers' AS relationship,
    COUNT(*) AS orphan_records
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT
    'order_items → orders',
    COUNT(*)
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'payments → orders',
    COUNT(*)
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'reviews → orders',
    COUNT(*)
FROM reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
    'order_items → products',
    COUNT(*)
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL

SELECT
    'order_items → sellers',
    COUNT(*)
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;



-- 5.4 IMPORTANT NULL VALUE VALIDATION

SELECT
    'orders' AS table_name,
    SUM(order_purchase_timestamp IS NULL) AS null_purchase_date,
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(order_status IS NULL) AS null_order_status
FROM orders

UNION ALL

SELECT
    'order_items',
    SUM(order_id IS NULL),
    SUM(product_id IS NULL),
    SUM(price IS NULL)
FROM order_items

UNION ALL

SELECT
    'payments',
    SUM(order_id IS NULL),
    SUM(payment_type IS NULL),
    SUM(payment_value IS NULL)
FROM payments

UNION ALL

SELECT
    'products',
    SUM(product_id IS NULL),
    SUM(product_category_name IS NULL),
    SUM(product_weight_g IS NULL)
FROM products

UNION ALL

SELECT
    'reviews',
    SUM(review_id IS NULL),
    SUM(order_id IS NULL),
    SUM(review_score IS NULL)
FROM reviews;


-- ================================================================
-- 5.5 DATE CONSISTENCY VALIDATION
-- ================================================================

SELECT
    'Approved before Purchase' AS validation_check,
    COUNT(*) AS invalid_records
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_approved_at < order_purchase_timestamp

UNION ALL

SELECT
    'Delivery before Purchase',
    COUNT(*)
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp

UNION ALL

SELECT
    'Estimated Delivery before Purchase',
    COUNT(*)
FROM orders
WHERE order_estimated_delivery_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_estimated_delivery_date < order_purchase_timestamp;


-- ================================================================
-- 5.6 NUMERIC VALUE VALIDATION
-- ================================================================

SELECT
    'order_items' AS table_name,
    SUM(price < 0) AS negative_price,
    SUM(freight_value < 0) AS negative_freight
FROM order_items

UNION ALL

SELECT
    'payments',
    SUM(payment_value < 0),
    SUM(payment_installments <= 0)
FROM payments

UNION ALL

SELECT
    'reviews',
    SUM(review_score < 1 OR review_score > 5),
    0
FROM reviews;


-- ================================================================
-- 5.7 FINAL DATA QUALITY SUMMARY
-- ================================================================

SELECT
    'customers' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_keys,
    SUM(customer_id IS NULL) AS null_keys
FROM customers

UNION ALL

SELECT
    'orders',
    COUNT(*),
    COUNT(DISTINCT order_id),
    SUM(order_id IS NULL)
FROM orders

UNION ALL

SELECT
    'order_items',
    COUNT(*),
    COUNT(DISTINCT CONCAT(order_id, '-', order_item_id)),
    SUM(order_id IS NULL OR order_item_id IS NULL)
FROM order_items

UNION ALL

SELECT
    'payments',
    COUNT(*),
    COUNT(DISTINCT CONCAT(order_id, '-', payment_sequential)),
    SUM(order_id IS NULL OR payment_sequential IS NULL)
FROM payments

UNION ALL

SELECT
    'reviews',
    COUNT(*),
    COUNT(DISTINCT review_id),
    SUM(review_id IS NULL)
FROM reviews

UNION ALL

SELECT
    'products',
    COUNT(*),
    COUNT(DISTINCT product_id),
    SUM(product_id IS NULL)
FROM products

UNION ALL

SELECT
    'sellers',
    COUNT(*),
    COUNT(DISTINCT seller_id),
    SUM(seller_id IS NULL)
FROM sellers

UNION ALL

SELECT
    'category_translation',
    COUNT(*),
    COUNT(DISTINCT product_category_name),
    SUM(product_category_name IS NULL)
FROM category_translation;

USE ecommerce_bi;

-- ================================================================
-- INVESTIGATE DATE INCONSISTENCIES
-- ================================================================

-- 1. Approved before Purchase
SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_approved_at < order_purchase_timestamp
LIMIT 20;


-- 2. Delivery before Purchase
SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp
LIMIT 20;


-- 3. Invalid Payment Installments
SELECT
    order_id,
    payment_type,
    payment_installments,
    payment_value
FROM payments
WHERE payment_installments <= 0;


USE ecommerce_bi;

-- 5.8 FINAL DATA QUALITY VALIDATION

SELECT
    'Foreign Key Orphans' AS validation_check,
    (
        (SELECT COUNT(*) FROM orders o
         LEFT JOIN customers c ON o.customer_id = c.customer_id
         WHERE c.customer_id IS NULL)
        +
        (SELECT COUNT(*) FROM order_items oi
         LEFT JOIN orders o ON oi.order_id = o.order_id
         WHERE o.order_id IS NULL)
        +
        (SELECT COUNT(*) FROM payments p
         LEFT JOIN orders o ON p.order_id = o.order_id
         WHERE o.order_id IS NULL)
        +
        (SELECT COUNT(*) FROM reviews r
         LEFT JOIN orders o ON r.order_id = o.order_id
         WHERE o.order_id IS NULL)
        +
        (SELECT COUNT(*) FROM order_items oi
         LEFT JOIN products p ON oi.product_id = p.product_id
         WHERE p.product_id IS NULL)
        +
        (SELECT COUNT(*) FROM order_items oi
         LEFT JOIN sellers s ON oi.seller_id = s.seller_id
         WHERE s.seller_id IS NULL)
    ) AS issue_count

UNION ALL

SELECT
    'Invalid Payment Installments',
    COUNT(*)
FROM payments
WHERE payment_installments <= 0

UNION ALL

SELECT
    'Negative Prices',
    COUNT(*)
FROM order_items
WHERE price < 0

UNION ALL

SELECT
    'Invalid Review Scores',
    COUNT(*)
FROM reviews
WHERE review_score < 1 OR review_score > 5

UNION ALL

SELECT
    'Approved Before Purchase',
    COUNT(*)
FROM orders
WHERE order_approved_at < order_purchase_timestamp

UNION ALL

SELECT
    'Delivery Before Purchase',
    COUNT(*)
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;