/*
Purpose:
    Creates 3 reporting views for business analysis:
        - Sales Performance
        - Orders and Delivery Performance
        - Customer Performance

Model:
    Reporting views built on top of the Gold Layer.
*/

USE olist_ecommerce;
GO

-- Grain: one row per product category per calendar month.
IF OBJECT_ID('gold.report_sales', 'V') IS NOT NULL
    DROP VIEW gold.report_sales;
GO

CREATE VIEW gold.report_sales AS
WITH base_query AS(
    SELECT
        DATEFROMPARTS(YEAR(oi.order_purchase_timestamp), MONTH(oi.order_purchase_timestamp), 1) AS month_start,
        oi.order_id,
        oi.order_item_id,
        oi.product_id,
        cu.customer_unique_id,
        pr.product_category_name_english AS product_category,
        oi.price,
        oi.freight_value
    FROM gold.fact_order_items oi
    LEFT JOIN gold.dim_products pr
        ON oi.product_id = pr.product_id
    LEFT JOIN gold.dim_customers cu
        ON oi.customer_id = cu.customer_id
    WHERE oi.order_status = 'delivered'
),

monthly_category AS (
    SELECT
        month_start,
        product_category,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT customer_unique_id) AS total_customers,
        COUNT(*) AS total_quantity,
        SUM(price) AS product_sales_value,
        SUM(freight_value) AS freight_value,
        ROUND(AVG(price), 2) AS avg_selling_price
    FROM base_query
    GROUP BY month_start, product_category
)

SELECT
    month_start,
    product_category,
    total_orders,
    total_customers,
    total_quantity,
    product_sales_value,
    freight_value,
    product_sales_value + freight_value AS sales_value_with_freight,
    avg_selling_price
FROM monthly_category;
GO

-- Grain: one row per order.
IF OBJECT_ID('gold.report_orders_delivery', 'V') IS NOT NULL
    DROP VIEW gold.report_orders_delivery;
GO

CREATE VIEW gold.report_orders_delivery AS
WITH base_query AS(
    SELECT
    	o.order_id,
    	c.customer_state,
    	o.order_status,
    	o.order_purchase_timestamp,
    	o.order_delivered_customer_date,
    	o.order_estimated_delivery_date,
    	o.delivery_days,
    	o.delivery_delay_days
    FROM gold.fact_orders o
    LEFT JOIN gold.dim_customers c
    ON o.customer_id = c.customer_id
)
SELECT
	order_id,
	customer_state,
	order_status,
	CASE
		WHEN order_status != 'delivered' THEN 'not_applicable'
		WHEN delivery_delay_days IS NULL THEN 'unknown'
		WHEN delivery_delay_days > 0 THEN 'late'
		ELSE 'on-time'
	END AS delivery_status,
	order_purchase_timestamp,
	order_delivered_customer_date,
	order_estimated_delivery_date,
	delivery_days,
	delivery_delay_days
FROM base_query;
GO

-- Grain:
--     Customer Behavior: one row per customer segment.
--     Customer Geography: one row per customer state.
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS
WITH base_query AS(
	SELECT
		o.order_id,
		c.customer_unique_id,
		c.customer_state,
		o.total_items,
		o.total_price,
		o.total_freight,
		o.total_order_value AS sales_value_with_freight
	FROM gold.fact_orders o
	LEFT JOIN gold.dim_customers c
		ON o.customer_id = c.customer_id
	WHERE o.order_status = 'delivered'
)

, customer_behavior AS (
	SELECT
		customer_unique_id,
		COUNT(order_id) AS total_orders,
		SUM(total_items) AS total_items,
		SUM(total_price) AS product_sales_value,
		SUM(total_freight) AS total_freight,
		SUM(sales_value_with_freight) AS sales_value_with_freight,
		CASE
			WHEN COUNT(order_id) > 1 THEN 'Repeat Customer'
			ELSE 'One-time Customer'
		END AS customer_type
	FROM base_query
	GROUP BY customer_unique_id
)

, customer_geographic AS (
	SELECT
		customer_state,
		COUNT(DISTINCT customer_unique_id) AS total_customers,
		COUNT(order_id) AS total_orders,
		SUM(total_items) AS total_items,
		SUM(total_price) AS product_sales_value,
		SUM(total_freight) AS total_freight,
		SUM(sales_value_with_freight) AS sales_value_with_freight
	FROM base_query
	GROUP BY customer_state
)
-- Combined summary: Customer Behavior + Customer Geography
SELECT
    'Customer Behavior' AS analysis_type,
    customer_type AS segment,
    COUNT(*) AS total_customers,
    SUM(total_orders) AS total_orders,
    SUM(total_items) AS total_items,
    SUM(product_sales_value) AS product_sales_value,
    SUM(total_freight) AS total_freight,
    SUM(sales_value_with_freight) AS sales_value_with_freight
FROM customer_behavior
GROUP BY customer_type
UNION ALL
SELECT
    'Customer Geography' AS analysis_type,
    COALESCE(customer_state, 'unknown') AS segment,
    SUM(total_customers) AS total_customers,
    SUM(total_orders) AS total_orders,
    SUM(total_items) AS total_items,
    SUM(product_sales_value) AS product_sales_value,
    SUM(total_freight) AS total_freight,
    SUM(sales_value_with_freight) AS sales_value_with_freight
FROM customer_geographic
GROUP BY customer_state;
