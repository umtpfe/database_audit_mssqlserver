/* Liste des fichiers de la base */

SELECT
	file_id, name, type_desc,
	physical_name, size, max_size,
	state_desc
FROM sys.database_files ;  

/* fiche d'identité
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */

