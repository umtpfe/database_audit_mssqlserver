/* Détails sur tous les utilisateurs des sessions actives */

SELECT * FROM sys.dm_exec_sessions
 WHERE status = 'running'
 AND login_name IS NOT NULL


/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = 1
etat = 1 */