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

if object_id ('silver.crm_cust_info', 'U') is not null
drop TABLE silver.crm_cust_info
CREATE TABLE silver.crm_cust_info (
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_material_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date,
dwh_create_date datetime2 default getdate()   --colonne de metadonnées (ajouter par les DE)
);

if object_id ('silver.cmd_prd_info', 'U') is not null
drop TABLE silver.cmd_prd_info
CREATE TABLE silver.crm_prd_info (
prd_id int,
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
cst_start_dt datetime,
cst_end_dt datetime,
dwh_create_date datetime2 default getdate()
);

if object_id ('silver.crm_sales_details', 'U') is not null
drop TABLE silver.crm_sales_details
CREATE TABLE silver.crm_sales_details (
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id int,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales int,
sls_quantity int,
sls_price int,
dwh_create_date datetime2 default getdate()
);

if object_id ('silver.erp_loc_a101', 'U') is not null
drop TABLE silver.erp_loc_a101
CREATE TABLE silver.erp_loc_a101 (
cid nvarchar(50),
cntry nvarchar(50),
dwh_create_date datetime2 default getdate()
);

if object_id ('silver.erp_cust_az12', 'U') is not null
drop TABLE silver.erp_cust_az12
CREATE TABLE silver.erp_cust_az12 (
cid nvarchar(50),
bdate date,
gen nvarchar(50),
dwh_create_date datetime2 default getdate()
);

if object_id ('silver.erp_px_cat_g1v2', 'U') is not null
drop TABLE silver.erp_px_cat_g1v2
CREATE TABLE silver.erp_px_cat_g1v2(
id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(50),
dwh_create_date datetime2 default getdate()
);
end
