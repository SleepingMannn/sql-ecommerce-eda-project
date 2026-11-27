-- #1 Product Sales Value by Month and Category
SELECT
    month_start,
    product_category,
    product_sales_value
FROM gold.report_sales
ORDER BY month_start, product_sales_value DESC;

-- #2 The Number of Items Sold
SELECT
    product_category,
    SUM(total_quantity) AS total_items_sold
FROM gold.report_sales
GROUP BY product_category
ORDER BY total_items_sold DESC;

-- #3 The Average Price per Item
SELECT
    product_category,
    ROUND(SUM(product_sales_value) / NULLIF(SUM(total_quantity), 0), 2) AS avg_price_per_item
FROM gold.report_sales
GROUP BY product_category
ORDER BY avg_price_per_item DESC;

-- #4 Each Category's Share of Total Sales
SELECT
    product_category,
    SUM(product_sales_value) AS product_sales_value,
    ROUND((100.0 * SUM(product_sales_value)) / NULLIF(SUM(SUM(product_sales_value)) OVER (), 0), 3) AS total_sales_share_percent
FROM gold.report_sales
GROUP BY product_category
ORDER BY product_sales_value DESC;

-- #5 Sales Trends by Period
WITH monthly_sales AS (
    SELECT
        month_start,
        SUM(product_sales_value) AS product_sales_value
    FROM gold.report_sales
    GROUP BY month_start
)
SELECT
    month_start,
    product_sales_value,
    -- Month-over-Month Analysis
    LAG(product_sales_value) OVER (ORDER BY month_start) AS previous_month_sales,
    product_sales_value - LAG(product_sales_value) OVER (ORDER BY month_start) AS sales_diff,
    CASE 
        WHEN LAG(product_sales_value) OVER (ORDER BY month_start) IS NULL THEN 'not_applicable'
        WHEN product_sales_value - LAG(product_sales_value) OVER (ORDER BY month_start) > 0 THEN 'increase'
        WHEN product_sales_value - LAG(product_sales_value) OVER (ORDER BY month_start) < 0 THEN 'decrease'
        ELSE 'No Change'
    END AS sales_change
FROM monthly_sales
ORDER BY month_start;
