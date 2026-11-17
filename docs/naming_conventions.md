# Naming Conventions

## 1. Purpose

This document defines the naming conventions and layer-specific data handling rules used in the Olist E-Commerce SQL project.
The conventions are designed to keep database objects consistent, traceable to the source dataset, and understandable for analytical work.

## 2. General Principles

- **Naming style:** `snake_case` for database objects, columns, scripts, and documentation filenames.
- **Letter case:** lowercase for database, schema, table, view, and column names.
- **Language:** English, except source column names retained for traceability.
- **Database and schemas:** database `olist_ecommerce`; schemas `bronze`, `silver`, `gold`.
- **No reserved words** as object names (for example `order` is a reserved word, so the table is called `olist_orders`).
- **Traceability:** bronze and silver keep the names from the source files, so every object can be traced back to its CSV.
- **Units:** include units in derived column names where useful, for example `delivery_days`, `product_weight_g`, and `product_length_cm`.
- **SQL scripts:**
   - SQL scripts are organized by data layer and operation.
   - DDL scripts define database objects.
   - DML scripts load and transform data.
   - The initialization script creates the database and schemas.

## 3. Database and Schema Naming

| Object | Name | Purpose |
|--------|------|---------|
| Database | `olist_ecommerce` | Project database |
| Schema | `bronze` | Source-aligned data ingestion layer |
| Schema | `silver` | Standardized data layer |
| Schema | `gold` | Business-ready analytical views |

## 4. Layer Rules

### 4.1. Bronze Layer

- Schema: `bronze`.
- Table name: `<source>_<entity>`, taken from the CSV file name without the `_dataset` suffix.
- Data is stored as in the source, but it is **not a fully raw all-text layer**: SQL data types are assigned in the DDL based on the known source formats. Column names stay as in the CSV.

| CSV file | Bronze table |
|----------|--------------|
| `olist_customers_dataset.csv` | `bronze.olist_customers` |
| `olist_geolocation_dataset.csv` | `bronze.olist_geolocation` |
| `olist_order_items_dataset.csv` | `bronze.olist_order_items` |
| `olist_order_payments_dataset.csv` | `bronze.olist_order_payments` |
| `olist_order_reviews_dataset.csv` | `bronze.olist_order_reviews` |
| `olist_orders_dataset.csv` | `bronze.olist_orders` |
| `olist_products_dataset.csv` | `bronze.olist_products` |
| `olist_sellers_dataset.csv` | `bronze.olist_sellers` |
| `product_category_name_translation.csv` | `bronze.product_category_name_translation` |

### 4.2. Silver Layer

- Schema: `silver`.
- Table names are the same as in bronze (`silver.olist_orders`). The schema shows the layer.
- Column names stay the same as in the source, except for:
  - spelling mistakes in the source (`product_name_lenght` → `product_name_length`, `product_description_lenght` → `product_description_length`).
- The corrected names are used in Silver and downstream Gold objects.

### 4.3. Gold Layer

- Schema: `gold`.
- Objects are **views**, named by their purpose with a category prefix:

| Prefix | Meaning | Example |
|--------|---------|---------|
| `dim_` | Dimension view | `gold.dim_customers` |
| `fact_` | Fact view | `gold.fact_order_items` |
| `report_` | Aggregated view for a business question | `gold.report_sales_by_month` |

- Format: `<prefix>_<entity>`, entity name in plural for dimensions (`dim_products`), descriptive for reports.
- New (derived) columns, which get descriptive `snake_case` names, with the unit in the name where useful (`delivery_days`).
- The final list of gold views is defined after data profiling and is documented in the data catalog.

### Current Gold Objects and Grain

| Gold view | Grain — what one row represents | Logical key |
|-----------|---------------------------------|-------------|
| `gold.dim_customers` | One customer record (`customer_id`) | `customer_id` |
| `gold.dim_sellers` | One seller | `seller_id` |
| `gold.dim_products` | One product | `product_id` |
| `gold.fact_orders` | One order | `order_id` |
| `gold.fact_order_items` | One item within an order | (`order_id`, `order_item_id`) |
| `gold.fact_order_payments` | One payment record within an order | (`order_id`, `payment_sequential`) |

These are logical keys documented for the model. The current objects are views; physical primary-key and foreign-key constraints are not created on them.

## 5. SQL Script Naming and Organization

SQL scripts are organized by layer and operation.

| File | Purpose |
|------|---------|
| `scripts/init_database.sql` | Drops/recreates the project database and creates schemas |
| `scripts/bronze/ddl_bronze.sql` | Creates Bronze tables |
| `scripts/bronze/dml_bronze.sql` | Loads source CSV files into Bronze |
| `scripts/silver/ddl_silver.sql` | Creates Silver tables |
| `scripts/silver/dml_silver.sql` | Loads and transforms Bronze data into Silver |
| `scripts/gold/ddl_gold.sql` | Creates Gold dimension and fact views |

- `ddl_` identifies Data Definition Language scripts that create database objects.
- `dml_` identifies Data Manipulation Language scripts that load or modify data.
- `init_database.sql` initializes the database and schemas.
