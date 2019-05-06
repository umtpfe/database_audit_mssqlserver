/* Afficher nom d'utilisateur et SID/SPID avec le nom du programme */

SELECT session_id, login_name, program_name
FROM sys.dm_exec_sessions
	
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype = sqlserver
url = NULL
etat = 1 */ 