/* Vérifier les curseurs ouverts dans la base  */

SELECT session_id, cursor_id, name
 FROM sys.dm_exec_cursors(0)
 WHERE is_open = 1
	
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 