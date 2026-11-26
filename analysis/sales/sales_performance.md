## 1. Sales Performance Analysis

### 1.1. Business Question

How are platform sales distributed across product categories, 
and which categories contribute the most to Product Sales Value?

### 1.2. Business Context

Identify the leading product categories and areas that may require 
further investigation when evaluating assortment development.

### 1.3. Required Metrics

- Product Sales Value — SUM(price).
- Items Sold — number of order items.
- Average Price per Item — Product Sales Value / Items Sold.
- Category Share — category Product Sales Value as a percentage of total.
- MoM Change — Product Sales Value minus the previous month's value.

### 1.4. Data Sources & Grain

- Source: gold.report_sales (built from gold.fact_order_items, gold.dim_products).
- Analysis includes delivered orders only, 2016-09 to 2018-08.
- Reporting grain: one row per product category per calendar month.
- Definitions: [`docs/metric_definitions.md`](docs/metric_definitions.md).

### 1.5. SQL Analysis

SQL queries: [`sales_performance.sql`](sales_performance.sql).

### 1.6. Findings

Total Product Sales Value is 13,221,498.11. health_beauty generated 1,233,131.72 (9.33% of the total), ranking first by value and second by quantity.

The five leading categories accounted for 39.83% of total Product Sales Value. bed_bath_table leads by quantity (10,953 items) but ranks third by value (7.74%).

The five largest month-category values are all in 2018; health_beauty holds three of them (June, July, August).

Monthly Product Sales Value grew from 111,798.36 (2017-01) to a peak of 987,765.37 in 2017-11 (+52.4% vs October, fifth consecutive monthly increase), then fell 26.5% in December.

In 2018, monthly values stayed between 826,437.13 and 977,545 (May peak); August 2018 is 14.2% below May and 51.2% above August 2017.

### 1.7. Interpretation

health_beauty is a major contributor to both sales value and volume.

Differences between category rankings may indicate variations in average prices or product mix.

The largest month-category values fall in 2018 because platform volume was higher then, so category shares within a month are a better comparison than absolute values.

The November 2017 peak followed by a December decline may reflect seasonality or promotions (a hypothesis; the dataset has no campaign data).

### 1.8. Recommendations

Review the five leading categories at product level before assortment decisions; compare sales value, quantity and average price per item.

Compare category shares by month for November 2017 and mid-2018 to separate seasonality from category growth.

Additional data needed: product cost (to assess profitability of high-volume categories such as bed_bath_table) and a promotion/campaign calendar (to explain the November 2017 peak).
