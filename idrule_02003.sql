/*tables ayant les memes colonnes*/

DECLARE cur CURSOR FOR SELECT name FROM sys.tables
DECLARE @model SYSNAME
OPEN cur 
FETCH NEXT FROM cur INTO @model
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'table de meme colonnes que '+@model
	SELECT t.name FROM sys.tables AS t
	WHERE name <> @model
	AND EXISTS
	(
 	 SELECT 1 FROM sys.columns AS c 
 	   WHERE [object_id] = t.[object_id]
  	  AND EXISTS
  	  (
   	   SELECT 1 FROM sys.columns
   	   WHERE [object_id] = OBJECT_ID(N'dbo.' + QUOTENAME(@model))
   	   AND name = c.name
  	  )
	)
	FETCH NEXT FROM cur INTO @model
END
CLOSE cur 
DEALLOCATE cur


/* fiche d'identitĂ©
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://dba.stackexchange.com/questions/73119/check-if-tables-has-same-columns
etat = 1 */