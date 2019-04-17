/* Liste des sessions les plus consommatrices */

SELECT session_id, login_time, login_name, client_interface_name, cpu_time, status
 FROM sys.dm_exec_sessions
 ORDER BY cpu_time DESC

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */