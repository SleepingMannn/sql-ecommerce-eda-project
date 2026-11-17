-- ============================================================
-- Create Database and Schemas
-- ============================================================
/*
Script Purpose:
    This script creates a new database named 'olist_ecommerce' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
    within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'olist_ecommerce' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and rebuild the 'olist_ecommerce' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'olist_ecommerce')
BEGIN
    ALTER DATABASE olist_ecommerce SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE olist_ecommerce;
END;
GO

-- Create the 'olist_ecommerce' database
CREATE DATABASE olist_ecommerce;
GO

USE olist_ecommerce;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
