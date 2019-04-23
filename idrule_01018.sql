/* statistiques sur les job_name */

SELECT 
	job_id,
	originating_server_id,
	name,
	enabled,
	description, 
	start_step_id,
	category_id, 
	owner_sid,
	notify_email_operator_id,
	notify_level_email,
	notify_level_eventlog,
	notify_level_netsend,
	notify_level_page,
	notify_netsend_operator_id,
	notify_page_operator_id,
	delete_level,
	date_created,
	date_modified,
	version_number
FROM 
	msdb.dbo.sysjobs 

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 