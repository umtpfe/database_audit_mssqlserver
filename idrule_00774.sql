/*  Vérifier les informations de l'utilisateur, y compris OS process_id */

 SELECT s.session_id, s.login_name, s.host_name, s.host_process_id, p.kpid, s.program_name
 FROM sys.dm_exec_sessions s 
 INNER JOIN sys.sysprocesses p ON s.session_id = p.spid
 ORDER BY p.kpid DESC
 
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */