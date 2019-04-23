/* Details concernant les curseurs ouverts a un instant donnee */

SELECT 
	session_id, 
	cursor_id, 
	name,
	is_open, 
	creation_time, 
	properties 
FROM 
	sys.dm_exec_cursors(0)
WHERE 
	is_open = 1	
	
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 