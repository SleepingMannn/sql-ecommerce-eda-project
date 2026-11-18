/*
Purpose:
    Creates the olist_ecommerce database and bronze, silver, gold schemas.

Warning:
    Drops the existing database if it already exists.
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
