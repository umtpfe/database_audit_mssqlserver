/* afficher tous les indexes existants pour un propriétaire */

SELECT i.object_id, i.name, i.index_id, i.type 
    FROM sys.indexes i
     INNER JOIN sys.tables t on i.object_id = t.object_id
    WHERE  t.schema_id = <table_schema>
    ORDER BY i.object_id, i.name, i.index_id ;

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 0 */
