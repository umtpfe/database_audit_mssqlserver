/* Informations sur les privileges des objets */

SELECT GRANTOR, GRANTEE, TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, PRIVILEGE_TYPE, IS_GRANTABLE
FROM INFORMATION_SCHEMA.TABLE_PRIVILEGES
ORDER BY 1, 2, 3, 4

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */