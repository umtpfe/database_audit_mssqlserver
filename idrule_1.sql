/* table sans clé primaire */

SELECT DISTINCT t.name, t.object_id 
    FROM sys.tables t
    INNER JOIN sys.columns c 
 	ON t.object_id = c.object_id
    WHERE c.object_id NOT IN (SELECT ck.parent_object_id
			       FROM sys.key_constraints ck );

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-key-constraints-transact-sql?view=sql-server-2017
etat = 1 */

