/* toute la colonne a une valeur null */

DECLARE @tabname nvarchar(20)
DECLARE tab CURSOR FOR SELECT name FROM sys.tables
OPEN tab 
FETCH NEXT FROM tab INTO @tabname
WHILE @@FETCH_STATUS = 0
 BEGIN
	 DECLARE @colname nvarchar(20)
	 DECLARE col CURSOR FOR SELECT column_name 
				FROM INFORMATION_SCHEMA.COLUMNS 
				WHERE table_name = @tabname
	 OPEN col
	 FETCH NEXT FROM col INTO @colname
	 WHILE @@FETCH_STATUS = 0
	   BEGIN
		   DECLARE @sql nvarchar(max)
		   PRINT 'Nom de la colonne : '+@tabname+'.'+@colname
		   SET @sql = 'SELECT COUNT ( DISTINCT '+@colname+' ) nbr_valeur FROM '+@tabname+';'
	 	   EXEC sp_executeSQL @sql
		   FETCH NEXT FROM col INTO @colname
	   END
	   CLOSE col 
	   DEALLOCATE col 
FETCH NEXT FROM tab INTO @tabname
END
CLOSE tab 
DEALLOCATE tab


/* fiche d'identité 
role = DBA
categorie = CON
type = Transact-SQL
basetype  = sqlserver
url = https://dba.stackexchange.com/questions/14864/test-if-any-columns-are-null
etat = 1 */
