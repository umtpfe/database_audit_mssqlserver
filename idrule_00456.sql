/* Détails sur tous les utilisateurs des sessions */

SELECT * FROM sys.dm_exec_sessions
 WHERE login_name IS NOT NULL


/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */