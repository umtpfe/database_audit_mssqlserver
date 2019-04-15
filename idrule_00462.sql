/* Informations sur les objets d''une base donnée */

SELECT name, object_id, type_desc, COUNT(*)
 FROM sys.objects 
 WHERE is_ms_shipped <> 1
 GROUP BY name, object_id, type_desc
 ORDER BY name 
	
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */