/* Clé étrangère sans index ne faisant pas partie de la clé primaire */

SELECT f.name 
     FROM sys.foreign_keys f 
     WHERE f.parent_object_id NOT IN ( 
				      SELECT  i.object_id FROM sys.indexes i )
     AND f.referenced_object_id NOT IN (
				      SELECT parent_object_id FROM sys.key_constraints);

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */

