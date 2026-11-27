-- Number of unique customers
SELECT
	SUM(total_customers) AS total_customers
FROM gold.report_customers
WHERE analysis_type = 'Customer Behavior';

-- Percentage of customers who place repeat orders
SELECT
	segment,
	total_customers,
	SUM(total_customers) OVER () AS overall_customers,
	ROUND((100.0 * total_customers) / SUM(total_customers) OVER (), 2) AS customers_share
FROM gold.report_customers
WHERE analysis_type = 'Customer Behavior';

-- Average number of orders per customer
SELECT
	segment,
	ROUND(CAST(total_orders AS FLOAT)/ total_customers, 2) AS avg_order
FROM gold.report_customers
WHERE analysis_type = 'Customer Behavior';

-- Purchase value of one-time and repeat customers
SELECT
	segment,
	product_sales_value,
	ROUND((100.0 * product_sales_value) / SUM(product_sales_value) OVER (), 2) AS product_sales_value_share
FROM gold.report_customers
WHERE analysis_type = 'Customer Behavior';

-- Geographic distribution of buyers
SELECT
	segment,
	total_customers,
	ROUND((100.0 * total_customers) / SUM(total_customers) OVER (), 2) AS customers_share,
	total_orders,
	total_items,
	product_sales_value,
	total_freight,
	sales_value_with_freight
FROM gold.report_customers
WHERE analysis_type = 'Customer Geography'
ORDER BY total_customers DESC;
