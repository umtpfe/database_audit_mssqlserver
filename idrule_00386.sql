/* Nom et id: informations d'une base donnée */

SELECT name, database_id 
FROM sys.databases
WHERE database_id = DB_ID()

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */