/* Affichage des informations des objets stockés */

SELECT name, type
    FROM dbo.sysobjects
     WHERE type IN (
    'P', -- stored procedures
    'FN', -- scalar functions 
    'IF', -- inline table-valued functions
    'TF' -- table-valued functions
                    )
      ORDER BY type, name;


/* fiche d'identité 
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = NULL
etat = 1 */
