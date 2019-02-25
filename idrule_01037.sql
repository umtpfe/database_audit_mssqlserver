/*Détails concernant  les  colonnes  des clés primaires indexées*/

SELECT DISTINCT i.TABLE_NAME,   i.CONSTRAINT_NAME, id.index_id,  id.index_column_id 
     FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE i 
      INNER JOIN sys.index_columns id ON i.ordinal_position = id.column_id
     WHERE i.CONSTRAINT_NAME IN ( SELECT name 
				     FROM sys.key_constraints)


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */
