# Naming Conventions

---

## 1. Purpose

This document defines the naming conventions and layer-specific data handling rules used in the Olist E-Commerce SQL project.
The conventions are designed to keep database objects consistent, traceable to the source dataset, and understandable for analytical work.

---

## 2. General Principles

- **Naming style:** `snake_case` for database objects, columns, scripts, and documentation filenames.
- **Letter case:** lowercase for database, schema, table, view, and column names.
- **Language:** English, except source column names retained for traceability.
- **Database and schemas:** database `olist_ecommerce`; schemas `bronze`, `silver`, `gold`.
- **No reserved words** as object names (for example `order` is a reserved word, so the table is called `olist_orders`).
- **Traceability:** bronze and silver keep the names from the source files, so every object can be traced back to its CSV.
- **Units:** include units in derived column names where useful, for example `delivery_days`, `product_weight_g`, and `product_length_cm`.

---

## 3. Database and Schema Naming

| Object | Name | Purpose |
|--------|------|---------|
| Database | `olist_ecommerce` | Project database |
| Schema | `bronze` | Source-aligned data ingestion layer |
| Schema | `silver` | Standardized data layer |
| Schema | `gold` | Business-ready analytical views |

---

## 4. Layer Rules

### 4.1. Bronze Layer

- Schema: `bronze`.
- Table name: `<source>_<entity>`, taken from the CSV file name without the `_dataset` suffix.
- Data is stored as in the source, but it is **not a fully raw all-text layer**: SQL data types are assigned in the DDL based on the known source formats. Column names stay as in the CSV.

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

---

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
| `scripts/gold/ddl_gold_reports.sql` | Creates Gold report views |
| `tests/quality_checks_silver.sql`, `tests/quality_checks_gold.sql` | Data quality checks per layer |
| `analysis/<block>/<block>.sql` | EDA queries: metrics, sources, SQL |
| `analysis/<block>/<block>.md` | Business question, findings and recommendations |
| `docs/metric_definitions.md` | Metric definitions and analysis rules |
