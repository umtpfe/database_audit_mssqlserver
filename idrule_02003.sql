/*tables ayant les memes colonnes*/

DECLARE @model SYSNAME = N'nom_table';
SELECT t.name FROM sys.tables AS t
WHERE t.name <> @model
AND EXISTS
(
  SELECT 1 FROM sys.columns AS c 
    WHERE [object_id] = t.[object_id]
    AND  EXISTS
    (
      SELECT 1 FROM sys.columns
      WHERE [object_id] = OBJECT_ID(N'dbo.' + QUOTENAME(@model))
      AND name = c.name
    )
)


/* fiche d'identitĂ©
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://dba.stackexchange.com/questions/73119/check-if-tables-has-same-columns
etat = 1 */