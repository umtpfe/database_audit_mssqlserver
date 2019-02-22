/* Informations sur les tables actives qui sont deverouillées */

SELECT  
    object_name(p.object_id) AS TableName, 
    resource_type, resource_description
   FROM
    sys.dm_tran_locks l
    JOIN sys.partitions p ON l.resource_associated_entity_id = p.hobt_id


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://stackoverflow.com/questions/599453/find-locked-table-in-sql-server
etat = 0 */
