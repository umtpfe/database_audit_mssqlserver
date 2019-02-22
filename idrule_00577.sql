/* Desactivé les clés etrangères d'un utilisateur */

ALTER TABLE ['table_schema']  
NOCHECK CONSTRAINT ['foreign_key_name'];

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url =https://docs.microsoft.com/en-us/sql/relational-databases/tables/disable-foreign-key-constraints-with-insert-and-update-statements?view=sql-server-2017
etat = 0 */
