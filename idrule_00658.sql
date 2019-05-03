/* Obtenir le id de session qui utilise le pid */

SELECT 
	s.session_id,
    s.host_process_id,
    s.program_name,
    t.text
FROM 
	sys.dm_exec_sessions s
INNER JOIN
	sys.sysprocesses p ON s.session_id = p.spid
CROSS APPLY sys.dm_exec_sql_text(p.sql_handle) AS t

/* fiche d'identité
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */