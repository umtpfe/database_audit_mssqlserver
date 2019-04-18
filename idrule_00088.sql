/* Determiner les derniers checkpoints */ 

SELECT session_id, request_id, start_time, status, command, user_id, wait_type, wait_time
 FROM sys.dm_exec_requests 
 WHERE command = N'CHECKPOINT'
 ORDER BY wait_type DESC

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */