/*
Purpose:
    Validates Silver data quality after Bronze-to-Silver loading.

Checks:
    - Row count preservation.
    - Logical key uniqueness and NULLs.
    - Data validity and consistency.
    - Standardization and transformation results.

Usage:
    Run after Silver data loading.
    Investigate unexpected results; do not modify source data.
*/

-- #1 Row Preservation
-- Compare Bronze and Silver row counts. Expected: matching counts, except for documented transformations.
SELECT
    'olist_customers' AS table_name,
    (SELECT COUNT(*) FROM bronze.olist_customers) AS bronze_rows,
    (SELECT COUNT(*) FROM silver.olist_customers) AS silver_rows
UNION ALL
SELECT
    'olist_order_items',
    (SELECT COUNT(*) FROM bronze.olist_order_items),
    (SELECT COUNT(*) FROM silver.olist_order_items)
UNION ALL
SELECT
    'olist_order_payments',
    (SELECT COUNT(*) FROM bronze.olist_order_payments),
    (SELECT COUNT(*) FROM silver.olist_order_payments)
UNION ALL
SELECT
    'olist_orders',
    (SELECT COUNT(*) FROM bronze.olist_orders),
    (SELECT COUNT(*) FROM silver.olist_orders)
UNION ALL
SELECT
    'olist_products',
    (SELECT COUNT(*) FROM bronze.olist_products),
    (SELECT COUNT(*) FROM silver.olist_products)
UNION ALL
SELECT
    'olist_sellers',
    (SELECT COUNT(*) FROM bronze.olist_sellers),
    (SELECT COUNT(*) FROM silver.olist_sellers)
UNION ALL
SELECT
    'olist_order_reviews',
    (SELECT COUNT(*) FROM bronze.olist_order_reviews),
    (SELECT COUNT(*) FROM silver.olist_order_reviews)
UNION ALL
SELECT
    'olist_geolocation',
    (SELECT COUNT(*) FROM bronze.olist_geolocation),
    (SELECT COUNT(*) FROM silver.olist_geolocation)
UNION ALL
SELECT
    'product_category_name_translation',
    (SELECT COUNT(*) FROM bronze.product_category_name_translation),
    (SELECT COUNT(*) FROM silver.product_category_name_translation);

-- #2 Key Validation
-- Check for NULL values in logical key columns. Expected result: 0.
-- Apply to:
--   customers: customer_id
--   order_items: order_id, order_item_id
--   order_payments: order_id, payment_sequential
--   order_reviews: review_id, order_id
--   orders: order_id
--   products: product_id
--   sellers: seller_id
--   product_category_name_translation: product_category_name

-- Example:
SELECT *
FROM silver.olist_order_items
WHERE order_id IS NULL 
  OR order_item_id IS NULL;

-- Check for duplicate logical keys. Expected result: 0.
-- Use the logical keys listed above. Group by ALL columns forming the key.

-- Example:
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicates
FROM silver.olist_order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

-- #3 Completeness & Validity
-- Check date sequence. Review returned records; do not automatically remove them.
SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM silver.olist_orders
WHERE
       order_purchase_timestamp > order_approved_at
    OR order_purchase_timestamp > order_delivered_customer_date
    OR order_purchase_timestamp > order_delivered_carrier_date
    OR order_approved_at > order_delivered_carrier_date
    OR order_delivered_carrier_date > order_delivered_customer_date;

-- Check missing order dates by status. NULLs may be expected depending on the order status.
SELECT
    order_status,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS missing_purchase,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS missing_approved,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS missing_carrier,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS missing_customer,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS missing_estimated
FROM silver.olist_orders
GROUP BY order_status
ORDER BY order_status;

-- Check review score validity. Expected: values between 1 and 5.
SELECT *
FROM silver.olist_order_reviews
WHERE review_score IS NULL
   OR review_score NOT BETWEEN 1 AND 5;

-- Check negative payment values. Expected: 0.
SELECT *
FROM silver.olist_order_payments
WHERE payment_value IS NULL
   OR payment_value < 0;

-- Check invalid order item values. Review zero values separately before treating them as errors.
SELECT *
FROM silver.olist_order_items
WHERE price IS NULL
   OR price < 0
   OR freight_value IS NULL
   OR freight_value < 0;

-- Check known shipping limit date anomalies. The four records dated in 2020 should be reviewed.
SELECT *
FROM silver.olist_order_items
WHERE shipping_limit_date >= '20200101'
  AND shipping_limit_date < '20210101';

-- #4 Consistency
-- Check for unwanted leading or trailing spaces. Expected result: 0.
SELECT
    customer_city
FROM silver.olist_customers
WHERE customer_city != TRIM(customer_city);

-- #5 Transformation Validation
-- Check state standardization. Expected: no remaining two-letter state codes.
-- Apply to:
--   silver.olist_customers.customer_state
--   silver.olist_sellers.seller_state

-- Example:
SELECT DISTINCT 
  customer_state
FROM silver.olist_customers
WHERE customer_state = 'unknown';

-- Check product category translation coverage. Expected: no missing translations for non-NULL product categories.
SELECT DISTINCT
    p.product_category_name
FROM silver.olist_products AS p
LEFT JOIN silver.product_category_name_translation AS t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL;

-- Check duplicate category mappings. Expected result: 0.
SELECT
    product_category_name,
    COUNT(*) AS duplicates
FROM silver.product_category_name_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;
