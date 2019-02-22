/* statistique sur les indexes des utilisateurs */

DBCC SHOW_STATISTICS ( table_or_indexed_view_name , target )
[ WITH [ NO_INFOMSGS ] < option > [ , n ] ]  
< option > :: =  
    STAT_HEADER | DENSITY_VECTOR | HISTOGRAM | STATS_STREAM
DBCC SHOW_STATISTICS ( table_name , target )   
    [ WITH {STAT_HEADER | DENSITY_VECTOR | HISTOGRAM } [ ,...n ] ]  
[;]  


/* fiche d'identité
role = DBA
categorie = CON
type = SQL
basetype  = sqlserver
url = https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-show-statistics-transact-sql?view=sql-server-2017
etat = 0 */
