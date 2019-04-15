/* Nombre d'objets crees depuis la derniere semaine */

SELECT COUNT(1) FROM sys.objects WHERE create_date >= getdate() - 7

/* fiche d'identite
role = USER
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 0 */