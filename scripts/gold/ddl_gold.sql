/*
Purpose:
    Creates 3 dimension views and 3 fact views for business analysis.

Model:
    Fact Constellation Schema (Galaxy Schema).

Notes:
    Each view has a defined grain and logical key.
    Order items are aggregated before joining to fact_orders.
    Delivery metrics are calculated in calendar days.
*/

USE olist_ecommerce;
GO

-- Grain: one row per customer_id.
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
FROM silver.olist_customers;
GO

-- Grain: one row per seller_id.
IF OBJECT_ID('gold.dim_sellers', 'V') IS NOT NULL
    DROP VIEW gold.dim_sellers;
GO

CREATE VIEW gold.dim_sellers AS
SELECT
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
FROM silver.olist_sellers;
GO

-- Grain: one row per product_id.
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
	p.product_id,
	COALESCE(t.product_category_name_english, 'unknown') AS product_category_name_english,
	p.product_weight_g,
	p.product_length_cm,
	p.product_height_cm,
	p.product_width_cm,
	p.product_photos_qty,
	p.product_name_length,
	p.product_description_length
FROM silver.olist_products p
LEFT JOIN silver.product_category_name_translation t
ON p.product_category_name = t.product_category_name;
GO

-- Grain: one row per order item.
IF OBJECT_ID('gold.fact_order_items', 'V') IS NOT NULL
    DROP VIEW gold.fact_order_items;
GO

CREATE VIEW gold.fact_order_items AS 
SELECT 
	i.order_id, 
	i.order_item_id, 
	i.product_id, 
	o.customer_id,
	i.seller_id, 
	o.order_status,
	o.order_purchase_timestamp,
	i.price, 
	i.freight_value,
	i.price + i.freight_value AS item_total_value
FROM silver.olist_order_items i
LEFT JOIN silver.olist_orders o
	ON i.order_id = o.order_id;
GO

-- Grain: one row per order.
IF OBJECT_ID('gold.fact_orders', 'V') IS NOT NULL
    DROP VIEW gold.fact_orders;
GO

CREATE VIEW gold.fact_orders AS 
SELECT
	o.order_id,
	o.customer_id,
	o.order_status,
	o.order_purchase_timestamp,
	o.order_delivered_customer_date,
	o.order_estimated_delivery_date,
	CASE 
		WHEN o.order_status = 'delivered' THEN DATEDIFF(day, o.order_purchase_timestamp, o.order_delivered_customer_date) 
	END AS delivery_days,
	CASE 
		WHEN o.order_status = 'delivered' THEN DATEDIFF(day, o.order_estimated_delivery_date, o.order_delivered_customer_date) 
	END AS delivery_delay_days,           -- A positive value indicates a delay; a negative value indicates early delivery.
	i.total_items,
	i.total_price,
	i.total_freight,
	i.total_price + i.total_freight AS total_order_value
FROM silver.olist_orders o
LEFT JOIN (
	SELECT
		order_id,
		COUNT(*) AS total_items,
		SUM(price) AS total_price,
		SUM(freight_value) AS total_freight
	FROM silver.olist_order_items
	GROUP BY order_id
	) i
	ON o.order_id = i.order_id;
GO

-- Grain: one row per payment record.
IF OBJECT_ID('gold.fact_order_payments', 'V') IS NOT NULL
    DROP VIEW gold.fact_order_payments;
GO

CREATE VIEW gold.fact_order_payments AS 
SELECT
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value
FROM silver.olist_order_payments;
GO
