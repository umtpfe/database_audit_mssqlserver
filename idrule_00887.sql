/* Informations sur les sessions  */

SELECT session_id, login_time, host_name, program_name, client_interface_name, login_name, status 
FROM sys.dm_exec_sessions


/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */