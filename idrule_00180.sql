/*  Detailler toutes les tables d'une base donnee pour un proprietaire donnee */

SELECT s.name owner_name, t.name table_name, t.object_id, t.schema_id, t.type_desc , t.modify_date, t.max_column_id_used 
 FROM sys.schemas s 
 INNER JOIN sys.tables t ON t.schema_id = s.schema_id
 WHERE t.is_ms_shipped = 0

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = NULL
etat = 0 */