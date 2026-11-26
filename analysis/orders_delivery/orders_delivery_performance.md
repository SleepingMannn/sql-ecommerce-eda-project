## 1. Orders and Delivery Performance Analysis

### 1.1. Business Question

How efficiently are orders fulfilled, and where do delivery issues arise?

### 1.2. Business Context

Identify periods and customer regions that may require further investigation of delivery performance.

### 1.3. Required Metrics

- Order Status Distribution — number and share of orders by status.
- Average Delivery Time — average time from purchase to customer delivery.
- Late Delivery Rate — percentage of delivered orders arriving after the estimated date.
- On-Time Delivery Rate — percentage of delivered orders arriving on or before the estimated date.
- Average Delay — average number of days late among late orders.
- Monthly and Regional Trends — late delivery rates by purchase month and customer state.

### 1.4. Data Sources & Grain

- Source: gold.report_orders_delivery (built from gold.fact_orders, gold.dim_customers).
- Analysis includes delivered orders only, 2016-09 to 2018-08.
- Reporting grain: One row per order.
- Definitions: `docs/metric_definitions.md`

### 1.5. SQL Analysis

SQL queries: [`orders_delivery_performance.sql`](orders_delivery_performance.sql).

### 1.6. Findings

The average delivery time was 12.50 calendar days, based on 96,470 delivered orders with valid delivery dates.

Among these orders, 93.23% were delivered on time or earlier, while 6.77% were delivered late (6,534 orders).

Late orders had an average delay of 10.62 calendar days.

Eight delivered orders were excluded from delivery-time and delay calculations because the required delivery date was missing.

State-level monthly results showed elevated late-delivery rates in several periods. Examples include Maranhão in November 2017 (52.83%, 28 of 53 orders), 
Ceará in March 2018 (50.54%, 47 of 93), Pará in March 2018 (50.75%, 34 of 67), and Rio de Janeiro in March 2018 (34.49%, 298 of 864).

### 1.7. Interpretation

Most orders in the dataset were delivered, and the majority of delivered orders arrived on time or earlier.

However, the 6.77% late-delivery rate indicates an area for further investigation. The average delay of 10.62 days among late orders suggests that some delays were substantial.

Late-delivery rates varied across states and months. The observed differences identify periods and regions worth investigating, but do not establish the causes of delays.

The eight delivered orders without valid delivery dates were excluded from delivery metrics and should be considered when interpreting the results.

### 1.8. Recommendations

Investigate the state-month combinations with elevated late-delivery rates, prioritizing both the percentage of late orders and the number of affected orders.

Compare delivery performance across regions and periods to identify recurring patterns rather than relying on isolated monthly results.

Monitor late-delivery and on-time delivery rates over time to evaluate whether operational changes improve delivery performance.
