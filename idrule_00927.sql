/* Détermination des indexes invalides pour un propriétaire */

SELECT sys.objects.name AS table_name, sys.indexes.name AS index_name
    FROM sys.indexes
    INNER JOIN sys.objects ON sys.objects.object_id = sys.indexes.object_id
   WHERE sys.indexes.is_disabled = 1
   ORDER BY sys.objects.name, sys.indexes.name;

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */
