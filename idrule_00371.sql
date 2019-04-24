/* Objets qui appartiennent a un utilisateur */

SELECT o.* 
 FROM sys.objects o 
 WHERE is_ms_shipped = 0
 ORDER BY 2

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 