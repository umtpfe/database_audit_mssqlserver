/* vérifier les statistiques sur les colonnes d'un utilisateur */

DECLARE @tabname nvarchar(20)
DECLARE tab CURSOR FOR SELECT name FROM sys.tables
OPEN tab 
FETCH NEXT FROM tab INTO @tabname
WHILE @@FETCH_STATUS = 0
BEGIN
	 DECLARE @colname nvarchar(20)
	 DECLARE col CURSOR FOR SELECT column_name 
				FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = @tabname
	 OPEN col
	 FETCH NEXT FROM col into @colname
	 WHILE @@FETCH_STATUS = 0
	   BEGIN
		   PRINT 'Nom de la colonne : '+@tabname+'.'+@colname
	 	   DBCC SHOW_STATISTICS (@tabname , @colname)
		   FETCH NEXT FROM col INTO @colname
	   END
	   CLOSE col 
	   DEALLOCATE col 
FETCH NEXT FROM tab INTO @tabname
END
CLOSE tab 
DEALLOCATE tab 	


/* fiche d'identité
role = DBA
categorie = CON
type = Transact-SQL
basetype  = sqlserver
url = http://courses.cs.tau.ac.il/databases/databases2012b/slides/moreinfo/SQL%20tuning.pdf
etat = 0 */
