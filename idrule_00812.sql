/* Nombre de sessions qui sont en etat actives */

SELECT COUNT(1) nombre_session_active
 FROM sys.dm_exec_sessions
 WHERE status = 'running'


/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */