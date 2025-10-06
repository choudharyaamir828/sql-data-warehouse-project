
/*
===================================================================
		Store procedure : Load Bronze layer (source -> Bronze)
==================================================================

Scripts Purpose:
this stored procedure load data into the 'bronze schema from external csv file
if performs the following  actions:
	-truncates the bronze tables loading data.
	-uses the 'Bulk insert command to load data from csv files to bronze tables.


	parameters:
	None.
	this stored procedure does accept any parameters or return any values.

	usage Example : 
		EXEC bronxe.load_bronze;
		========================================================================
	*/


create or alter procedure bronze.load_bronze as 
BEGIN
	declare @start_time datetime, @end_time datetime,@batch_start_time datetime,@batch_end_time datetime
	BEGIN TRY
		print('======================================================');
		print('loading Bronze layer');
		print('======================================================');

		print('--------------------------------------------------------');
		print('loading CRM Tables');
		print('--------------------------------------------------------');

		print('>>> truncating table :  bronze.crm_cust_info')

		truncate table bronze.crm_cust_info

		set @batch_start_time = GETDATE()

		set @start_time = GETDATE();
		print('-----> Inserting data into : bronze.crm_cust_info')

		bulk insert bronze.crm_cust_info
		from 'C:\Users\AMIR\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with(
		firstrow = 2,
		fieldterminator = ',',
		tablock 

		);
		set @end_time = GETDATE()
		print('Time to load  : bronze.crm_cust_info '+ cast ( datediff(second,@start_time,@end_time) as nvarchar) + ' second')


		print('>>> truncating table : bronze.crm_prd_info')
		truncate table bronze.crm_prd_info

		set @start_time = GETDATE();
		print('-----> Inserting data into : bronze.crm_prd_info')
		bulk insert bronze.crm_prd_info
		from 'C:\Users\AMIR\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with(
		firstrow = 2,
		fieldterminator = ',',
		tablock 

		);
		set @end_time = GETDATE()
		print('Time to load  :  bronze.crm_prd_info '+ cast ( datediff(second,@start_time,@end_time) as nvarchar) + ' second')


		print('>>> truncating table: bronze.crm_sales_details')
		truncate table bronze.crm_sales_details

		set @start_time = GETDATE();
		print('-----> Inserting data into : bronze.crm_sales_details')
		bulk insert bronze.crm_sales_details
		from 'C:\Users\AMIR\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
		firstrow = 2,
		fieldterminator = ',',
		tablock 

		);
		 set @end_time = GETDATE()
		print('Time to load  :  bronze.crm_sales_details '+ cast ( datediff(second,@start_time,@end_time) as nvarchar) + ' second')


		-- erp data table load --
	
		print('--------------------------------------------------------');
		print('loading ERP Tables');
		print('--------------------------------------------------------');

		print('>>> truncating table: bronze.erp_cust_az12')

		truncate table bronze.erp_cust_az12

		set @start_time = GETDATE();
		print('-----> Inserting data into : bronze.erp_cust_az12')
		bulk insert bronze.erp_cust_az12
		from 'C:\Users\AMIR\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with(
		firstrow = 2,
		fieldterminator = ',',
		tablock 

		);
		set @end_time = GETDATE()
		print('Time to load  :  bronze.erp_cust_az12 '+ cast ( datediff(second,@start_time,@end_time) as nvarchar) + ' second')

		print('>>> truncating table: bronze.erp_loc_a101')
		truncate table bronze.erp_loc_a101

		set @start_time = GETDATE();
		print('-----> Inserting data into : bronze.erp_loc_a101')
		bulk insert bronze.erp_loc_a101
		from 'C:\Users\AMIR\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with(
		firstrow = 2,
		fieldterminator = ',',
		tablock 

		);
		set @end_time = GETDATE()
		print('Time to load  :  bronze.erp_loc_a101 '+ cast ( datediff(second,@start_time,@end_time) as nvarchar) + ' second')

		print('>>> truncating table: bronze.erp_px_cat_g1v2')
		truncate table bronze.erp_px_cat_g1v2

		set @start_time = GETDATE();
		print('-----> Inserting data into :bronze.erp_px_cat_g1v2')
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\AMIR\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with(
		firstrow = 2,
		fieldterminator = ',',
		tablock 

		);
		set @end_time = GETDATE()
		print('Time to load  :  bronze.erp_px_cat_g1v2 '+ cast ( datediff(second,@start_time,@end_time) as nvarchar) + ' second')

		set @batch_end_time = GETDATE()
		print('========================================================');
		print('Bronze layer loading completed')
		print('loading time of Bronze layer:'+ cast(datediff(second,@batch_start_time,@batch_end_time)  as nvarchar) + 'second')
		print('==========================================================');
	END TRY
	BEGIN CATCH
		print('======================================================');
		print('ERROR OCCURED DURING LOADING BRONZE LAYER');
		print('Error Message' + ERROR_MESSAGE());
		PRINT('ERROR MESSAGE'+ ERROR_NUMBER());
		PRINT('ERROR MESSAGE'+ CAST(ERROR_STATE() AS NVARCHAR))
		


	END CATCH

END



exec bronze.load_bronze;

/*
if you want to drop the procedure :

  drop procedure  bronze.load_bronze

*/








