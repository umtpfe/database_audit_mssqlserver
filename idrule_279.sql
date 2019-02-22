/* informations sur les objets d'un utilisateur */

SELECT o.name, o.object_id, o.type, count(1) 
     FROM sys.all_objects o
     WHERE o.type='u' GROUP BY o.name, o.object_id, o.type ORDER BY o.type


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url =https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-all-objects-transact-sql?view=sql-server-2017
etat = 0 */
