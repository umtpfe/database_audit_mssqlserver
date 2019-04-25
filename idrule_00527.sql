/* Affichage de nombre de differents types d'objets */

SELECT
	type,
	type_desc, 
	COUNT(*) nbr_objects
FROM
	sys.objects
GROUP BY 
	type,
	type_desc

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 