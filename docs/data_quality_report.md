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
| 1 | `olist_order_items` | `shipping_limit_date` | Date outside expected dataset period, 2020 (outside the order period 2016-2018) | 4 | N | Do not use `shipping_limit_date` for time analysis |
| 2 | `olist_orders` | `order_approved_at` | Missing approved timestamp | 160 | N | No changes; retained as is |
| 3 | `olist_orders` | `order_delivered_carrier_date` | Missing carrier timestamp | 1,783 | N | No changes; retained as is |
| 4 | `olist_orders` | `order_delivered_customer_date` | Missing customer timestamp | 2,965 | N | No changes; retained as is |
| 5 | `olist_orders` | `order_delivered_customer_date` | Delivered orders without a delivery date | 8 | N | (NULL), no imputation |
| 6 | `olist_orders` | `order_estimated_delivery_date` | always has time 00:00:00 | 99,441 | Y | Fixed type changed to `DATE` |
| 7 | `olist_products` | `product_category_name` | Category is NULL | 610 | N | **Kept** in silver; **Flagged** in gold as `'unknown'`. Category reports must show `'unknown'`, not drop it | 
| 8 | `olist_products` | `product_name_lenght` & `product_description_lenght` | Column names misspelled in source (`lenght`) | 2 | Y | renamed in silver |
| 9| `olist_products` | `product_weight_g` | zero weight | 4 | N | No changes; retained as is |
| 10 | `product_category_name_translation` | `product_category_name` | 2 categories used by products have no translation | 2 | Y | 2 rows added manually in silver load (`portateis_cozinha_e_preparadores_de_alimentos`, `pc_gamer`). Silver has 2 rows more than bronze | 
| 11 | `olist_customers`, `olist_sellers`, `olist_geolocation` | `..._state` | State stored as 2-letter code | 27 distinct rows | Y | Replaced by full name, unknown code → `'unknown'` |

## 3. Excluded Information

| Table | Status | Decision |
|---|---|---|
| olist_geolocation | EXCLUDED | Retained in Bronze/Silver. Not used in Gold because geographical analysis is outside the project scope. |
| olist_order_reviews | EXCLUDED | Retained in Bronze/Silver. Not used in Gold because review analysis is outside the project scope. |
