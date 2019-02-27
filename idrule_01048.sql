/*Nom de colonnes identiques et de taille différents dans différentes tables*/

SELECT DISTINCT i.TABLE_NAME, i.COLUMN_name, ic.TABLE_NAME, ic.COLUMN_name , ic.data_type
    FROM INFORMATION_SCHEMA.COLUMNS i,INFORMATION_SCHEMA.COLUMNS ic
   WHERE i.COLUMN_NAME = ic.COLUMN_NAME
    AND col_length('i.table_name', 'i.column_name') <> col_length('ic.table_name', 'ic.column_name') 


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */
