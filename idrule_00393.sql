/* Structure de la base donnees */

SELECT s.*, t.TABLE_NAME, t.TABLE_TYPE, c.COLUMN_NAME, c.ORDINAL_POSITION, c.DATA_TYPE, c.COLLATION_NAME
 FROM INFORMATION_SCHEMA.SCHEMATA s
 INNER JOIN INFORMATION_SCHEMA.TABLES t ON s.SCHEMA_NAME = t.TABLE_SCHEMA
 INNER JOIN INFORMATION_SCHEMA.COLUMNS c ON t.TABLE_NAME = c.TABLE_NAME
 WHERE CATALOG_NAME = db_name()
 
/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */ 
