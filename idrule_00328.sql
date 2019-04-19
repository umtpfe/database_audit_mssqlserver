/* Lister les details des curseurs qui sont actuellement ouverts */

SELECT * FROM sys.dm_exec_cursors(0) WHERE is_open = 1

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 