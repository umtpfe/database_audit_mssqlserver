/* Informations sur les sessions courantes */

DECLARE @sid INT 
DECLARE cur CURSOR FOR SELECT session_id FROM sys.dm_exec_sessions WHERE status = 'running'
OPEN cur 
FETCH NEXT FROM cur INTO @sid
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT * FROM sys.dm_exec_sessions WHERE session_id = @sid
	FETCH NEXT FROM cur INTO @sid
END
GO
 
/* fiche d'identite
role = DBA
categorie = INF
type = TRANSACT-SQL
basetype  = sqlserver
url = NULL
etat = 1 */