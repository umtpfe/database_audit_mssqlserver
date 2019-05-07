/* Donner pour chaque utilisateur l'événement qu'il fait */

SELECT session_id, host_name, status
 FROM sys.dm_exec_sessions

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype = sqlserver
url = NULL
etat = 1 */