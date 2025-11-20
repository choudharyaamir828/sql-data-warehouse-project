

/*
===================================================================
		Store procedure : Load silver layer (Bronze -> silver)
==================================================================

Scripts Purpose:
this stored procedure load data into the 'silver schema from the bronze layer
if performs the following  actions:
	-truncates the silver tables loading data.



	parameters:
	None.
	this stored procedure does accept any parameters or return any values.

	usage Example : 
		EXEC bronxe.load_bronze;
		========================================================================
	*/




create or alter procedure silver.load_silver as
BEGIN
	declare @start_time datetime, @end_time datetime,@batch_start_time datetime,@batch_end_time datetime
	begin try 
		print('======================================================');
		print('loading silver layer');
		print('======================================================');

		print('--------------------------------------------------------');
		print('loading CRM Tables');
		print('--------------------------------------------------------');

		print('>>> truncating table :  bronze.crm_cust_info')

		truncate table silver.crm_cust_info

		set @batch_start_time = GETDATE()

		set @start_time = GETDATE();
		print('------> Inserting data into: silver.crm_cust_info')

		insert into silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_material_status,
		cst_gndr,
		cst_create_date)

		select 
		cst_id,
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_Lastname) as cst_lastname,
		case when upper(trim(cst_material_status)) = 'S' then 'Single'
			when upper(trim(cst_material_status)) = 'M' then 'Married'
				  else 'n/a'
			end cst_material_status,
		case when upper(trim(cst_gndr)) = 'F' then 'Female'
			when upper(trim(cst_gndr)) = 'M' then 'Male'
				  else 'n/a'
			end cst_gndr,

		cst_create_date
		from (
		select
		*,
		row_number() over(partition by cst_id order by cst_create_date desc) as flat_last

		from bronze.crm_cust_info
		where cst_id is not null
		)t where flat_last = 1
		set @end_time = GETDATE()
		print('Time to load  : silver.crm_cust_info '+ cast ( datediff(second,@start_time,@end_time) as nvarchar) + ' second')

		print('>>> truncating table : silver.crm_prd_info')
		truncate table silver.crm_prd_info

		set @start_time = GETDATE();
		print('-----> Inserting data into : silver.crm_prd_info')

		insert into silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
		)
		select
		prd_id,
		upper(replace(substring(prd_key,1,5),'-','_')) as cat_id,
		substring(prd_key,7,len(prd_key)) as prd_key,
		prd_nm,
		isnull(prd_cost,0) as prd_cost,
		case  upper(trim(prd_line))
			when 'M' then  'Mountain'
			 when  'R' then  'Road'
			 when  'S' then  'Other Sales'
			 when	'T' then  'Touring'
			 ELSE 'n/a'
		end as prd_line,
		cast(prd_start_dt as Date) as prd_start_dt,
		cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt
		from bronze.crm_prd_info;

		set @end_time = GETDATE()
		print('Time to load  : silver.crm_prd_info '+ cast ( datediff(second,@start_time,@end_time) as nvarchar) + ' second')

		print('>>> truncating table : silver.crm_sales_details')
		truncate table silver.crm_sales_details

		set @start_time = GETDATE();
		print('-----> Inserting data into : silver.crm_sales_details')
		insert into silver.crm_sales_details(
			sls_ord_num ,
			sls_prd_key,
			sls_cust_id ,
			sls_order_dt ,
			sls_ship_dt ,
			sls_due_dt,
			sls_sales ,
			sls_quanity ,
			sls_price
		) 
		select 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		case when sls_order_dt = 0 or len(sls_order_dt) != 8 then NULL
			else cast(cast( sls_order_dt as varchar) as Date)
		end as sls_order_dt,
		case when sls_ship_dt = 0 or len(sls_ship_dt) != 8 then NULL
			else cast(cast( sls_ship_dt as varchar) as Date)
		end as sls_ship_dt,
		case when sls_due_dt = 0 or len(sls_due_dt) != 8 then NULL
			else cast(cast( sls_due_dt as varchar) as Date)
		end as sls_due_dt,
		case when  sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity* abs(sls_price)
			then sls_quantity * abs(sls_price) 
			else sls_sales
		end as sls_sales,
		sls_quantity,
		case when sls_price is null or sls_price <=0 
			then sls_sales / nullif(sls_quantity,0)
			else sls_price
		end as sls_price
		from bronze.crm_sales_details

		set @end_time = GETDATE()
		print('Time to load  : silver.crm_sales_details '+ cast ( datediff(second,@start_time,@end_time) as nvarchar) + ' second')

		print('>>> truncating table : silver.erp_cust_az12')
		truncate table silver.erp_cust_az12

		set @start_time = GETDATE();
		print('-----> Inserting data into : silver.erp_cust_az12')

		insert into silver.erp_cust_az12(cid,bdate,gen)

		select
		case when cid like 'NAS%' then substring(cid,4,len(cid))
			else cid 
		end as cid ,
		case when bdate > getdate() then null
			else bdate
		end as bdate,
		case when upper(trim(gen)) in ('F','FEMALE') then 'Female'
			when upper(trim(gen)) in ('M','MALE') then 'Male'
			else 'n/a'
		end as gen 
		from bronze.erp_cust_az12

		set @end_time = GETDATE()
		print('time to load: silver.erp_cust_az12' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'second')

		print('>>> truncating table : silver.erp_loc_a101')
		truncate table silver.erp_loc_a101

		set @start_time = GETDATE();
		print('-----> Inserting data into : silver.erp_loc_a101')

		insert into silver.erp_loc_a101(cid,cntry) 

		select replace(cid,'-','') cid,
		case when lower(trim(cntry)) in ('usa','us') then 'United States'
			when trim(cntry) = 'DE' then 'Germany'
			when trim(cntry) = '' or cntry is null then 'n/a'
			else trim(cntry)
		end as cntry

		from bronze.erp_loc_a101

		set @end_time = GETDATE()
		print('time to load: silver.erp_loc_a101' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'second')

		print('>>>> truncating table : silver.erp_px_cat_g1v2')
		truncate table silver.erp_px_cat_g1v2

		set @start_time = GETDATE()

		print('----> Inserting data into : silver.erp_px_cat_g1v2')
		insert into silver.erp_px_cat_g1v2(id,cat,subcat,maintenance)
		select 
		id,
		cat,
		subcat,
		maintenance
		from bronze.erp_px_cat_g1v2


		set @end_time = GETDATE()
		print('time to load : silver.erp_px_cat_g1v2' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'second')

		set @batch_end_time = GETDATE()
		print('========================================================');
		print('silver layer loading completed')
		print('loading time of silver layer:'+ cast(datediff(second,@batch_start_time,@batch_end_time)  as nvarchar) + 'second')
		print('==========================================================');
	END TRY
	begin catch
		print('======================================================');
		print('ERROR OCCURED DURING LOADING silver LAYER');
		print('Error Message' + ERROR_MESSAGE());
		PRINT('ERROR MESSAGE'+ ERROR_NUMBER());
		PRINT('ERROR MESSAGE'+ CAST(ERROR_STATE() AS NVARCHAR))
	end catch

end

		



exec bronze.load_bronze;

/*
if you want to drop the procedure :

  drop procedure  bronze.load_bronze

*/

