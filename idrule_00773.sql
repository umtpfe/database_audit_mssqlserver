/* Details sur Temps depuis la derniere activite de l'utilisateur dans la base de donnees */

 SELECT login_name, status , CAST(last_request_end_time AS TIME) dernier_activite
 FROM sys.dm_exec_sessions
 WHERE host_name IS NOT NULL
 ORDER BY last_request_end_time
 
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */