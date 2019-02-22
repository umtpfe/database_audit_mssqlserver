/* affichage le nombre de lignes pour chaque table qui a été analyser d'un propriétaire donnée */

SELECT t.object_id,t.schema_id ,t.name, p.row_count
    FROM sys.tables t
     INNER JOIN sys.dm_db_partition_stats p ON t.object_id = p.object_id
    WHERE p.row_count > 0 AND t.schema_id = <table_schema>;


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-partition-stats-transact-sql?view=sql-server-2017
etat = 0 */
