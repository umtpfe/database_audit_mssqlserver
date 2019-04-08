/*tables ayant le même nom dans des schémas différents*/

SELECT * FROM INFORMATION_SCHEMA.TABLES it, INFORMATION_SCHEMA.TABLES it1
WHERE it.TABLE_NAME = it1.TABLE_NAME 
AND it.TABLE_SCHEMA <> it1.TABLE_SCHEMA

/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */