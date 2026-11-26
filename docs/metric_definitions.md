# Metric Definitions

Definitions used in `analysis/`.

## 1. Analysis Rules

| Rule | Value |
|---|---|
| Analysis period | All available data. Delivered orders: 2016-09 to 2018-08; trends are interpreted from 2017-02 (2016 is 0.31% of sales) |
| Date basis | `order_purchase_timestamp` (month of purchase) |
| Order scope | Sales and Customers: delivered orders. Order status share: all statuses |
| Delivery metrics | Delivered orders with a delivery date; calendar days (DATEDIFF) |
| Sales value | `price` without `freight_value` |
| Unknown category | Kept as `unknown` |

## 2. Sales Performance

| Metric | Definition | Source | Notes |
|---|---|---|---|
| Product Sales Value | SUM(price) | report_sales | Excludes freight |
| Items Sold | Number of order item rows | report_sales | One row = one unit |
| Avg Price per Item | Product Sales Value / Items Sold | report_sales | Weighted |
| Category Share, % | Category value / total value x 100 | report_sales | Includes `unknown` |
| MoM Change | Month value - previous month value | report_sales | Previous month present in the data; interpreted from 2017-02 |

## 3. Orders and Delivery

| Metric | Definition | Source | Notes |
|---|---|---|---|
| Order Status Share, % | Orders in status / all orders x 100 | report_orders_delivery | All statuses |
| Avg Delivery Time | AVG(delivery_days), cast to DECIMAL | report_orders_delivery | Delivered with a delivery date |
| Late Order | delivery_delay_days > 0 | report_orders_delivery | On time = 0 or earlier |
| Late Rate, % | Late / (late + on_time) x 100 | report_orders_delivery | Excludes orders without delay value |
| Avg Delay | AVG(delivery_delay_days), cast to DECIMAL | report_orders_delivery | Among late orders only |
| Region | customer_state | report_orders_delivery | Destination state, not seller state |

## 4. Customer Analysis

| Metric | Definition | Source | Notes |
|---|---|---|---|
| Customer | customer_unique_id with 1+ delivered order | report_customers | Not customer_id |
| One-time / Repeat | 1 / 2+ delivered orders | report_customers | Whole-history segment |
| Repeat Rate, % | Repeat customers / all customers x 100 | report_customers | |
| Avg Orders per Customer | Delivered orders / customers | report_customers | |
| Purchase Value | SUM(total_price) | report_customers | Excludes freight |
| Customers by State | Customers per customer_state | report_customers | A customer can appear in several states; sum is above unique customers |
