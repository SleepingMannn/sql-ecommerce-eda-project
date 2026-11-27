## 2. Orders and Delivery Performance Analysis

### 2.1. Business Question

How efficiently are orders fulfilled, and where do delivery issues arise?

### 2.2. Business Context

Identify periods or regions that require further study of logistics.

### 2.3. Required Metrics

- Orders by Status and Order Status Share.
- Average Delivery Time.
- Late Rate and On-time Delivery Rate.
- Average Delay (late orders only).
- Late Rate by month and state (at least 30 delivered orders per month and state).

### 2.4. Data Sources & Grain

- Source: gold.report_orders_delivery (built from gold.fact_orders, gold.dim_customers).
- Order status metrics: all 99,441 orders. Delivery metrics: 96,470 delivered orders with a delivery date, purchased 2016-09 to 2018-08.
- Reporting grain: one row per order.
- Definitions: `docs/metric_definitions.md`.

### 2.5. SQL Analysis

SQL queries: [`orders_delivery_performance.sql`](orders_delivery_performance.sql).

### 2.6. Findings

Of 99,441 orders, 96,478 (97.02%) were delivered, 1,729 (1.74%) are still in progress (shipped, invoiced, processing, created, approved) and 1,234 (1.24%) were canceled or unavailable.

Delivered orders with a delivery date (96,470) took 12.50 calendar days on average. 8 delivered orders without a delivery date are excluded. 93.23% (89,936) of these orders arrived on time or early and 6.77% (6,534) arrived late. Late orders were delivered 10.62 days after the estimated date on average.

From 2017-01 to 2018-08, the monthly late rate was between 1.16% and 7.46%, except in 2017-11 (12.40%), 2018-02 (14.13%) and 2018-03 (18.96%). These three months contain 48.33% of all late orders (3,158 of 6,534) and 21.6% of delivered orders; without them the late rate is 4.46%.

Among states with at least 500 delivered orders, the late rate was highest in Maranhao (17.43%), Ceara (13.76%), Bahia (12.16%) and Rio de Janeiro (12.11%), and lowest in Parana (4.04%), Sao Paulo (4.49%) and Minas Gerais (4.57%). Rio de Janeiro has 12.8% of delivered orders but 22.88% of late orders; Sao Paulo has 41.98% and 27.85%.

The highest late rates by month and state (at least 30 delivered orders) are Maranhao in 2017-11 (52.83%) and 2018-03 (51.02%), Para (50.75%) and Ceara (50.54%) in 2018-03. In Rio de Janeiro the late rate was 25.99% in 2017-11, 23.99% in 2017-12 and about 34% in 2018-02 and 2018-03.

### 2.7. Interpretation

Most orders are delivered (97.02%) and 93.23% of delivered orders arrive on time or early, so delays are concentrated in specific periods and regions rather than spread evenly.

Three months hold almost half of all late orders. 2017-11 has the highest order volume in the dataset (7,289 delivered orders). The causes of the 2018-02 and 2018-03 peak cannot be determined from this dataset.

Rio de Janeiro drives the delays in these months (13%-34% late from 2017-11 to 2018-03 versus 4.83% in 2018-04). Late rates are also high in states such as Maranhao and Ceara.

The dataset does not define the status `unavailable`; together with `canceled` it covers 1.24% of orders and is treated as unfulfilled orders.

### 2.8. Recommendations

Study logistics in the peak months (2017-11, 2018-02, 2018-03) and in the states with the highest late rates (Maranhao, Ceara, Rio de Janeiro): compare order volume, delivery time and late rate.

Compare delivery time by state and by seller state versus customer state to separate distance effects from capacity effects.

Review how the estimated delivery date is set: check whether it is too optimistic in peak months and too conservative in other periods.

Clarify the meaning of the `unavailable` status with the business before treating it as a cancellation.

Additional data needed: carrier and shipping method, seller location or distance (geolocation is excluded from Gold), and order reviews (available in Silver) to link delays with customer ratings.
