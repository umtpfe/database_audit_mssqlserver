/* Trouver le nombre de sessions établie a travers les différents machines */

SELECT DISTINCT host_name, COUNT(*) nbr_occurence
 FROM sys.dm_exec_sessions
 GROUP BY host_name
 ORDER BY nbr_occurence

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */