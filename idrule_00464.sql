/* Trouver la derniere DDL performee dans une base donnee */

SELECT name, object_id, create_date, modify_date, CURRENT_TIMESTAMP AS timestamps
FROM sys.all_objects 
WHERE type = 'U'
ORDER by timestamps DESC
	
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */