/*Nom de colonnes identiques et de types différents dans différentes tables*/

SELECT DISTINCT i.TABLE_NAME, i.COLUMN_name , i.data_type, ic.TABLE_NAME, ic.COLUMN_name , ic.data_type 
    FROM INFORMATION_SCHEMA.COLUMNS i,INFORMATION_SCHEMA.COLUMNS ic
   WHERE i.COLUMN_NAME = ic.COLUMN_NAME
    AND i.DATA_TYPE <> ic.DATA_TYPE


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */
