/* liste des tables non indexées de la base */

SELECT t.object_id, t.name 
    FROM sys.tables t 
     INNER JOIN sys.indexes i ON t.object_id = i.object_id
    WHERE t.object_id NOT IN ( SELECT object_id 
				   FROM sys.indexes )


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url =https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-indexes-transact-sql?view=sql-server-2017
etat = 0 */
