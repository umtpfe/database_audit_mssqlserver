/* date de derniere modification */

SELECT name, create_date, modify_date
 FROM sys.objects
 WHERE is_ms_shipped <> 1

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 0 */