/* objets avec leurs détails des dernières modifications */

SELECT object_id, create_date, modify_date,current_timestamp AS timestamp   
    FROM sys.all_objects
    WHERE [type]='u';


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-all-objects-transact-sql?view=sql-server-2017
etat = 1 */
