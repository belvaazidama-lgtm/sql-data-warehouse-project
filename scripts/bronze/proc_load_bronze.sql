/* Procédure stockée : Charger la couche Bronze (Source -> Bronze) 
==================================================================================
Objectif du script : Cette procédure stockée charge les données 
dans le schéma ‘bronze’ à partir de fichiers CSV externes. 
Elle effectue les actions suivantes : 
- Tronque (vide) les tables bronze avant de charger les données. 
- Utilise la commande BULK INSERT pour charger les données des fichiers CSV vers les tables bronze. 

Paramètres : 
Aucun. 
Cette procédure stockée n’accepte aucun paramètre et ne retourne aucune valeur. 
Exemple d’utilisation : EXEC bronze.load_bronze; 
==================================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;   --connaitre l'heure exacte du début et de fin
    BEGIN try
        SET @batch_start_time = GETDATE(); 
        print'==========================================================='
        print'chargement de la couche bronze'
        print'==========================================================='

        print'-----------------------------------------------------------'
        print'chargement de tables crm'
        print'-----------------------------------------------------------'
        
        SET @start_time = GETDATE();   --reccupéré l'heure et la date actuelle du dédut lors de chargement de la table
        print'>> Vidage de la table: bronze.crm_cust_info'
        truncate table bronze.crm_cust_info 

        print'>> Insertion des données dans: bronze.crm_cust_info'
        -- BULK INSERT permet de charger une grande masse de données à partir d'un fichier
        BULK INSERT bronze.crm_cust_info 
        FROM '/tmp/cust_info.csv'   --On charge le fichier depuis un conteneur docker 
        WITH (
            firstrow = 2,           -- On insère les données à partir de la 2e ligne du fichier
            fieldterminator = ',',  -- On indique à SQL que la virgule est le délimiteur
            tablock                 -- Verrouille la table entière pendant son chargement
        );
        SET @end_time = GETDATE();  --reccupéré l'heure et la date actuelle de fin lors de chargement de la table
        print'>> Durée de chargement: ' + CAST(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';  --calcul de l'intervalle entre deux date
        print'>> ---------------------';

        SET @start_time = GETDATE(); 
        print'>> Vidage de la table: bronze.crm_prd_info'
        truncate table bronze.crm_prd_info 

        print'>> Insertion des données dans: bronze.crm_prd_info'
        BULK INSERT bronze.crm_prd_info 
        FROM '/tmp/prd_info.csv'   --On charge le fichier depuis un conteneur docker 
        WITH (
            firstrow = 2,           -- On insère les données à partir de la 2e ligne du fichier
            fieldterminator = ',',  -- On indique à SQL que la virgule est le délimiteur
            tablock                 -- Verrouille la table entière pendant son chargement
        );

        SET @end_time = GETDATE();
        print'>> Durée de chargement: ' + CAST(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
        print'>> ---------------------';

        SET @start_time = GETDATE(); 
        print'>> Vidage de la table: bronze.crm_sales_details'
        truncate table bronze.crm_sales_details

        print'>> Insertion des données dans: bronze.crm_sales_details'
        BULK INSERT bronze.crm_sales_details
        FROM '/tmp/sales_details.csv'   --On charge le fichier depuis un conteneur docker 
        WITH (
            firstrow = 2,           -- On insère les données à partir de la 2e ligne du fichier
            fieldterminator = ',',  -- On indique à SQL que la virgule est le délimiteur
            tablock                 -- Verrouille la table entière pendant son chargement
        );

        SET @end_time = GETDATE();
        print'>> Durée de chargement: ' + CAST(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
        print'>> ---------------------';

        print'-----------------------------------------------------------'
        print'chargement de tables erp'
        print'-----------------------------------------------------------'

        SET @start_time = GETDATE(); 
        print'>> Vidage de la table: bronze.erp_cust_az12'
        truncate table bronze.erp_cust_az12

        print'>> Insertion des données dans: bronze.erp_cust_az12'
        BULK INSERT bronze.erp_cust_az12
        FROM '/tmp/cust_az12.csv'   --On charge le fichier depuis un conteneur docker 
        WITH (
            firstrow = 2,           -- On insère les données à partir de la 2e ligne du fichier
            fieldterminator = ',',  -- On indique à SQL que la virgule est le délimiteur
            tablock                 -- Verrouille la table entière pendant son chargement
        );

        SET @end_time = GETDATE();
        print'>> Durée de chargement: ' + CAST(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
        print'>> ---------------------';

        SET @start_time = GETDATE(); 
        print'>> Vidage de la table: bronze.erp_loc_a101'
        truncate table bronze.erp_loc_a101

        print'>> Insertion des données dans: bronze.erp_loc_a101'
        BULK INSERT bronze.erp_loc_a101
        FROM '/tmp/loc_a101.csv'   --On charge le fichier depuis un conteneur docker 
        WITH (
            firstrow = 2,           -- On insère les données à partir de la 2e ligne du fichier
            fieldterminator = ',',  -- On indique à SQL que la virgule est le délimiteur
            tablock                 -- Verrouille la table entière pendant son chargement
        );

        SET @end_time = GETDATE();
        print'>> Durée de chargement: ' + CAST(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
        print'>> ---------------------';

        SET @start_time = GETDATE(); 
        print'>> Vidage de la table: bronze.erp_px_cat_g1v2'
        truncate table bronze.erp_px_cat_g1v2

        print'>> Insertion des données dans: bronze.erp_px_cat_g1v2'
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/tmp/px_cat_g1v2.csv'   --On charge le fichier depuis un conteneur docker 
        WITH (
            firstrow = 2,           -- On insère les données à partir de la 2e ligne du fichier
            fieldterminator = ',',  -- On indique à SQL que la virgule est le délimiteur
            tablock                 -- Verrouille la table entière pendant son chargement
        );

        SET @end_time = GETDATE();
        print'>> Durée de chargement: ' + CAST(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
        print'>> ---------------------';

        SET @batch_end_time = GETDATE();
        print'==================================================='
        print'le chargement de la couche bronze est completé'
        print'  - Durée total de chargement : ' + CAST(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + 'seconds';
        print'==================================================='

    END TRY

    BEGIN CATCH
        print'==================================================='
        print'ERROR Message'+ ERROR_MESSAGE();
        print'ERROR Message'+ CAST (ERROR_NUMBER() as nvarchar);
        print'ERROR Message'+ CAST (ERROR_STATE() as nvarchar);
        print'==================================================='
    END CATCH
END
