/* Détermination du nombre des sessions connectées  */

SELECT COUNT(1) nbr_seesion_connecter
 FROM sys.dm_exec_sessions
 WHERE host_name IS NOT NULL

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */