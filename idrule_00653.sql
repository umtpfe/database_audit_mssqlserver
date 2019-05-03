/* Determination le nombre de tous les utilisateurs actifs et inactifs */

SELECT 
    DB_NAME(dbid) as DBName, 
    COUNT(dbid) as NumberOfConnections,
    loginame as LoginName,
    program_name,
    hostname
FROM
    sys.sysprocesses
WHERE 
    dbid > 0
GROUP BY 
    dbid, loginame, hostname, program_name
	
/* fiche d'identité
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */