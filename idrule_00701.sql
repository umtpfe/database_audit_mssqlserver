/* Informations sur la base */

SELECT
	name,
	is_encrypted,
	is_master_key_encrypted_by_server,
	page_verify_option_desc,
	recovery_model_desc
FROM
	sys.databases
	
/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */