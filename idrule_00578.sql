/* activé les clés etrangères d'un utilisateur */

DECLARE @fkname nvarchar(100)
DECLARE fk CURSOR FOR  SELECT name FROM sys.foreign_keys
OPEN fk 
FETCH NEXT FROM fk INTO @fkname
WHILE @@FETCH_STATUS = 0
	BEGIN
	 DECLARE @tabname nvarchar(100)
	 SELECT @tabname = t.name 
	 FROM sys.tables t 
	 WHERE t.object_id = (SELECT parent_object_id FROM sys.foreign_keys WHERE name = @fkname)
  		BEGIN
			DECLARE @sql nvarchar(MAX)
	 		SET @sql = 'ALTER TABLE '+@tabname+' CHECK CONSTRAINT '+@fkname+';'
	 		EXEC sp_executeSQL @sql 
	 		SELECT 'la clé etrangere '+@fkname+' a ete activée'
  		END
         FETCH NEXT FROM fk INTO @fkname
	END
CLOSE fk 
DEALLOCATE fk 


/* fiche d'identité
role = DBA
categorie = CON
type = Transact-SQL
basetype  = sqlserver
url =https://docs.microsoft.com/en-us/sql/relational-databases/tables/disable-foreign-key-constraints-with-insert-and-update-statements?view=sql-server-2017
etat = 0 */
