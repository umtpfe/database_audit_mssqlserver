/* Nombre de sessions qui sont en etat inactives */

SELECT COUNT(1) nombre_session_inactive
 FROM sys.dm_exec_sessions
 WHERE status = 'slepping'


/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */