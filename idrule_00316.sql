/* lister les colonnes indexées */

SELECT i.object_id, i.index_id, i.index_column_id, i.column_id, i.key_ordinal 
   FROM sys.index_columns i


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url =https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-index-columns-transact-sql?view=sql-server-2017
etat = 0 */
