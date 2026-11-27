# Olist E-Commerce Data Analysis

## Overview

Exploratory data analysis of the Brazilian E-Commerce Public Dataset by Olist using SQL Server 2022.

The project follows a Bronze → Silver → Gold architecture and focuses on data preparation, validation and business analysis.

## Tech Stack

- SQL Server 2022
- SQL Server Management Studio (SSMS)
- Git / GitHub
- Figma (diagrams)

## Repository Structure

```
sql-ecommerce-eda-project/
├── analysis/              # EDA of the project
├── datasets/              # dataset download instructions
├── docs/                  # architecture, data catalog and documentation
├── scripts/               # database creation and ETL scripts          
├── tests/                 # data quality validation
├── LICENSE
└── README.md
```

## How to Run

1. Install SQL Server (2022 or newer) and SSMS.
2. Download the data from the official link in the datasets/ on your computer and update the nine file paths in scripts/bronze/dml_bronze.sql.
3. Run scripts/init_database.sql (warning: it drops and recreates the DataWarehouse database).
4. Run scripts/bronze/ddl_bronze.sql and scripts/bronze/dml_bronze.sql;
5. Run scripts/silver/ddl_silver.sql and scripts/silver/dml_silver.sql;
6. Run scripts/gold/ddl_gold.sql.
7. Run the checks from the tests/ folder.
8. Run scripts/gold/ddl_gold_reports.sql
9. Run the scripts from analysis/<block> for EDA

## What I Learned

This was my first solo project with data preparation on data analysis, where i practised:
- Data architecture: designing a Medallion warehouse (Bronze, Silver, Gold) and documenting the data flow
- ETL steps in data preparation phase: loading CSV files, validating and standardizing data, extract ready data for analysis in views.
- Data modeling: creating complex data model - fact constellation schema with 3 fact tables
- Exploratory Data Analysis: I have formed business-questions for the project and answer them with a small scope of areas.
- Working with Git: organizing a repository, documenting code and committing step by step

## Next Steps

Next: BI tools for creating dashboards.

## License

This project is licensed under the [MIT License](https://github.com/SleepingMannn/sql-ecommerce-eda-project/blob/main/LICENSE).
The original [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) with license: [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)
