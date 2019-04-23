/* Total des curseurs ouverts par nom d'utilisateur et HostMachine */

SELECT COUNT(c.name) nbr_cur, s.host_name, s.login_name
 FROM sys.dm_exec_sessions s 
 INNER JOIN sys.dm_exec_cursors(0) c ON s.session_id = c.session_id
 GROUP BY s.host_name, s.login_name
 ORDER BY 1 DESC
	
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 