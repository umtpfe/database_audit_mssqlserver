/* Determiner le sid/serial/status de tous les utilisateurs */

SELECT 
	login_name,
    session_id,
    host_process_id,
    status
FROM 
	sys.dm_exec_sessions
WHERE 
	host_name IS NOT NULL

/* fiche d'identité
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */