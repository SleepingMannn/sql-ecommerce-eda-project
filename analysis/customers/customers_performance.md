## 3. Customer Analysis

### 3.1. Business Question

How do customers use the platform, and how often do they return?

### 3.2. Business Context

Understand how much the business depends on attracting new customers and whether there is potential to increase repeat purchases.

### 3.3. Required Metrics

- Unique Customers.
- Repeat Rate — share of customers with 2 or more delivered orders.
- Average Orders per Customer.
- Purchase Value of one-time and repeat customers.
- Customers by State.

### 3.4. Data Sources & Grain

- Source: gold.report_customers (built from gold.fact_orders, gold.dim_customers).
- Analysis includes delivered orders only, 2016-09 to 2018-08.
- Reporting grain: one row per analysis_type and segment (customer type or customer state).
- Customer = customer_unique_id. Definitions: `docs/metric_definitions.md`.

### 3.5. SQL Analysis

SQL queries: [`customers_performance.sql`](customers_performance.sql).

### 3.6. Findings

93,358 unique customers have at least one delivered order, out of 96,096 unique customers in total (2,738 have no delivered order).

90,557 customers (97.00%) made one purchase and 2,801 (3.00%) are repeat customers. Repeat customers placed 2.11 orders on average (5,921 orders, 6.14% of delivered orders).

One-time customers account for 12,493,089.36 (94.49%) of Product Sales Value and repeat customers for 728,408.75 (5.51%). Average Product Sales Value per customer is 137.96 for one-time and 260.05 for repeat customers (1.89 times higher).

Sao Paulo has 39,156 customers (41.92%), 40,501 orders and 5,067,633.16 in Product Sales Value (38.33%), followed by Rio de Janeiro (12.76%) and Minas Gerais (11.78%). These three states account for 63.38% of Product Sales Value. The smallest customer bases are Roraima (40), Amapa (66) and Acre (76).

Freight is 16.6% of Product Sales Value overall: 13.9% in Sao Paulo and 24.5%-28.1% in Amazonas, Rondonia, Maranhao and Roraima.

Note: state shares use the sum of state-level customers (93,396); 38 customers appear in more than one state.

### 3.7. Interpretation

The 2,738 customers without a delivered order are excluded by the delivered-only filter; this is consistent with the 2,963 orders that were not delivered.

Almost all customers buy once (97%), so sales depend mainly on attracting new customers. Repeat customers are a small but valuable group: they spend about 1.9 times more per customer. Part of the low repeat rate may be due to the short observation period (about two years); the reasons why customers return cannot be determined from this data.

Sales are concentrated in the south-east: the top three states hold about 66% of customers and 63% of sales. In remote states the customer base is small and freight takes a larger share of the purchase value (up to 28.1% versus 13.9% in Sao Paulo), which may reduce demand (hypothesis; the share also depends on product mix).

### 3.8. Recommendations

Focus on converting first-time customers into repeat customers: test post-purchase measures (follow-up offers, loyalty incentives) and track the repeat rate as a KPI.

Review freight conditions for remote states (Roraima, Maranhao, Rondonia, Amazonas), where freight is 24%-28% of the purchase value.

Additional data needed: acquisition channel and order dates to build cohorts and measure time between orders; order reviews (available in Silver) to compare satisfaction of one-time and repeat customers; a longer observation period.
