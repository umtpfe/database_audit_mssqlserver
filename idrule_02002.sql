/*liste des bases et schemas par serveur*/

DECLARE @sql nvarchar(max);
SET @sql = N'SELECT CAST(''master'' AS sysname) AS db_name, name schema_name, schema_id, CAST(1 AS int) AS database_id FROM master.sys.schemas ';
SELECT @sql = @sql + N' UNION ALL SELECT ' + quotename(name,'''')+ N', name schema_name, schema_id, ' + CAST(database_id AS nvarchar(10)) + N' FROM ' + quotename(name) + N'.sys.schemas'
FROM sys.databases WHERE database_id > 1
AND state = 0
AND user_access = 0;

EXEC sp_executesql @sql;

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://stackoverflow.com/questions/21949388/how-to-get-schema-tables-from-another-database
etat = 1 */
