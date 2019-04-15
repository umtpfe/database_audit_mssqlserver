/* Lister les contraintes d''une table ou vue */

DECLARE @nom nvarchar(MAX)
DECLARE cur CURSOR FOR SELECT name FROM sys.objects WHERE [type] = 'U'
OPEN cur
FETCH NEXT FROM cur INTO @nom
WHILE @@FETCH_STATUS = 0
BEGIN 
	SELECT TABLE_SCHEMA, TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE  from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE TABLE_NAME = @nom
	GROUP BY TABLE_SCHEMA, TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
	FETCH NEXT FROM cur INTO @nom
END
CLOSE cur 
DEALLOCATE cur

/* fiche d'identite
role = DBA
categorie = INF
type = Transact-SQL
basetype  = sqlserver
url = NULL
etat = 1 */