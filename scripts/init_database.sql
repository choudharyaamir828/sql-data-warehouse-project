/*
--------------------------------------------------------------------------------
CREATE Database and Schema 
-------------------------------------------------------------------------------
Scripts Purpose :
	this scripts create a new database named 'datawarehouse' after checking if it already exists.
	if the database exists, it is droped and recreated. Additionally, the scripts set up three schemas
	within the database : 'bronze','silver','gold'.


WARNING:
	Running this scripts will drop the entire database 'DataWarehouse' database if it exists.
	all data in the database will be permanently deleted. proceed with caution
	and ensure you have proper backups before running this scripts.

*/





use master;
GO

-- Drop and recreate the 'DataWarehouse' database
if exists (select 1 from sys.databases where name = 'DataWarehouse')
Begin
	alter DATABASE DataWarehouse set SINGLE_USER with rollback IMMEDIATE;
	DROP Database DataWarehouse;
END;
Go

--create the 'DataWarehouse' database
CREATE database  DataWarehouse;
GO
use DataWarehouse;

GO

-- Drop and recreate BRONZE schema
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    DROP SCHEMA bronze;
END
GO
CREATE SCHEMA bronze;
GO

-- Drop and recreate SILVER schema
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
    DROP SCHEMA silver;
END
GO
CREATE SCHEMA silver;
GO

-- Drop and recreate GOLD schema
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    DROP SCHEMA gold;
END
GO
CREATE SCHEMA gold;
GO
