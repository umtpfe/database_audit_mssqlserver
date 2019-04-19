/* Total des curseurs ouvertes par session */

SELECT s.session_id, COUNT(c.cursor_id) nmbr_cursor
 FROM sys.dm_exec_sessions s 
 INNER JOIN sys.dm_exec_cursors(0) c ON s.session_id = c.session_id
 WHERE c.is_open = 1
 GROUP BY s.session_id

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 