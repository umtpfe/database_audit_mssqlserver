/*Résultat sur les Intersection des indexes(2 indexes ou plus sur même colonne)*/

SELECT a.object_id, a.index_id, a.index_column_id, a.column_id, 
		b.index_id, b.index_column_id, b.column_id 
    FROM sys.index_columns a, sys.index_columns b
    WHERE a.object_id = b.object_id
     AND a.index_id = b.index_id
     AND a.index_column_id < b.index_column_id ORDER BY 3;


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */
