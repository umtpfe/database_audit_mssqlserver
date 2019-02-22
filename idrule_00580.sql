/* objets de type clustered de la base*/

SELECT DISTINCT c.object_id 
    FROM sys.all_columns c 
     INNER JOIN sys.indexes i ON c.object_id = i.object_id
    WHERE i.type_desc = 'clustered'

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url =https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-indexes-transact-sql?view=sql-server-2017
etat = 0 */
