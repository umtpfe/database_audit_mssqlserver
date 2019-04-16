/* Nombre maximal des curseurs allouees et le nombre total des curseurs ouverts */

SELECT COUNT(s.name) total_cursor 
FROM sys.dm_exec_cursors(0) s 
GO

SELECT COUNT(s.name) total_open_cursor 
FROM sys.dm_exec_cursors(0) s 
WHERE s.is_open = 0
GO 
	
/* fiche d'identite
role = DBA
categorie = INF
type = TRANSACT-SQL
basetype  = sqlserver
url = NULL
etat = 1 */