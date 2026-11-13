/*
===============================================================================
Script: Load Bronze Layer (Bronze → Silver)
===============================================================================
...
===============================================================================
*/
USE OlistEcommerce;   -- change to the actual database name
GO

PRINT '==================================================================';
PRINT 'Loading Silver Layer';
PRINT '==================================================================';

-- #1 olist_customers_dataset
TRUNCATE TABLE silver.olist_customers;

INSERT INTO silver.olist_customers (
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state)
SELECT 
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	TRIM(customer_city) AS customer_city,
	CASE UPPER(TRIM(customer_state))
		WHEN 'AC' THEN 'Acre'
		WHEN 'AL' THEN 'Alagoas'
		WHEN 'AM' THEN 'Amazonas'
		WHEN 'AP' THEN 'Amapá'
		WHEN 'BA' THEN 'Bahia'
		WHEN 'CE' THEN 'Ceará'
		WHEN 'DF' THEN 'Distrito Federal'
		WHEN 'ES' THEN 'Espírito Santo'
		WHEN 'GO' THEN 'Goiás'
		WHEN 'MA' THEN 'Maranhão'
		WHEN 'MG' THEN 'Minas Gerais'
		WHEN 'MS' THEN 'Mato Grosso do Sul'
		WHEN 'MT' THEN 'Mato Grosso'
		WHEN 'PA' THEN 'Pará'
		WHEN 'PB' THEN 'Paraíba'
		WHEN 'PE' THEN 'Pernambuco'
		WHEN 'PI' THEN 'Piauí'
		WHEN 'PR' THEN 'Paraná'
		WHEN 'RJ' THEN 'Rio de Janeiro'
		WHEN 'RN' THEN 'Rio Grande do Norte'
		WHEN 'RO' THEN 'Rondônia'
		WHEN 'RR' THEN 'Roraima'
		WHEN 'RS' THEN 'Rio Grande do Sul'
		WHEN 'SC' THEN 'Santa Catarina'
		WHEN 'SE' THEN 'Sergipe'
		WHEN 'SP' THEN 'São Paulo'
		WHEN 'TO' THEN 'Tocantins'
		ELSE 'n/a'
	END AS customer_state
FROM bronze.olist_customers;

-- #2 olist_geolocation_dataset
TRUNCATE TABLE silver.olist_geolocation;

INSERT INTO silver.olist_geolocation (
	geolocation_zip_code_prefix,
	geolocation_lat,
	geolocation_lng,
	geolocation_city,
	geolocation_state)
SELECT
	TRIM(geolocation_zip_code_prefix),
	geolocation_lat,
	geolocation_lng,
	TRIM(geolocation_city),
	CASE UPPER(TRIM(geolocation_state))
		WHEN 'AC' THEN 'Acre'
		WHEN 'AL' THEN 'Alagoas'
		WHEN 'AM' THEN 'Amazonas'
		WHEN 'AP' THEN 'Amapá'
		WHEN 'BA' THEN 'Bahia'
		WHEN 'CE' THEN 'Ceará'
		WHEN 'DF' THEN 'Distrito Federal'
		WHEN 'ES' THEN 'Espírito Santo'
		WHEN 'GO' THEN 'Goiás'
		WHEN 'MA' THEN 'Maranhão'
		WHEN 'MG' THEN 'Minas Gerais'
		WHEN 'MS' THEN 'Mato Grosso do Sul'
		WHEN 'MT' THEN 'Mato Grosso'
		WHEN 'PA' THEN 'Pará'
		WHEN 'PB' THEN 'Paraíba'
		WHEN 'PE' THEN 'Pernambuco'
		WHEN 'PI' THEN 'Piauí'
		WHEN 'PR' THEN 'Paraná'
		WHEN 'RJ' THEN 'Rio de Janeiro'
		WHEN 'RN' THEN 'Rio Grande do Norte'
		WHEN 'RO' THEN 'Rondônia'
		WHEN 'RR' THEN 'Roraima'
		WHEN 'RS' THEN 'Rio Grande do Sul'
		WHEN 'SC' THEN 'Santa Catarina'
		WHEN 'SE' THEN 'Sergipe'
		WHEN 'SP' THEN 'São Paulo'
		WHEN 'TO' THEN 'Tocantins'
		ELSE 'n/a'
	END AS customer_state
FROM bronze.olist_geolocation;

-- #3 olist_order_items_dataset
TRUNCATE TABLE silver.olist_order_items;
  
INSERT INTO silver.olist_order_items (
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date,
	price,
	freight_value)
SELECT 
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date,
	price,
	freight_value
FROM bronze.olist_order_items;

-- #4 olist_order_payments_dataset
TRUNCATE TABLE silver.olist_order_payments;

INSERT INTO silver.olist_order_payments (
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value)
SELECT 
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value
FROM bronze.olist_order_payments;

-- #5 olist_order_reviews_dataset
TRUNCATE TABLE silver.olist_order_reviews;

INSERT INTO silver.olist_order_reviews (
	review_id,
	order_id,
	review_score,
	review_comment_title,
	review_comment_message,
	review_creation_date,
	review_answer_timestamp
)
SELECT
	review_id,
	order_id,
	review_score,
	review_comment_title,
	review_comment_message,
	review_creation_date,
	review_answer_timestamp
FROM bronze.olist_order_reviews;

-- #6 olist_orders_dataset
TRUNCATE TABLE silver.olist_orders;

INSERT INTO silver.olist_orders (
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp,
	order_approved_at,
	order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivery_date)
SELECT
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp,
	order_approved_at,
	order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivery_date
FROM bronze.olist_orders;

-- #7 olist_products_dataset
TRUNCATE TABLE silver.olist_products;

INSERT INTO silver.olist_products (
	product_id,
	product_category_name,
	product_name_length,
	product_description_length,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm)
SELECT
	product_id,
	product_category_name,
	product_name_lenght AS product_name_length,
	product_description_lenght AS product_description_length,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
FROM bronze.olist_products;

-- #8 olist_sellers_dataset
TRUNCATE TABLE silver.olist_sellers;

INSERT INTO silver.olist_sellers (
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state)
SELECT
	seller_id,
	seller_zip_code_prefix,
	TRIM(seller_city) AS seller_city,
	CASE UPPER(TRIM(seller_state))
		WHEN 'AC' THEN 'Acre'
		WHEN 'AL' THEN 'Alagoas'
		WHEN 'AM' THEN 'Amazonas'
		WHEN 'AP' THEN 'Amapá'
		WHEN 'BA' THEN 'Bahia'
		WHEN 'CE' THEN 'Ceará'
		WHEN 'DF' THEN 'Distrito Federal'
		WHEN 'ES' THEN 'Espírito Santo'
		WHEN 'GO' THEN 'Goiás'
		WHEN 'MA' THEN 'Maranhão'
		WHEN 'MG' THEN 'Minas Gerais'
		WHEN 'MS' THEN 'Mato Grosso do Sul'
		WHEN 'MT' THEN 'Mato Grosso'
		WHEN 'PA' THEN 'Pará'
		WHEN 'PB' THEN 'Paraíba'
		WHEN 'PE' THEN 'Pernambuco'
		WHEN 'PI' THEN 'Piauí'
		WHEN 'PR' THEN 'Paraná'
		WHEN 'RJ' THEN 'Rio de Janeiro'
		WHEN 'RN' THEN 'Rio Grande do Norte'
		WHEN 'RO' THEN 'Rondônia'
		WHEN 'RR' THEN 'Roraima'
		WHEN 'RS' THEN 'Rio Grande do Sul'
		WHEN 'SC' THEN 'Santa Catarina'
		WHEN 'SE' THEN 'Sergipe'
		WHEN 'SP' THEN 'São Paulo'
		WHEN 'TO' THEN 'Tocantins'
		ELSE 'n/a'
	END AS seller_state
FROM bronze.olist_sellers;

-- #9 product_category_name_translation
TRUNCATE TABLE silver.product_category_name_translation;

INSERT INTO silver.product_category_name_translation (
	product_category_name,
	product_category_name_english)
SELECT
	product_category_name,
	product_category_name_english
FROM bronze.product_category_name_translation;
