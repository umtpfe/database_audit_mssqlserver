/* Calcul de nombre maximal de curseurs ouverts pour une session */

SELECT COUNT(name) nombre_curseur
 FROM sys.dm_exec_cursors(@@spid)
 WHERE is_open = 1
	
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 