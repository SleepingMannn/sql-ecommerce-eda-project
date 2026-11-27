-- #1 Number of orders by status
SELECT
	order_status,
	COUNT(order_id) AS total_orders
FROM gold.report_orders_delivery
GROUP BY order_status
ORDER BY total_orders DESC;

-- #2 Share of all order status
SELECT
	order_status,
	COUNT(order_id) AS total_orders,
	SUM(COUNT(order_id)) OVER () AS overall_orders,
	ROUND((100.0 * COUNT(order_id)) / SUM(COUNT(order_id)) OVER (), 2) AS orders_share
FROM gold.report_orders_delivery
GROUP BY order_status
ORDER BY total_orders DESC;

-- #3 Average delivery time
SELECT
	COUNT(order_id) AS total_orders,
	AVG(CAST(delivery_days AS DECIMAL(10,2))) AS avg_delivery_time
FROM gold.report_orders_delivery
WHERE order_status = 'delivered' AND delivery_days IS NOT NULL;

-- #4 Percentage of late orders & On-time Delivery Rate
SELECT
	delivery_status,
	COUNT(order_id) AS total_orders,
	SUM(COUNT(order_id)) OVER () AS overall_orders,
	ROUND((100.0 * COUNT(order_id)) / SUM(COUNT(order_id)) OVER (), 2) AS orders_share
FROM gold.report_orders_delivery
WHERE order_status = 'delivered' AND delivery_delay_days IS NOT NULL
GROUP BY delivery_status
ORDER BY total_orders DESC;

-- #5 Average number of days late
SELECT
	COUNT(order_id) AS total_orders,
	AVG(CAST(delivery_delay_days AS DECIMAL(10,2))) AS avg_delay_days
FROM gold.report_orders_delivery
WHERE delivery_status = 'late' AND order_status = 'delivered';

-- #6 Trends in delays by month and state
SELECT 
	purchase_year,
	purchase_month,
	customer_state,
	total_delivered_orders,
	total_late_orders,
	ROUND((100.0 * total_late_orders) / total_delivered_orders, 2) AS late_delivery_rate
FROM (
	SELECT
		YEAR(order_purchase_timestamp) AS purchase_year,
		MONTH(order_purchase_timestamp) AS purchase_month,
		customer_state,
		COUNT(order_id) AS total_delivered_orders,
		SUM(CASE 
				WHEN delivery_delay_days > 0 THEN 1 
				ELSE 0 
			END) AS total_late_orders
	FROM gold.report_orders_delivery
	WHERE order_status = 'delivered'
	GROUP BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp), customer_state
)t
WHERE total_delivered_orders >= 30
ORDER BY 
	purchase_year,
	purchase_month,
	customer_state;

-- #7 Orders excluded from delivery metrics
-- Orders excluded from Average Delivery Time
SELECT
	COUNT(order_id) AS total_delivered_orders,
	SUM(CASE
			WHEN delivery_days IS NOT NULL THEN 1
			ELSE 0
		END) AS included_orders,
	SUM(CASE
			WHEN delivery_days IS NULL THEN 1
			ELSE 0
		END) AS excluded_orders
FROM gold.report_orders_delivery
WHERE order_status = 'delivered';
-- Orders excluded from Late / On-time Delivery Rate
SELECT
	COUNT(order_id) AS total_delivered_orders,
	SUM(CASE
			WHEN delivery_delay_days IS NOT NULL THEN 1
			ELSE 0
		END) AS included_orders,
	SUM(CASE
			WHEN delivery_delay_days IS NULL THEN 1
			ELSE 0
		END) AS excluded_orders
FROM gold.report_orders_delivery
WHERE order_status = 'delivered';
