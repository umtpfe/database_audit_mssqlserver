/* Nombre des lignes total de tous les tables utilisateurs */

DECLARE @sql nvarchar(MAX) 
DECLARE @name NVARCHAR(MAX)
DECLARE cur CURSOR FOR SELECT name FROM sys.tables 
OPEN cur 
FETCH NEXT FROM cur INTO @name
WHILE @@fetch_status = 0 
BEGIN
	PRINT 'Table: '+@name
	SET @sql = ' select count(*) nombre_lignes from '+@name
	EXEC sp_executesql @sql
	FETCH NEXT FROM cur INTO @name
END
CLOSE cur 
DEALLOCATE cur

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype = sqlserver
url = NULL
etat = 1 */