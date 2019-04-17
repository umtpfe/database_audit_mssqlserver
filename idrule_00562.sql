/* Les sessions dont on exécute le plus des curseurs */

SELECT s.session_id, s.login_name, s.host_name, count(*) nbr_cur_open 
 FROM sys.dm_exec_sessions s
 INNER JOIN sys.dm_exec_cursors(0) sc ON s.session_id = sc.session_id
 WHERE sc.is_open = 0
 GROUP BY s.session_id, s.login_name, s.host_name
 ORDER BY s.session_id, s.login_name
 
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */