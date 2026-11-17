/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Purpose:
    Creates the business-ready layer: 3 dimension views and 3 fact views
    (a fact constellation: several star schemas sharing dimensions).
    Views store no data; they read Silver every time.

Objects (grain = what one row means):
    gold.dim_customers        1 row = 1 customer_id (new for every order);
                              the real person is customer_unique_id
    gold.dim_sellers          1 row = 1 seller
    gold.dim_products         1 row = 1 product; category in English,
                              missing category = 'unknown'
    gold.fact_order_items     1 row = 1 item in an order
                              (key: order_id + order_item_id)
    gold.fact_orders          1 row = 1 order; items are aggregated to order
                              level before joining, so rows are not multiplied
    gold.fact_order_payments  1 row = 1 payment record
                              (key: order_id + payment_sequential)

Rules:
    - delivery_days / delivery_delay_days are calculated only for delivered
      orders, in calendar days. delivery_delay_days > 0 means late delivery.
    - Orders without items have NULL totals (no items is not the same as 0).
    - Do not join fact tables to each other directly: aggregate one side to
      order level first, or rows will be multiplied.
===============================================================================
*/

USE olist_ecommerce;
GO

-- gold.dim_customers where granularity 1 row = 1 customer_id, always unique (customer_unique_id for multiple purchases of one client)
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

-- gold.dim_sellers where granularity 1 row = 1 seller
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

-- gold.dim_products where granularity 1 row = 1 product
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

-- gold.fact_order_items where granularity 1 row = 1 position in order
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

-- gold.fact_orders where granularity 1 row = 1 order
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

-- gold.fact_order_payments where granularity 1 row = 1 payment record
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
