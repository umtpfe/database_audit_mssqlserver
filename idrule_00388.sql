/* Suivi de l'etat actuel d'une base donnees */

SELECT 
	name,
	create_date,
	user_access_desc,
	is_in_standby,
	state_desc,
	target_recovery_time_in_seconds
FROM 
	sys.databases
 
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 
