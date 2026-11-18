# Data Quality Report

## 1. Scope

| Item | Value |
|------|-------|
| Source | Olist Brazilian E-Commerce Public Dataset (Kaggle), 9 CSV files, CC BY-NC-SA 4.0 |
| Layers checked | Bronze → Silver → Gold (SQL Server 2022) |
| Principle | Bronze is never changed. Values are never invented (no imputing dates or prices). NULL is kept when it has business meaning. Problems are fixed in silver or filtered at metric level in EDA |

## 2. Issues log

| ID | Table | Column | Issue | Row count | Solvable? | Resolution |
|----|-------|--------|-------|-----------|-----------|------------|
| 1 | `olist_geolocation` | `geolocation_zip_code_prefix` | Similar zip codes have a bit different lat and lng coordinates | 19,015 distinct zips from 1,000,613 rows total | N | No changes; retained as is |
| 2 | `olist_geolocation` | `geolocation_city` | Inconsistent spelling in city names | 8,010 | N | No changes; retained as is |
| 3 | `olist_order_items` | `shipping_limit_date` | Inconsistent date, 2020 (outside the order period 2016-2018) | 4 | N | Do not use `shipping_limit_date` for time analysis |
| 4 | `olist_orders` | `order_approved_at` | Inconsistent date formats | 160 | N | No changes; retained as is |
| 5 | `olist_orders` | `order_delivered_carrier_date` | Inconsistent date formats | 1,783 | N | No changes; retained as is |
| 6 | `olist_orders` | `order_delivered_customer_date` | Inconsistent date formats | 2,965 | N | No changes; retained as is |
| 7 | `olist_orders` | `order_delivered_customer_date` | Delivered orders without a delivery date | 8 | N | (NULL), no imputation |
| 8 | `olist_orders` | `order_estimated_delivery_date` | always has time 00:00:00 | 99,441 | Y | Fixed type changed to `DATE` |
| 9 | `olist_products` | `product_category_name` | Category is NULL | 610 | N | **Kept** in silver; **Flagged** in gold as `'unknown'`. Category reports must show `'unknown'`, not drop it | 
| 10 | `olist_products` | `product_name_lenght` & `product_description_lenght` | Column names misspelled in source (`lenght`) | 2 | Y | renamed in silver |
| 11| `olist_products` | `product_weight_g` | zero weight | 4 | N | No changes; retained as is |
| 12 | `product_category_name_translation` | `product_category_name` | 2 categories used by products have no translation | 2 | Y | 2 rows added manually in silver load (`portateis_cozinha_e_preparadores_de_alimentos`, `pc_gamer`). Silver has 2 rows more than bronze | 
| 13 | `olist_customers`, `olist_sellers`, `olist_geolocation` | `..._state` | State stored as 2-letter code | 27 distinct rows | Y | Replaced by full name, unknown code → `'unknown'` |
