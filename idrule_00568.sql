/* Listes des tables qui ont ete recemment utilises par une analyse complete de la table */

SELECT
	name,
	object_id,
	type_desc
FROM
	sys.objects
WHERE
	type = 'U'
AND
	is_ms_shipped = 0
	
/* fiche d'identité
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */