/* Donner le temps durant lequel les sessions ont ete inactives */

SELECT session_id, DATEDIFF(SECOND, login_time, last_request_start_time)
 AS inactive_time_second 
 FROM sys.dm_exec_sessions 
 WHERE host_name IS NOT NULL

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 