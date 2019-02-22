/* informations sur les indexes */

SELECT i.object_id, i.name, i.index_id, i.type_desc, i.is_unique, i.is_primary_key 
    FROM sys.indexes i
     INNER JOIN sys.all_objects o ON i.object_id = o.object_id
    WHERE o.type_desc='user_table';

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-all-indexes-transact-sql?view=sql-server-2017
etat = 0 */

