USE ecommerce_bi;

SELECT
    'customers' AS table_name,
    COUNT(*) AS row_count
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






-- 4.1 CUSTOMERS DATA IMPORT
-- ================================================================

USE ecommerce_bi;

LOAD DATA LOCAL INFILE 'C:/Users/Rajan/OneDrive/Desktop/ecommerce-business-intelligence/Data/cleaned/customers_clean.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



USE ecommerce_bi;




-- 4.2 ORDERS
-- ================================================================

LOAD DATA LOCAL INFILE 'C:/Users/Rajan/OneDrive/Desktop/ecommerce-business-intelligence/Data/cleaned/orders_clean.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
);


-- 4.3 PRODUCTS
-- ================================================================

LOAD DATA LOCAL INFILE 'C:/Users/Rajan/OneDrive/Desktop/ecommerce-business-intelligence/Data/cleaned/products_clean.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
);


-- 4.4 SELLERS
-- ================================================================

LOAD DATA LOCAL INFILE 'C:/Users/Rajan/OneDrive/Desktop/ecommerce-business-intelligence/Data/cleaned/sellers_clean.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
);


-- 4.5 ORDER ITEMS
-- ================================================================

LOAD DATA LOCAL INFILE 'C:/Users/Rajan/OneDrive/Desktop/ecommerce-business-intelligence/Data/cleaned/order_items_clean.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
);


-- 4.6 PAYMENTS
-- ================================================================

LOAD DATA LOCAL INFILE 'C:/Users/Rajan/OneDrive/Desktop/ecommerce-business-intelligence/Data/cleaned/payments_clean.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
);


-- 4.7 REVIEWS
-- ================================================================

LOAD DATA LOCAL INFILE 'C:/Users/Rajan/OneDrive/Desktop/ecommerce-business-intelligence/Data/cleaned/reviews_clean.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
);


-- 4.8 GEOLOCATION
-- ================================================================

LOAD DATA LOCAL INFILE 'C:/Users/Rajan/OneDrive/Desktop/ecommerce-business-intelligence/Data/cleaned/geolocation_clean.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
);


-- 4.9 CATEGORY TRANSLATION
-- ================================================================

LOAD DATA LOCAL INFILE 'C:/Users/Rajan/OneDrive/Desktop/ecommerce-business-intelligence/Data/cleaned/category_translation_clean.csv'
INTO TABLE category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_category_name,
    product_category_name_english
);




