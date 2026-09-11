/*
===========================================================
Créer la base de données et Schemas
===========================================================
Objectif du script:
Ce script crée une nouvelle base de données appelée "DataWarehouse" après avoir vérifié si elle existe déjà.
si la bnase de données existe, elle le supprime puis recrée. De plus, le script configure trois schémas 
au sein de la base de données: 'bronze', 'silver' et 'gold'.

Attention:
L'execution de ce script supprimera toute la base de données 'DataWarehouse' si elle existe.
Toutes les données contenues dans la base de données seront definitivement supprimées. Procédez avec prudence 
et assurez-vous d'avoir effectué des sauvegardes approppriées avant d'éxécuter ce script.
*/

use master;
GO

--Supression et recreation de la base de données "DataWarehouse"
if exists (select 1 from sys.databases where name = 'DataWarehouse')
Begin
    alter database DataWarehouse set single user  with rollback immediate;
    drop database DataWarehouse;
End;

--Créer la base de données "DataWarehouse"
Create database DataWarehouse;
GO
  
use DataWarehouse;
GO
--créer schemas
Create schema bronze; 
GO
  
Create schema silver;
GO
  
Create schema gold;
GO
