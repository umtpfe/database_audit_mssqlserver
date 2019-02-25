/* clé étrangère reflexive */

SELECT name, object_id, parent_object_id, referenced_object_id
    FROM sys.foreign_keys
   WHERE referenced_object_id = object_id

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */
