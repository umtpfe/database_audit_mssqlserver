/* Suivi du temps d'ouverture de session de DB utilisateur et utilisateur d'OS */

SELECT p.spid, p.status, p.login_time, p.hostname, p.loginame, p.nt_username, s.original_login_name
 FROM sys.sysprocesses p
 INNER JOIN sys.dm_exec_sessions s ON p.spid = s.session_id
 WHERE p.status <> 'background'

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 