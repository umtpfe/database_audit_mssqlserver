/* Verifier les plus longues sessions  */

SELECT session_id, login_time, total_elapsed_time 
 FROM sys.dm_exec_sessions 
 ORDER BY total_elapsed_time DESC

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */