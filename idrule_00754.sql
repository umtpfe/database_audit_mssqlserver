/* Détermination du nombres des utilisateurs connectes */

SELECT COUNT (DISTINCT host_name) nbr_userConnnectr
FROM sys.dm_exec_sessions
WHERE host_name IS NOT NULL

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */