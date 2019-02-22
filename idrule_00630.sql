/* détails sur les tables  d'un propriétaire donnée */

SELECT name, object_id, schema_id, parent_object_id, type
    FROM sys.tables
    WHERE [type]='u' AND schema_id = <table_schema>;

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url =https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-tables-transact-sql?view=sql-server-2017
etat = 0 */
