/* Statistiques sur la session en cours d'utilisation */

SELECT
	login_time,
	host_name,
	host_process_id,
	total_scheduled_time,
	last_request_start_time,
    status,
    session_id,
    program_name
FROM
	sys.dm_exec_sessions
WHERE
	host_name IS NOT NULL
ORDER BY login_time DESC

/* fiche d'identité
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */