/* Chercher le sql_text par le sid */

SELECT 
	p.spid,
    p.hostname,
    p.hostprocess,
    t.text
FROM 
	sys.sysprocesses p
CROSS APPLY sys.dm_exec_sql_text(p.sql_handle) AS t
WHERE
	p.spid = @@spid
	
/* fiche d'identité
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */

