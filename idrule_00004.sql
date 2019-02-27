/* toute la colonne a une valeur null supérieur à 50% */

DECLARE @tb nvarchar(512) = N'dbo.[table]';

DECLARE @sql nvarchar(max) = N'SELECT * FROM ' + @tb
    + ' WHERE 1 = 0';

SELECT @sql += N' OR ' + QUOTENAME(name) + ' IS NULL'
    FROM sys.columns 
    WHERE [object_id] = OBJECT_ID(@tb)
    AND @sql > 0.5 ;
EXEC sys.sp_executesql @sql;


/* fiche d'identité 
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */
