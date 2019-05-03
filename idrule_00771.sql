 /* Determiner la date de début d'utilisation de la base */
 
 SELECT s.login_time startup_time, d.name db_name
 FROM sys.dm_exec_sessions s
 INNER JOIN sys.databases d ON s.database_id = d.database_id
 WHERE s.status = 'running'
 AND d.state_desc = 'ONLINE'
 
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */