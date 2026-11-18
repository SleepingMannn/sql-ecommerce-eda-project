# Data Catalog

## Overview

The Gold layer contains 3 dimension views and 3 fact views.
The model follows a Fact Constellation Schema.

---

## Source Tables

A total of 9 source tables are processed through the Bronze and Silver layers:

- silver.olist_customers
- silver.olist_geolocation
- silver.olist_order_items
- silver.olist_order_payments
- silver.olist_order_reviews
- silver.olist_orders
- silver.olist_products
- silver.olist_sellers
- silver.product_category_name_translation

The following tables are excluded from the current analytical scope and are not used in the Gold layer:

- silver.olist_geolocation
- silver.olist_order_reviews

These tables remain available in the Silver layer and can be reconsidered if future analytical requirements arise.

---

## Dimensions

### gold.dim_customers

- Purpose: Customer information for customer segmentation.
- Grain: One row per customer_id.
- PK: customer_id.
- Source: silver.olist_customers.

| Column | Description |
|---|---|
| customer_id | Order-specific customer identifier |
| customer_unique_id | Identifier of the actual customer |
| customer_zip_code_prefix | Customer ZIP code prefix |
| customer_city | Customer city |
| customer_state | Customer state |

### gold.dim_sellers

- Purpose: Seller information and location.
- Grain: One row per seller.
- PK: seller_id.
- Source: silver.olist_sellers.

| Column | Description |
|---|---|
| seller_id | Unique seller identifier |
| seller_zip_code_prefix | Seller ZIP code prefix |
| seller_city | Seller city |
| seller_state | Seller state |

### gold.dim_products

- Purpose: Product attributes and categories.
- Grain: One row per product.
- PK: product_id.
- Source: silver.olist_products, silver.product_category_name_translation.

| Column | Description |
|---|---|
| product_id | Unique product identifier |
| product_category_name_english | Product category in English |
| product_weight_g | Product weight in grams |
| product_length_cm | Product length in cm |
| product_height_cm | Product height in cm |
| product_width_cm | Product width in cm |
| product_photos_qty | Number of product photos |
| product_name_length | Product name length |
| product_description_length | Product description length |

---

## Facts

### gold.fact_orders

- Purpose: Order-level metrics and delivery performance.
- Grain: One row per order.
- PK: order_id.
- FK: customer_id → dim_customers.customer_id.
- Source: silver.olist_orders, silver.olist_order_items.

| Column | Description |
|---|---|
| order_id | Unique order identifier |
| customer_id | Customer associated with the order |
| order_status | Current order status in the source |
| order_purchase_timestamp | Order purchase timestamp |
| order_delivered_customer_date | Actual customer delivery timestamp |
| order_estimated_delivery_date | Estimated delivery date |
| delivery_days | Calendar days from purchase to delivery |
| delivery_delay_days | Difference between actual and estimated delivery |
| total_items | Number of order items |
| total_price | Sum of item prices |
| total_freight | Sum of freight values |
| total_order_value | Item price plus freight |

### gold.fact_order_items

- Purpose: Item-level sales and product performance.
- Grain: One row per order item.
- PK: order_id + order_item_id.
- FK: product_id, customer_id, seller_id, order_id.
- Source: silver.olist_order_items, silver.olist_orders.

| Column | Description |
|---|---|
| order_id | Order identifier |
| order_item_id | Item sequence within the order |
| product_id | Product identifier |
| customer_id | Customer associated with the order |
| seller_id | Seller responsible for the item |
| order_status | Order status |
| order_purchase_timestamp | Purchase timestamp |
| price | Item price |
| freight_value | Item freight value |
| item_total_value | Item price plus freight |

### gold.fact_order_payments

- Purpose: Payment methods and payment amounts.
- Grain: One row per payment record.
- PK: order_id + payment_sequential.
- FK: order_id → fact_orders.order_id.
- Source: silver.olist_order_payments.

| Column | Description |
|---|---|
| order_id | Order identifier |
| payment_sequential | Payment sequence within the order |
| payment_type | Payment method |
| payment_installments | Number of installments |
| payment_value | Payment amount |
