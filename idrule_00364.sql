/* Visualisation de tous les non background sessions  */

SELECT p.spid, p.login_time, p.status, p.hostname
 FROM sys.sysprocesses p 
 INNER JOIN sys.dm_exec_sessions s ON p.spid = s.session_id
 WHERE p.status != 'background'
 AND p.hostname IS NOT NULL 
 
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */