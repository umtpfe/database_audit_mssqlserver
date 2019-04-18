/* Afficher les details des sessions connectees pour un specifique mssqlserver système ID */

SELECT s.session_id, s.host_name, s.program_name, p.spid 
FROM sys.dm_exec_sessions s
INNER JOIN sys.sysprocesses p ON s.session_id = p.spid
WHERE s.host_name IS NOT NULL -- omit background processes and p.spid like 'spid%'
 
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */