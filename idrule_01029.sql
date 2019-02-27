/* colonne d'une clé composite qui n'est pas une clé primaire dans d'autres tables */


SELECT SCHEMA_NAME(o.schema_id) AS 'Schema' 
 , OBJECT_NAME(i2.object_id) AS 'TableName'
 , STUFF( (SELECT ',' + COL_NAME(ic.object_id,ic.column_ID) 
              FROM sys.indexes i1
               INNER JOIN sys.index_columns ic ON i1.object_id = ic.object_id AND i1.index_id = ic.index_id
           WHERE i1.is_primary_key = 1
           AND i1.object_id = i2.object_id AND i1.index_id = i2.index_id
  FOR XML PATH('')),1,1,'') AS PK
  FROM sys.indexes i2
  INNER JOIN sys.objects o ON i2.object_id = o.object_id
  WHERE i2.is_primary_key = 1
  AND o.type_desc = 'USER_TABLE'


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://sqlrus.com/2018/02/finding-composite-primary-key-columns/
etat = 1 */
