## 1. Customers Performance Analysis

### 1.1. Business Question

How do customers use the platform, and how often do they make repeat purchases?

### 1.2. Business Context

Understand customer purchasing behavior, the contribution of repeat customers to Product Sales Value, and the geographic distribution of buyers.

### 1.3. Required Metrics

- Unique Customers — number of distinct customers with at least one delivered order.
- Repeat Customer Share — percentage of customers with more than one delivered order.
- Average Orders per Customer — average number of delivered orders per customer segment.
- Product Sales Value by Customer Segment — value of products purchased by one-time and repeat customers.
- Customer Geographic Distribution — number of customers and Product Sales Value by customer state.

### 1.4. Data Sources & Grain

- Source: gold.report_customers (built from gold.fact_orders, gold.dim_customers).
- Analysis includes delivered orders only, 2016-09 to 2018-08.
- Reporting grain:
-   Customer Behavior — one row per customer segment.
-   Customer Geography — one row per customer state.
- Definitions: `docs/metric_definitions.md`

### 1.5. SQL Analysis

SQL queries: [`customers_performance.sql`](customers_performance.sql).

### 1.6. Findings

A total of 93,358 unique customers placed at least one delivered order during the analysis period.

One-time Customers accounted for 97.00% (90,557 customers), while Repeat Customers represented 3.00% (2,801 customers).

One-time Customers placed an average of 1.00 delivered order, compared with 2.11 orders per Repeat Customer.

One-time Customers generated 94.49% of Product Sales Value (12,493,089.36), while Repeat Customers generated 5.51% (728,408.75).

Customer activity was concentrated in three states: São Paulo had 39,156 customers (41.92%), followed by Rio de Janeiro with 11,917 (12.76%) and Minas Gerais with 11,001 (11.78%).

São Paulo also recorded the highest Product Sales Value, totaling 5,067,633.16.

### 1.7. Interpretation

Most customers placed only one delivered order during the observed period. Repeat Customers represented a relatively small share of the customer base and Product Sales Value.

Repeat Customers placed more orders per customer on average, but the available results do not explain why they returned or whether their purchasing behavior is likely to continue.

Customer activity was concentrated in São Paulo, Rio de Janeiro, and Minas Gerais. These results describe the distribution of customers in the dataset but do not explain the reasons behind regional differences.

The 2,738 difference between the total number of unique customers (96,096) and customers with at least one delivered order (93,358) represents customers without a delivered order in the analyzed dataset. This difference should not automatically be interpreted as a data-quality issue.

### 1.8. Recommendations

Investigate repeat purchasing behavior through customer groups, first-purchase dates, and time between orders to better understand customer retention.

Examine customer reviews and ratings to identify potential differences in customer experience between one-time and repeat buyers.

Analyze the leading customer states in more detail, considering order volume, Product Sales Value, and delivery performance.
