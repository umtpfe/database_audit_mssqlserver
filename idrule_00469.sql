/* Nombre total des indexes */

SELECT COUNT(1) FROM sys.indexes WHERE type_desc IN ('CLUSTERED','NONCLUSTERED')

/* fiche d'identite
role = USER
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 0 */