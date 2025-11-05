/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
create or alter procedure bronze.load_bronze as 
Begin
	Declare @starttime datetime, @endtime datetime
		Begin try

			print '=============================================================';
			print 'Load the Data into Bronze Layer'
			print '=============================================================';
			Print '-------------------------------------------------------------';
			print ' Truncating the table bronze.crm_cust_info';
			Print '-------------------------------------------------------------';
			truncate table bronze.crm_cust_info;
			print 'load the data into bronze.crm_cust_info';
			set @starttime = getdate();
			bulk insert bronze.crm_cust_info
			from 'C:\Users\Aquib\Documents\SQL\Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			with (
				firstrow=2,
				fieldterminator =',',
				Tablock
				);
				set @endtime = getdate();
				print'loading duration = ' + cast(datediff(second,@starttime,@endtime) as nvarchar) + 'second';
			Print '-------------------------------------------------------------';
			print ' Truncating the table bronze.crm_prd_info';
			Print '-------------------------------------------------------------';
			truncate table bronze.crm_prd_info;
			set @starttime =getdate();
			bulk insert bronze.crm_prd_info
			from 'C:\Users\Aquib\Documents\SQL\Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			with (
					firstrow=2,
					fieldterminator=',',
					Tablock
					);
			set @endtime = getdate();
			print'loading time ='+ CAST(datediff(second,@starttime,@endtime) as nvarchar) + 'seconds'
			
			Print '-------------------------------------------------------------';
			print ' Truncating the table bronze.crm_sales_details';
			Print '-------------------------------------------------------------';
			Truncate table bronze.crm_sales_details;
			set @starttime =getdate();
			bulk insert bronze.crm_sales_details
			from 'C:\Users\Aquib\Documents\SQL\Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			with (
					firstrow=2,
					fieldterminator=',',
					Tablock
					);
			set @endtime=getdate();
			print'loading time='+ cast(datediff(second,@starttime,@endtime)as nvarchar) +'seconds'
			truncate table bronze.erp_cust_az12;
			bulk insert bronze.erp_cust_az12
			from 'C:\Users\Aquib\Documents\SQL\Project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
			with (
					firstrow=2,
					fieldterminator=',',
					Tablock
					);


			truncate table bronze.erp_loc_a101;
			bulk insert bronze.erp_loc_a101
			from 'C:\Users\Aquib\Documents\SQL\Project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
			with (
					firstrow=2,
					fieldterminator=',', 
					Tablock
					);

			truncate table bronze.erp_px_cat_g1v2;
			bulk insert bronze.erp_px_cat_g1v2
			from 'C:\Users\Aquib\Documents\SQL\Project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
			with (
					firstrow=2,
					fieldterminator=',', 
					Tablock
					);
		END try
		begin catch
			print '=============================================================';
			print ' Error Occur in bronze layer '+ error_message();
			print 'error message'+ cast (error_number() as nvarchar);
			print 'error message'+ cast (error_state() as nvarchar);
			print '=============================================================';
		end catch
END
