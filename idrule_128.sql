/* table avec leurs  nombre de lignes */

SELECT t.object_id, t.name, p.row_count
    FROM sys.all_objects t
     INNER JOIN sys.dm_db_partition_stats p
          ON  t.object_id = p.object_id 
      GROUP BY t.object_id, t.name, p.row_count ORDER BY p.row_count ASC;

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = Performance Monitoring Scripts
etat = 1 */
