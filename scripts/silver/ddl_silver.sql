/*
====================================================================
Script DDL: créer les tables silver
====================================================================
Objectif du script : 
Ce script crée des tables dans le schema 'silver', en supprimant 
les tables existantes si elles sont déjà présentes.
Executé ce script pour redéfinir la struture DDL des tables 'silver'
====================================================================
*/

create or alter procedure silver.load_silver as
begin
	DECLARE @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;   --connaitre l'heure exacte du début et de fin
    begin try
        set @batch_start_time = GETDATE(); 
        print'===========================================================';
        print'chargement de la couche silver';
        print'===========================================================';

        print'-----------------------------------------------------------';
        print'chargement de tables crm'
        print'-----------------------------------------------------------';
        
        set @start_time = GETDATE();
		print '>> Truncation table: silver.crm_cust_info';
		Truncate table silver.crm_cust_info;
		print '>> Insertion de données dans: silver.crm_cust_info';
		insert into silver.crm_cust_info ( 
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
		--suppression des espaces indesirable
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		--normalisation de données(gestion de données manquante)
		CASE when upper(trim(cst_material_status)) = 'C' then 'Celibataire'
			 when upper(trim(cst_material_status)) = 'M' then 'Marié'
			else 'n/a'
		--
		end cst_material_status,
		CASE when upper(trim(cst_gndr)) = 'F' then 'Feminin'
			 when upper(trim(cst_gndr)) = 'M' then 'Masculin'
			else 'n/a'
		end cst_gndr,
		cst_create_date
		--supression des doublons
		from(
			select *,
			row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
			from bronze.crm_cust_info 
			where cst_id is not null
		)t where flag_last = 1 
		set @end_time = GETDATE();
			print'>> Durée de chargement: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
			print'>> ---------------------';

		set @start_time = GETDATE();
		print '>> Truncation table: silver.crm_prd_info';
		Truncate table silver.crm_prd_info;
		print '>> Insertion de données dans: silver.crm_prd_info';
		insert into silver.crm_prd_info ( 
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)

		Select 
		prd_id,

		-- derivation de nouvelle colonne
		replace(SUBSTRING(prd_key, 1, 5),'-','_') as cat_id,     --on remplace le signe moins par l'underscore en fin de bien joindre le deux table
		substring(prd_key, 7, len(prd_key)) as prd_key,
		prd_nm,

		--gestion des valeurs manquante
		isnull(prd_cost, 0) as prd_cost,
		--normalisation des données et gestion de données manquante
		case upper(trim(prd_line))
			 when 'M' then 'Moutain'
			 when 'R' then 'Road'
			 when 'S' then 'Other sales'
			 when 'T' then 'Touring'
			 else 'n/a'
		end as prd_line,
		--transtypage de type de données(converson d'un type de données à un autre)
		cast (cst_start_dt as date) as prd_start_dt,
		cast(
			lead(cst_start_dt) over (partition by prd_key order by cst_start_dt) -1 
			as date
		) as prd_end_dt  --calcul de la date de fin comme un jour avant la date de fin
		from bronze.crm_prd_info
		set @end_time = GETDATE();
			print'>> Durée de chargement: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
			print'>> ---------------------';

		set @start_time = GETDATE();
		print '>> Truncation table: silver.crm_sales_details';
		Truncate table silver.crm_sales_details;
		print '>> Insertion de données dans: silver.crm_sales_details';
		insert into silver.crm_sales_details (
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				sls_order_dt,
				sls_ship_dt,
				sls_due_dt,
				sls_sales,
				sls_quantity,
				sls_price
		)
		select
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		--traitement des données invalide et modification de type de données
		case when sls_order_dt = 0 or len(sls_order_dt) != 8 then null
			 else cast(cast(sls_order_dt as varchar) as date)
		end as sls_order_dt,
		case when sls_ship_dt = 0 or len(sls_ship_dt) != 8 then null
			 else cast(cast(sls_ship_dt as varchar) as date)
		end as sls_ship_dt,
		case when sls_due_dt = 0 or len(sls_due_dt) != 8 then null
			 else cast(cast(sls_due_dt as varchar) as date)
		end as sls_due_dt,
		case when sls_sales is null or sls_sales <= 0  or sls_sales != sls_quantitY * abs(sls_price)
				then sls_quantitY * abs(sls_price)
			else sls_sales
		end as sls_sales,
		sls_quantity,
		--traitement des données manquante ainsi que les données non valide en dérivant
		--la colonne d'une colonne existante
		case when sls_price is null or sls_price <= 0 
				then sls_sales / nullif(sls_quantitY, 0)
			else sls_price
		end as sls_price
		from bronze.crm_sales_details
		set @end_time = GETDATE();
			print'>> Durée de chargement: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
			print'>> ---------------------';

		set @start_time = GETDATE();
		print '>> Truncation table: silver.erp_cust_az12';
		Truncate table silver.erp_cust_az12;
		print '>> Insertion de données dans: silver.erp_cust_az12';
		insert into silver.erp_cust_az12 (
			cid,
			bdate,
			gen
		)

		SELECT
		--gestion des valeurs non valide
		case when cid like 'NAS%' then substring (cid, 4, len(cid))
			 else cid
		end as cid,
		case when bdate > getdate() then null	
			 else bdate
		end as bdate,
		--normalisation de données en mappant le code à une valeur très conviviable 
		case when upper(trim(replace(gen, char(13),''))) in ('F', 'FEMALE') then 'Female'
			 when upper(trim(replace(gen, char(13),''))) in ('M', 'MALE') then 'Male'
			 else 'n/a'  --gestion des valeurs manquante
		end as gen
		from bronze.erp_cust_az12
		set @end_time = GETDATE();
			print'>> Durée de chargement: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
			print'>> ---------------------';

		set @start_time = GETDATE();
		print '>> Truncation table: silver.erp_loc_a101';
		Truncate table silver.erp_loc_a101;
		print '>> Insertion de données dans: silver.erp_loc_a101';
		insert into silver.erp_loc_a101 (
			cid,
			cntry
		)

		select
		replace(cid, '-', '') cid,
		CASE 
			WHEN cntry IS NULL 
			  OR LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), CHAR(160), ''))) = '' THEN 'n/a'
			WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), CHAR(160), '')) = 'DE' THEN 'Germany'
			WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), CHAR(160), '')) IN ('US', 'USA') THEN 'United States'
			ELSE LTRIM(RTRIM(cntry))
			END AS cntry
		from bronze.erp_loc_a101
		set @end_time = GETDATE();
			print'>> Durée de chargement: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
			print'>> ---------------------';

		set @start_time = GETDATE();
		print '>> Truncation table: silver.erp_px_cat_g1v2';
		Truncate table silver.erp_px_cat_g1v2;
		print '>> Insertion de données dans: silver.erp_px_cat_g1v2';
		insert into silver.erp_px_cat_g1v2 (
			id, 
			cat, 
			subcat, 
			maintenance
		)

		select
		id,
		cat,
		subcat,
		maintenance
		from bronze.erp_px_cat_g1v2
	    set @end_time = GETDATE();
        print'>> Durée de chargement: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
        print'>> ---------------------';

        set @batch_end_time = GETDATE();
        print'==================================================='
        print'le chargement de la couche silver est completé'
        print'  - Durée total de chargement : ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + 'seconds';
        print'==================================================='

    end try
    begin catch
        print'==================================================='
        print'ERROR Message'+ ERROR_MESSAGE();
        print'ERROR Message'+ CAST (ERROR_NUMBER() as nvarchar);
        print'ERROR Message'+ CAST (ERROR_STATE() as nvarchar);
        print'==================================================='
    end catch
end
