/* trouver les tables non indexées et les colonnes de contraintes dans la  base */

SELECT t.name nom , t.object_id 
    FROM sys.tables t 
     INNER JOIN sys.indexes i ON t.object_id = i.object_id
    WHERE t.object_id NOT IN ( SELECT i.object_id
				 FROM sys.indexes i)
 UNION ALL
 SELECT c.name nom , c.object_id 
    FROM sys.all_columns c
    WHERE c.object_id IN ( SELECT ck.parent_object_id 
				FROM sys.check_constraints ck UNION
			   SELECT k.parent_object_id 
				FROM sys.key_constraints k  UNION
			   SELECT f.parent_object_id 
				FROM sys.foreign_keys f )

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = Performance Monitoring Scripts
etat = 0 */

