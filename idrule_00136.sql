/* Informations sur le proprietaire  */

SELECT u.name, o.object_id, o.name, o.type_desc FROM sys.sysusers u
INNER JOIN sys.objects o ON u.uid = o.schema_id
WHERE u.name = CURRENT_USER

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */