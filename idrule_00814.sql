/* Nombre de sessions existantes */

SELECT COUNT(1) nombre_session_existante
 FROM sys.dm_exec_sessions


/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */