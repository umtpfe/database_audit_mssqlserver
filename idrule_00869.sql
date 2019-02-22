/* nombre total de ligne de la base */

SELECT sum(row_count) nbr_ligne_total 
    FROM sys.dm_db_partition_stats;


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url =https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-partition-stats-transact-sql?view=sql-server-2017
etat = 0 */
