/* Liste les Tables de plus de 100 ko non indexées   */

CREATE TABLE #temp (
table_name sysname ,
row_count INT,
reserved_size VARCHAR(50),
data_size VARCHAR(50),
index_size VARCHAR(50),
unused_size VARCHAR(50))
SET NOCOUNT ON
GO 
 
INSERT #temp
GO 

EXEC sp_msforeachtable 'sp_spaceused ''?'''
GO 

SELECT a.table_name, t.object_id, a.row_count, COUNT(*) AS col_count, a.data_size
 FROM #temp a
 INNER JOIN information_schema.columns b ON a.table_name COLLATE database_default = b.table_name COLLATE database_default
 INNER JOIN sys.tables t ON a.table_name COLLATE database_default = t.name COLLATE database_default
 WHERE t.object_id NOT IN ( SELECT object_id FROM sys.indexes )
 AND CAST(REPLACE(a.data_size, ' KB', '') AS INTEGER)  > 100 
 GROUP BY a.table_name,t.object_id, a.row_count, a.data_size
 ORDER BY CAST(REPLACE(a.data_size, ' KB', '') AS INTEGER) DESC
GO 

DROP TABLE #temp
GO 

/* fiche d'identite
role = DBA
categorie = INF
type = TRANSACT-SQL
basetype  = sqlserver
url = NULL
etat = 0 */