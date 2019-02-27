/* type de clé étrangère différent de clé primaire */


SELECT isc.table_name nom_table_referée , isc.column_name, isc.data_type, isc1.table_name nom_table_origin, isc1.column_name, isc1.data_type  
    FROM INFORMATION_SCHEMA.COLUMNS isc, INFORMATION_SCHEMA.COLUMNS isc1, INFORMATION_SCHEMA.TABLE_CONSTRAINTS istc, sys.foreign_keys fk
    WHERE isc.TABLE_NAME <> isc1.TABLE_NAME
     AND isc.COLUMN_NAME = isc1.COLUMN_NAME
     AND isc.TABLE_NAME = istc.TABLE_NAME
     AND istc.CONSTRAINT_name = fk.name
     AND isc.DATA_TYPE <> isc1.DATA_TYPE ;

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1
*/

