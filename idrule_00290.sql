/* Affichage et calcul du nombres des sessions dans une base donnees */

SELECT host_name, program_name, login_name, COUNT(*) sessions 
 FROM sys.dm_exec_sessions
 GROUP BY host_name, program_name, login_name
 ORDER BY login_name, sessions

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */