/* Informations sur la base */

SELECT 
	name, create_date, user_access_desc, collation_name,
	state_desc, is_auto_create_stats_on, is_auto_update_stats_on,
	is_encrypted, recovery_model_desc, page_verify_option_desc
FROM sys.databases
WHERE name = db_name()

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */