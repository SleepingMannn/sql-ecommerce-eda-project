# Dataset

The original CSV files are not included in this repository.

Download the **Brazilian E-Commerce Public Dataset by Olist** from Kaggle:

[Download the dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

After downloading, extract the CSV files into this directory.

You will find a list of 9 files, such as:
- olist_customers_dataset;
- olist_geolocation_dataset;
- olist_order_items_dataset;
- olist_order_payments_dataset;
- olist_order_reviews_dataset;
- olist_orders_dataset;
- olist_products_dataset;
- olist_sellers_dataset;
- product_category_name_translation.

Place the downloaded CSV files in this directory.

Before running the Bronze loading script, update the local file paths in: `scripts/bronze/dml_bronze.sql`

For dataset attribution and license information, see [`docs/dataset_sources.md`](../docs/dataset_sources.md).
