/* Déterminations des sessions qui utilisent le plus des curseurs */

SELECT s.session_id, s.login_name, s.status, sc.cursor_id, sc.name, sc.is_open 
 FROM sys.dm_exec_sessions s
 INNER JOIN sys.dm_exec_cursors(0) sc ON s.session_id = sc.session_id

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */