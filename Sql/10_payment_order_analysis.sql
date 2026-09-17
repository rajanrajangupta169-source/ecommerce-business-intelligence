USE ecommerce_bi;

-- 10 PAYMENT & ORDER ANALYSIS


-- 10.1 PAYMENT METHOD DISTRIBUTION
SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS payment_percentage
FROM payments
GROUP BY payment_type
ORDER BY payment_count DESC;


-- 10.2 REVENUE BY PAYMENT TYPE
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- 10.3 PAYMENT INSTALLMENT ANALYSIS
SELECT
    payment_installments,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
WHERE payment_type = 'credit_card'
GROUP BY payment_installments
ORDER BY payment_installments;


-- 10.4 ORDER STATUS & PAYMENT VALUE
SELECT
    o.order_status,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value,
    ROUND(AVG(p.payment_value), 2) AS average_payment_value
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY o.order_status
ORDER BY total_orders DESC;


-- 10.5 PAYMENT VALUE BY ORDER
SELECT
    p.order_id,
    COUNT(*) AS payment_records,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value,
    MAX(p.payment_installments) AS max_installments
FROM payments p
GROUP BY p.order_id
ORDER BY total_payment_value DESC
LIMIT 10;