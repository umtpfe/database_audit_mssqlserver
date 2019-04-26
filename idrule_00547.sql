/* Details sur les session existants */

SELECT
	s.session_id,
	s.login_name,
	s.host_name,
	s.program_name,
	p.kpid 
FROM 
	sys.dm_exec_sessions s
INNER JOIN sys.sysprocesses p ON s.session_id = p.spid

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 