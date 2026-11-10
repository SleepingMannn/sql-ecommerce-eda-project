-- ============================================================
-- #1 Create Database & Schemas
-- ============================================================
USE master;
GO

-- Drop and rebuilt the 'OlistEcommerce' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'OlistEcommerce')
BEGIN
    ALTER DATABASE OlistEcommerce SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE OlistEcommerce;
END;
GO

-- Create the 'OlistEcommerce' database
CREATE DATABASE OlistEcommerce;
GO

USE OlistEcommerce;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
