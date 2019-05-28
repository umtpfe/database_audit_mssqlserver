/* Déterminations des 10 valeurs les plus utilisées pour chaque colonne d'une table par ordre décroissant */

DECLARE @tn NVARCHAR(MAX)
DECLARE @cn NVARCHAR(MAX)
DECLARE @colonne NVARCHAR(MAX)
DECLARE @chaine NVARCHAR(MAX)
DECLARE cur CURSOR FOR SELECT table_name, column_name FROM INFORMATION_SCHEMA.TABLES 
PRINT 'Les 10 premieres valeurs les plus utilisees pour les colonnes des tables:'
OPEN cur 
FETCH NEXT FROM cur INTO @tn, @cn
WHILE @@fetch_status = 0 
BEGIN
	set @chaine = 'SELECT TOP 10 '+@cn+' FROM ( SELECT '+@cn+' , COUNT (*) FROM '+@tn+' GROUP BY '+@cn+' ORDER BY 2 DESC) '
	DECLARE cur2 CURSOR FOR @chaine
	open cur2
	PRINT 'column_name: '+@cn+', '+'table_name: '+@tn;
	FETCH NEXT FROM cur INTO @colonne
	WHILE @@fetch_status = 0 
	BEGIN
		PRINT 'column_name:' +@colonne
		FETCH NEXT FROM cur INTO @colonne
	END
	CLOSE cur2
	DEALLOCATE cur2
	FETCH NEXT FROM cur INTO @tn, @cn
END
CLOSE cur 
DEALLOCATE cur 

/* fiche d'identite
role = DBA
categorie = INF
type = Transact-SQL
basetype = sqlserver
url = NULL
etat = 1 */