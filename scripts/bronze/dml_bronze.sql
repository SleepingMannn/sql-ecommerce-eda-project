/*
===============================================================================
DML Script: Load Bronze Layer (Source → Bronze)
===============================================================================
Purpose:
    Loads the 9 Olist CSV files into the Bronze tables with BULK INSERT.
    Method: full load (TRUNCATE, then BULK INSERT). No transformations.

Before you run:
    1. Download the dataset (see datasets/README.md) and save the CSV files
       in one folder.
    2. Replace the folder path 'C:\sql\Brazilian-E-Commerce\' in every
       BULK INSERT below with your folder.
    3. The SQL Server service account must have read access to that folder,
       otherwise BULK INSERT fails with an access error.

WARNING:
    TRUNCATE removes all rows from the Bronze tables before loading.

BULK INSERT options used:
    FORMAT = 'CSV'          Reads the file as CSV (quoted values, commas and
                            line breaks inside quotes).
    FIRSTROW = 2            The first row of each file is the header.
    ROWTERMINATOR = '0x0a'  End of a row = LF only (Linux/Mac style). Eight files
                            use LF. The reviews file uses CR + LF, so it has no
                            ROWTERMINATOR (SQL Server default).
    CODEPAGE = '65001'      UTF-8, so Portuguese letters load correctly.
    TABLOCK                 Table lock during loading, faster load.
===============================================================================
*/

USE olist_ecommerce;   -- change to the actual database name
GO

-- #1 olist_customers_dataset
TRUNCATE TABLE bronze.olist_customers;

BULK INSERT bronze.olist_customers
FROM 'C:\sql\Brazilian-E-Commerce\olist_customers_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a', 
    CODEPAGE = '65001',
    TABLOCK
);

-- #2 olist_geolocation_dataset
TRUNCATE TABLE bronze.olist_geolocation;

BULK INSERT bronze.olist_geolocation
FROM 'C:\sql\Brazilian-E-Commerce\olist_geolocation_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);

-- #3 olist_order_items_dataset
TRUNCATE TABLE bronze.olist_order_items;

BULK INSERT bronze.olist_order_items
FROM 'C:\sql\Brazilian-E-Commerce\olist_order_items_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);

-- #4 olist_order_payments_dataset
TRUNCATE TABLE bronze.olist_order_payments;

BULK INSERT bronze.olist_order_payments
FROM 'C:\sql\Brazilian-E-Commerce\olist_order_payments_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);

-- #5 olist_order_reviews_dataset
TRUNCATE TABLE bronze.olist_order_reviews;

BULK INSERT bronze.olist_order_reviews
FROM 'C:\sql\Brazilian-E-Commerce\olist_order_reviews_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    TABLOCK
);

-- #6 olist_orders_dataset
TRUNCATE TABLE bronze.olist_orders;

BULK INSERT bronze.olist_orders
FROM 'C:\sql\Brazilian-E-Commerce\olist_orders_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);

-- #7 olist_products_dataset
TRUNCATE TABLE bronze.olist_products;

BULK INSERT bronze.olist_products
FROM 'C:\sql\Brazilian-E-Commerce\olist_products_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);

-- #8 olist_sellers_dataset
TRUNCATE TABLE bronze.olist_sellers;

BULK INSERT bronze.olist_sellers
FROM 'C:\sql\Brazilian-E-Commerce\olist_sellers_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);

-- #9 product_category_name_translation
TRUNCATE TABLE bronze.product_category_name_translation;

BULK INSERT bronze.product_category_name_translation
FROM 'C:\sql\Brazilian-E-Commerce\product_category_name_translation.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
