/* Construction des suppression des synonymes invalides */

DECLARE @syn nvarchar(max)
DECLARE @sql nvarchar(max)
DECLARE curseur CURSOR FOR 
				SELECT	name
				FROM 	
					sys.synonyms
				WHERE is_ms_shipped = 0
				AND base_object_name NOT IN ( SELECT '['+name+']' FROM sys.tables )
OPEN curseur
FETCH NEXT FROM curseur INTO @syn
WHILE @@fetch_status = 0 
BEGIN
	SET @sql = 'DROP SYNONYM '+@syn
	EXEC sp_executesql @sql
	FETCH NEXT FROM curseur INTO @syn
END
CLOSE curseur
DEALLOCATE curseur
GO

/* fiche d'identite
role = DBA
categorie = INF
type = TRANSACT-SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 