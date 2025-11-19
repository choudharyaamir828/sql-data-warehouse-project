/*

print '==============================================================';
print 'DDL Scripts: Create Silver Tables';
print '==============================================================';

Scripts Purpose: 
	this scripts creates tables in the 'Silver' schema , dropping existing tables
	if they already exists.
	run this scrips to re-define the DDL structure of 'bronze' Tables

	print '==================================================================';
	*/

if object_id('silver.crm_prd_info','U') is NOT NULL
	drop table silver.crm_prd_info;
create table silver.crm_prd_info(
prd_id INT,
cat_id nvarchar(50),
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt Date,
prd_end_dt date,
dwh_create_date Datetime2 default Getdate()
);

go

 -- insert into silver layer --
 if object_id('silver.crm_sales_details','U') is not null
	drop table silver.crm_sales_details;
create table silver.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quanity int,
	sls_price int,
	dwh_create_date datetime2 default getdate()
);


go



