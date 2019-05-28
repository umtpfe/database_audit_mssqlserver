/* Max data length */

DECLARE cur cursor for select table_name, column_name, data_type, character_maximum_length 
						from INFORMATION_SCHEMA.COLUMNS
						WHERE data_type IN ('char', 'varchar')
					   ORDER BY character_maximum_length DESC
 DECLARE  @cn  sysname
 DECLARE  @tn  sysname
 DECLARE  @colonne  sysname
 DECLARE  @tab    sysname
 DECLARE  @datatype  nvarchar(max)
 DECLARE  @datalength  int
 DECLARE  @chaine nvarchar(max)
 DECLARE @nb int
 set @nb = 0
 PRINT 'Regle:Max data_length'
 open cur 
 FETCH next from cur into @tn, @cn, @datatype, @datalength
 WHILE @@fetch_status = 0 
 BEGIN
	 DECLARE cur2 cursor for select longueur from (select len(@cn) longueur, @cn FROM @tn ) a
	 open cur2
	 FETCH next from cur2 into @nb
	 while @@fetch_status = 0
	 BEGIN
		 PRINT 'table_name: '+@tn+' column_name: '+@cn+' data_type: '+@datatype+' data_length : '+@datalength+' Taille effective max: '+@nb
		 FETCH next from cur2 into @nb
	 END
	 close cur2
	 DEALLOCATE cur2
 END
close cur 
DEALLOCATE cur 

/* fiche d'identite
role = DBA
categorie = INF
type = Transact-SQL
basetype = sqlserver
url = NULL
etat = 1 */