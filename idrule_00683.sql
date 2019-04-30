/* Affichage de tous les sessions actuels avec ses informations d'E/S */

SELECT
	session_id,
	login_name,
	status,
	host_name,
	host_process_id,
	lock_timeout
FROM
	sys.dm_exec_sessions
WHERE lock_timeout IS NOT NULL

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */