/* Afficher la disponibilite de base de donnees en jours et heures */

SELECT DATEDIFF(DAY, login_time, getdate()) AS days, 
	   DATEDIFF(HOUR, login_time, getdate()) AS hours,
	   host_name
 FROM sys.dm_exec_sessions 
 WHERE session_id = @@spid

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 