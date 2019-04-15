/* Taille total d'une base donnee  */

SELECT database_name = DB_NAME(database_id)
    , row_size_mb = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
    , total_size_mb = CAST(SUM(size) * 8. / 1024 AS DECIMAL(8,2))
FROM sys.master_files WITH(NOWAIT)
WHERE database_id = DB_ID() -- for current db 
GROUP BY database_id

/* fiche d'identite
role = DBA
categorie = INF
type = SQL
basetype  = sqlserver
url = https://stackoverflow.com/questions/18014392/select-sql-server-database-size
etat = 1 */