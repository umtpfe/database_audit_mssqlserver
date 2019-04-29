/* Informations sur la session active */

SELECT * FROM sys.dm_exec_sessions WHERE session_id = @@spid AND status = 'running'

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */