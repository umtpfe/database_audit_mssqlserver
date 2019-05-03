/* Informations sur les utilisateurs connectees */

 SELECT login_name, session_id, status, last_request_start_time , last_request_end_time
 FROM sys.dm_exec_sessions
 WHERE host_name IS NOT NULL
 ORDER BY status DESC, last_request_start_time DESC
 
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */