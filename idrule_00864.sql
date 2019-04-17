/* Statistiques sur les tables */

DECLARE @nom nvarchar(MAX)
DECLARE cur CURSOR FOR SELECT name FROM sys.tables
OPEN cur 
FETCH NEXT FROM cur INTO @nom
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC sp_statistics @nom
	FETCH NEXT FROM cur INTO @nom
END
CLOSE cur 
DEALLOCATE cur 

/* fiche d'identite
role = DBA
categorie = INF
type = TRANSACT-SQL
basetype  = sqlserver
url = NULL
etat = 1 */