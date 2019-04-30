/* Déterminer l'état de la base */

SELECT
	name,
	state_desc,
	is_in_standby,
	is_cleanly_shutdown,
	delayed_durability_desc
FROM
	sys.databases
	
/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */