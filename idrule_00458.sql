/* Détails sur les utilisateurs actifs */

SELECT DB_NAME(dbid) as NomBD, COUNT(dbid) as NbrdeConnexion, loginame
FROM sys.sysprocesses
WHERE dbid > 0
GROUP BY dbid, loginame
	
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = https://docs.microsoft.com/en-us/sql/relational-databases/system-compatibility-views/sys-sysprocesses-transact-sql?view=sql-server-2017
etat = 1 */