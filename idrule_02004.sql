/*tables ayant les memes colonnes et de memes type*/

DECLARE cur CURSOR FOR SELECT name FROM sys.tables order by name
DECLARE @model SYSNAME
OPEN cur 
FETCH NEXT FROM cur INTO @model
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'tables de memes nom de colonnes et de colonnes de memes type que '+@model
	SELECT t.name FROM sys.tables AS t
	WHERE name <> @model
	AND EXISTS
	(
 	 SELECT c.name FROM sys.columns AS c 
 	   WHERE [object_id] = t.[object_id]
  	  AND EXISTS
  	  (
   	   SELECT name FROM sys.columns
   	   WHERE [object_id] = OBJECT_ID(N'dbo.'+quotename(@model))
   	   and  TYPE_NAME(user_type_id) = TYPE_NAME(c.user_type_id) 
   	   AND name = c.name
  	  )
	)
	order by t.name
	FETCH NEXT FROM cur INTO @model
END
CLOSE cur 
DEALLOCATE cur 

/* fiche d'identitĂ©
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://docs.microsoft.com/fr-fr/sql/t-sql/functions/type-name-transact-sql?view=sql-server-2017
etat = 1 */