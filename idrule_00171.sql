/* rapport sur les objets qui n'ont pas de statistique */

SELECT o.object_id, o.name , s.name stat_name
    FROM sys.all_objects o
     INNER JOIN sys.stats s ON o.object_id = s.object_id
    WHERE o.object_id NOT IN ( SELECT object_id FROM sys.stats );

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys.stats-transact-sql?view=sql-server-2017
etat = 0 */
