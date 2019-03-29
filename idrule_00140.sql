/* statistique sur les indexes des utilisateurs */

DECLARE @indname nvarchar(100)
DECLARE ind CURSOR FOR SELECT i.name
			FROM sys.indexes i INNER JOIN sys.tables t ON i.object_id = t.object_id
			WHERE i.name IS NOT NULL 
OPEN ind
FETCH NEXT FROM ind INTO @indname
WHILE @@FETCH_STATUS = 0
BEGIN
 	 DECLARE @tabname nvarchar(20)
	 DECLARE tab CURSOR FOR SELECT t.name
				FROM sys.tables t INNER JOIN sys.indexes i ON i.object_id = t.object_id 
				WHERE i.name = @indname
	 OPEN tab 
	 FETCH NEXT FROM tab INTO @tabname
	 WHILE @@FETCH_STATUS = 0
	 BEGIN
		PRINT 'Nom index : '+@indname
		DBCC SHOW_STATISTICS (@tabname , @indname)
	 	FETCH NEXT FROM tab INTO @tabname 
	 END
	 CLOSE tab 
	 DEALLOCATE tab  
FETCH NEXT FROM ind INTO @indname
END
CLOSE ind 
DEALLOCATE ind

/* fiche d'identité
role = DBA
categorie = CON
type = Transact-SQL
basetype  = sqlserver
url = https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-show-statistics-transact-sql?view=sql-server-2017
etat = 0 */
