/*table vide */

SELECT t.object_id, t.name 
    FROM sys.tables t
     INNER JOIN sys.dm_db_partition_stats p ON t.object_id = p.object_id 
    WHERE p.row_count = 0;

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-partition-stats-transact-sql?view=sql-server-2017
etat = 1 */

