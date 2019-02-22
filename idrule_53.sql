/* clé étrangère sans index */

SELECT DISTINCT f.name, f.object_id, f.parent_object_id 
     FROM sys.foreign_keys f
      INNER JOIN sys.indexes i ON f.key_index_id = i.index_id
     WHERE f.key_index_id IN ( SELECT i.index_id 
				   FROM sys.indexes i)

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = Performance Monitoring Scripts
etat = 0 */
