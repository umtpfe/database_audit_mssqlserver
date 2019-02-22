/* liste de toutes les tables partitionnées de la base */

SELECT DISTINCT t.name
    FROM sys.partitions p
     INNER JOIN sys.tables t ON p.object_id = t.object_id
    WHERE p.partition_number <> 1

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url =https://dba.stackexchange.com/questions/14996/how-do-i-get-a-list-of-all-the-partitioned-tables-in-my-database
etat = 0 */
