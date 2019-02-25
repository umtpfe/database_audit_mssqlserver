/*Liste des clés étrangères qui ne sont pas nommées comme les clés primaires */

SELECT c.name 
     FROM sys.all_columns c 
     WHERE c.object_id IN ( SELECT parent_object_id
			       FROM sys.foreign_keys)
     AND c.name NOT IN ( SELECT name 
  			    FROM sys.all_columns
			    WHERE object_id IN ( SELECT parent_object_id
			                           FROM sys.key_constraints 
						   WHERE type='PK' ) )


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */
