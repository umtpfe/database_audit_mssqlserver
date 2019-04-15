/* Liste les tables de la base n'ayant aucune  statistiques  calculees */

SELECT t.name 
 FROM sys.tables t 
 WHERE t.object_id NOT IN ( SELECT DISTINCT object_id FROM sys.stats )

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */