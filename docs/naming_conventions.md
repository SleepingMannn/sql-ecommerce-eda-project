# Naming Conventions

This document defines the naming rules for the database objects, scripts and files in this project.
The same style (`snake_case`) is used as in my Data Warehouse project, adapted to a single-source EDA project.

## Table of Contents

1. [General Principles](#general-principles)
2. [Layer Rules](#layer-rules)
   - [Bronze](#bronze-layer)
   - [Silver](#silver-layer)
   - [Gold](#gold-layer)

---

## General Principles

- **Style:** `snake_case`: only lowercase letters, digits and underscores, words separated by `_`.
- **Language:** English.
- **Database and schemas:** database `olist_ecommerce`; schemas `bronze`, `silver`, `gold`.
- **No reserved words** as object names (for example `order` is a reserved word, so the table is called `olist_orders`).
- **Traceability:** bronze and silver keep the names from the source files, so every object can be traced back to its CSV.
- **SQL scripts:** `NN_<purpose>.sql`, numbered in the order of execution (`01_create_tables.sql`).

---

## Layer Rules

### Bronze Layer

- Schema: `bronze`.
- Table name: `<source>_<entity>`, taken from the CSV file name without the `_dataset` suffix.
- Data is stored as in the source, without changes. Column names stay as in the CSV.

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

### Silver Layer

- Schema: `silver`.
- Table names are the same as in bronze (`silver.olist_orders`). The schema shows the layer.
- Column names stay the same as in the source, except for:
  - spelling mistakes in the source (`product_name_lenght` → `product_name_length`, `product_description_lenght` → `product_description_length`);
  - new (derived) columns, which get descriptive `snake_case` names, with the unit in the name where useful (`delivery_days`, `order_month`).

### Gold Layer

- Schema: `gold`.
- Objects are **views**, named by their purpose with a category prefix:

| Prefix | Meaning | Example |
|--------|---------|---------|
| `dim_` | Dimension view | `gold.dim_customers` |
| `fact_` | Fact view | `gold.fact_order_items` |
| `report_` | Aggregated view for a business question | `gold.report_sales_by_month` |

- Format: `<prefix>_<entity>`, entity name in plural for dimensions (`dim_products`), descriptive for reports.
- The final list of gold views is defined after data profiling and is documented in the data catalog.
