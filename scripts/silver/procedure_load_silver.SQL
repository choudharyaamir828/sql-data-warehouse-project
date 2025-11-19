

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

