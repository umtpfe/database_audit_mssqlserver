/* Version, date de dernier demarrage */

SELECT @@version version, login_time
 FROM sys.dm_exec_sessions
 WHERE status = 'running' 
 
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 
