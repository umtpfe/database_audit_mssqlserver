/* Lister les synonymes invalides */

SELECT
	name, 
	object_id, 
	type_desc, 
	base_object_name 
FROM 
	sys.synonyms
WHERE is_ms_shipped = 0
AND base_object_name NOT IN ( SELECT '['+name+']' FROM sys.tables )

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 