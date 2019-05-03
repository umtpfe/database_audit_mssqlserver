/* Suivi du temps d'ouverture de session de DB utilisateur et utilisateur d'OS */

SELECT 
	CONVERT(VARCHAR(50), login_time, 120) login_date,
	login_name,
	host_name,
	status
FROM
	sys.dm_exec_sessions 
WHERE
	host_name IS NOT NULL
AND 
	status <> 'background'
	
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 