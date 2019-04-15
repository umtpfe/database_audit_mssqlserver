/* Statistiques sur les sessions */

SELECT s.*, s1.host_name FROM sys.dm_exec_session_wait_stats s
INNER JOIN sys.dm_exec_sessions s1 ON s.session_id = s1.session_id

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-session-wait-stats-transact-sql?view=sql-server-2017
etat = 1 */