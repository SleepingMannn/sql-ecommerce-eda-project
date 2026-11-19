/*
===============================================================================
Quality Checks: Gold Layer
===============================================================================
Purpose:
    Checks that Gold keys are unique and not NULL, that fact views link to
    dimensions, and that joins did not add or lose rows.

Usage:
    Run after ddl_gold.sql. Expectation for every check: no results.
===============================================================================
*/

USE olist_ecommerce;
GO

-- ====================================================================
-- 1. Keys: unique and not NULL
-- ====================================================================
-- gold.dim_customers
SELECT 
    customer_id, 
    COUNT(*)
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;

-- gold.dim_products
SELECT 
    product_id, 
    COUNT(*)
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;

-- gold.dim_sellers
SELECT 
    seller_id, 
    COUNT(*)
FROM gold.dim_sellers
GROUP BY seller_id
HAVING COUNT(*) > 1 OR seller_id IS NULL;

-- gold.fact_orders: one row per order
SELECT 
    order_id, 
    COUNT(*)
FROM gold.fact_orders
GROUP BY order_id
HAVING COUNT(*) > 1 OR order_id IS NULL;

-- gold.fact_order_items: one row per (order_id, order_item_id)
SELECT 
    order_id, 
    order_item_id, 
    COUNT(*)
FROM gold.fact_order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1 OR order_id IS NULL OR order_item_id IS NULL;

-- gold.fact_order_payments: one row per (order_id, payment_sequential)
SELECT 
    order_id, 
    payment_sequential, 
    COUNT(*)
FROM gold.fact_order_payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1 OR order_id IS NULL OR payment_sequential IS NULL;

-- ====================================================================
-- 2. Connectivity: every fact row finds its parent row
-- ====================================================================
-- gold.fact_order_items -> dimensions and fact_orders
SELECT 
    oi.order_id, 
    oi.order_item_id
FROM gold.fact_order_items oi
LEFT JOIN gold.dim_products pr  
    ON oi.product_id = pr.product_id
LEFT JOIN gold.dim_sellers se   
    ON oi.seller_id = se.seller_id
LEFT JOIN gold.dim_customers cu 
    ON oi.customer_id = cu.customer_id
LEFT JOIN gold.fact_orders o    
    ON oi.order_id = o.order_id
WHERE pr.product_id IS NULL OR se.seller_id IS NULL OR cu.customer_id IS NULL OR o.order_id IS NULL;

-- gold.fact_orders -> gold.dim_customers
SELECT 
    o.order_id
FROM gold.fact_orders o
LEFT JOIN gold.dim_customers c 
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- gold.fact_order_payments -> gold.fact_orders
SELECT 
    p.order_id, 
    p.payment_sequential
FROM gold.fact_order_payments p
LEFT JOIN gold.fact_orders o 
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;
