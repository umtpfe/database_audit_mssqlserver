/* Lister les curseurs ouverts ordonnee par le cout moyen du curseur */

SELECT c.session_id, c.cursor_id, c.worker_time, c.sql_handle, c.is_open, c.creation_time, c.dormant_duration
 FROM sys.dm_exec_cursors(0) c
 WHERE c.is_open = 1
 ORDER BY c.worker_time DESC
 
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 