/* toute la colonne a une valeur null */

DECLARE @tabname nvarchar(20)
DECLARE tab CURSOR FOR SELECT name FROM sys.tables
OPEN tab 
FETCH NEXT FROM tab INTO @tabname
WHILE @@FETCH_STATUS = 0
 BEGIN
	 DECLARE @tb nvarchar(512) = @tabname;
	 PRINT 'Nom de la table: '+@tabname
	 DECLARE @sql nvarchar(max) = N'SELECT * FROM ' + @tb + ' WHERE 1 = 0';
	 SELECT @sql += N' OR ' + QUOTENAME(name) + ' IS NULL'  FROM sys.columns
	 WHERE [object_id] = OBJECT_ID(@tb);
  	 EXEC sys.sp_executesql @sql;
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
