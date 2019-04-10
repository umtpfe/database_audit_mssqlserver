/*liste des bases et schemas par serveur*/

declare @sql nvarchar(max);
set @sql = N'select cast(''master'' as sysname) as db_name, name schema_name, schema_id, cast(1 as int) as database_id  from master.sys.schemas ';

select @sql = @sql + N' union all select ' + quotename(name,'''')+ ', name schema_name, schema_id, ' + cast(database_id as nvarchar(10)) + N' from ' + quotename(name) + N'.sys.schemas'
from sys.databases where database_id > 1
and state = 0
and user_access = 0;

exec sp_executesql @sql;

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://stackoverflow.com/questions/21949388/how-to-get-schema-tables-from-another-database
etat = 1 */