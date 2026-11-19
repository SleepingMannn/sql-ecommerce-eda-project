# Data Quality Report

## 1. Scope

| Item | Description |
|---|---|
| Source | Olist Brazilian E-Commerce Public Dataset (Kaggle), 9 CSV files |
| Database | SQL Server 2022 |
| Layers | Bronze, Silver and Gold |
| Approach | Preserve source data in Bronze. Standardize data in Silver where appropriate. Retain source anomalies and apply filters at metric level when necessary. Do not invent missing values. |

## 2. Data Quality Issues

| Table | Column | Finding | Rows / Values | Handling |
|---|---|---|---:|---|
| `olist_order_items` | `shipping_limit_date` | Dates outside the expected 2016–2018 dataset period (year 2020) | 4 rows | Retained in Silver; exclude from relevant time-based analysis |
| `olist_orders` | `order_approved_at` | Missing approval timestamps | 160 rows | Retained as `NULL` |
| `olist_orders` | `order_delivered_carrier_date` | Missing carrier timestamps | 1,783 rows | Retained as `NULL` |
| `olist_orders` | `order_delivered_customer_date` | Missing customer delivery timestamps | 2,965 rows | Retained as `NULL` |
| `olist_orders` | `order_delivered_customer_date` | Delivered orders without an actual delivery date | 8 rows | Retained as `NULL`; excluded from delivery-time calculations |
| `olist_orders` | `order_estimated_delivery_date` | Time component is always `00:00:00` | 99,441 rows | Converted to `DATE` in Silver |
| `olist_products` | `product_category_name` | Missing product categories | 610 rows | Retained as `NULL` in Silver; displayed as `unknown` in Gold |
| `olist_products` | `product_name_lenght`, `product_description_lenght` | Source column names contain spelling errors | 2 columns | Renamed in Silver |
| `olist_products` | `product_weight_g` | Zero product weight | 4 rows | Retained without modification |
| `product_category_name_translation` | `product_category_name` | Product categories have no source translation | 2 categories | Added project-defined English translations in Silver |
| `olist_customers`, `olist_sellers`, `olist_geolocation` | `*_state` | State values stored as two-letter codes | 27 distinct codes | Standardized to full state names in Silver; unmapped codes become `unknown` |

**Notes**
- Missing timestamps are not replaced with estimated dates.
- The 8 delivered orders without a delivery date are included in the 2,965 rows with missing customer delivery timestamps.
- The two manually added category translations are project-defined values, not original Olist translations.
- Row counts are issue-specific; the same record may be included in more than one finding.

### Product Category Translation

Five spelling errors were identified in the English category names provided by the source dataset.

The errors were corrected during the Bronze-to-Silver transformation. Additionally, two missing English category translations were added for categories present in the products dataset.

Original Bronze data remains unchanged.

| Correction Type | Count |
|---|---:|
| Spelling corrections | 5 |
| Added translations | 2 |
| Total Silver records | 73 |

## 3. Excluded Tables

| Table | Status | Reason |
|---|---|---|
| `olist_geolocation` | EXCLUDED | Geographical analysis is outside the current project scope. Retained in Bronze and Silver. |
| `olist_order_reviews` | EXCLUDED | Review analysis is outside the current Gold layer scope. Retained in Bronze and Silver. |

Exclusion does not mean that a table failed validation. These tables are intentionally outside the current analytical scope.

## 4. Known Limitations

| Limitation | Impact on Analysis |
|---|---|
| No product cost data | Profit and profit margin cannot be calculated. |
| Geolocation is excluded from the current scope | Distance-based and detailed geographical analysis will not be performed. |
| Reviews are excluded from the current Gold scope | Review scores and their relationship with delivery or sales will not be analyzed in this project version. |
| Historical dataset (2016–2018) | Findings describe the historical dataset and may not represent current marketplace performance. |
