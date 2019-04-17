/* Les sessions qui fonctionnent pendant au moins 6 heures  */

SELECT session_id, login_time, login_name, host_name, total_elapsed_time , total_scheduled_time,status 
 FROM sys.dm_exec_sessions 
 WHERE total_elapsed_time  >= 21600
 ORDER BY total_elapsed_time DESC

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */