PRINT 'id_rule = 1'+char(13)+'Titre = tables sans cle primaire'
SELECT DISTINCT t.name, t.object_id 
    FROM sys.tables t
    INNER JOIN sys.columns c ON t.object_id = c.object_id
    WHERE c.object_id NOT IN (SELECT ck.parent_object_id
	FROM sys.key_constraints ck );
GO 

PRINT char(13)+'id_rule = 2'+char(13)+'Titre = Cle etrangere sans index ne faisant pas partie de la cle primaire'
SELECT f.name 
    FROM sys.foreign_keys f 
    WHERE f.parent_object_id NOT IN ( SELECT  i.object_id FROM sys.indexes i )
	AND f.referenced_object_id NOT IN ( SELECT parent_object_id FROM sys.key_constraints);
GO

PRINT char(13)+'id_rule = 4'+char(13)+'Titre = toute la colonne a une valeur null  superieur à 50%'
DECLARE @tabname nvarchar(20)
DECLARE tab CURSOR FOR SELECT name FROM sys.tables
OPEN tab 
FETCH NEXT FROM tab INTO @tabname
WHILE @@FETCH_STATUS = 0
 BEGIN
	DECLARE @tb nvarchar(512) = @tabname;
	PRINT 'Nom de la table: '+@tabname
	DECLARE @sql nvarchar(max) = N'SELECT * FROM ' + @tb + ' WHERE 1 = 0';
	SELECT @sql += N' OR ' + QUOTENAME(name) + ' IS NULL'  FROM sys.columns
	WHERE [object_id] = OBJECT_ID(@tb);
  	EXEC sys.sp_executesql @sql;
	FETCH NEXT FROM tab INTO @tabname
 END
CLOSE tab 
DEALLOCATE tab
GO

PRINT char(13)+'id_rule = 6'+char(13)+'Titre = tout une colonne a la meme valeur'
DECLARE @tabname nvarchar(20)
DECLARE tab CURSOR FOR SELECT name FROM sys.tables
OPEN tab 
FETCH NEXT FROM tab INTO @tabname
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @colname nvarchar(20)
	DECLARE col CURSOR FOR SELECT column_name 
							FROM INFORMATION_SCHEMA.COLUMNS 
							WHERE table_name = @tabname
	OPEN col
	FETCH NEXT FROM col INTO @colname
	WHILE @@FETCH_STATUS = 0
	    BEGIN
		   DECLARE @sql nvarchar(max)
		   PRINT 'Nom de la colonne : '+@tabname+'.'+@colname
		   SET @sql = 'SELECT COUNT ( DISTINCT '+@colname+' ) nbr_valeur FROM '+@tabname+';'
	 	   EXEC sp_executeSQL @sql
		   FETCH NEXT FROM col INTO @colname
	    END
	CLOSE col 
	DEALLOCATE col 
FETCH NEXT FROM tab INTO @tabname
END
CLOSE tab 
DEALLOCATE tab 
GO

PRINT char(13)+'id_rule = 7'+char(13)+'Titre = toute la colonne a une valeur null'
DECLARE @tabname nvarchar(20)
DECLARE tab CURSOR FOR SELECT name FROM sys.tables
OPEN tab 
FETCH NEXT FROM tab INTO @tabname
WHILE @@FETCH_STATUS = 0
 BEGIN
	DECLARE @tb nvarchar(512) = @tabname;
	PRINT 'Nom de la table: '+@tabname
	DECLARE @sql nvarchar(max) = N'SELECT * FROM ' + @tb + ' WHERE 1 = 0';
	SELECT @sql += N' OR ' + QUOTENAME(name) + ' IS NULL'  FROM sys.columns
	WHERE [object_id] = OBJECT_ID(@tb);
  	EXEC sys.sp_executesql @sql;
	FETCH NEXT FROM tab INTO @tabname
 END
CLOSE tab 
DEALLOCATE tab
GO

PRINT char(13)+'id_rule = 8'+char(13)+'Titre = table vide'
SELECT t.object_id, t.name 
    FROM sys.tables t
    INNER JOIN sys.dm_db_partition_stats p ON t.object_id = p.object_id 
    WHERE p.row_count = 0;
GO

PRINT char(13)+'id_rule = 9'+char(13)+'Titre = modele logique'
DECLARE dync SCROLL CURSOR FOR SELECT TABLE_CATALOG,TABLE_SCHEMA,table_name,column_name FROM INFORMATION_SCHEMA.COLUMNS 
DECLARE @db nvarchar(max)
DECLARE @schem nvarchar(MAX)
DECLARE @taable nvarchar(MAX)
DECLARE @attribut nvarchar(MAX)
DECLARE @prec nvarchar(MAX)
DECLARE @chaine nvarchar(MAX)
DECLARE @var nvarchar(5)
DECLARE @fetch_outer_cursor int
DECLARE @fetch_inner_cursor int
PRINT N'Regle: Les tables utilisateurs:'
OPEN dync
FETCH NEXT FROM dync INTO @db, @schem, @taable, @attribut
CLOSE dync
SET @chaine = @db + '.' + @schem + '.' + @taable + '('
	DECLARE colcon CURSOR FOR SELECT ao.type FROM sys.all_objects ao 
							INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ic 
 							ON ic.CONSTRAINT_NAME = ao.name
 							WHERE ic.column_name = @attribut AND ic.TABLE_NAME = @taable
	OPEN colcon
	FETCH NEXT FROM colcon INTO @var
	WHILE @@fetch_status = 0 
		BEGIN
			IF @var = 'PK'
				SET @chaine = @chaine +'#'
			IF @var = 'F'
				SET @chaine = @chaine +'@'
			FETCH NEXT FROM colcon INTO @var
		END
	SET @chaine = @chaine + @attribut
	CLOSE colcon
	DEALLOCATE colcon 
OPEN dync
FETCH FIRST FROM dync INTO @db, @schem, @taable, @attribut
SET @fetch_outer_cursor =  @@fetch_status
WHILE @fetch_outer_cursor = 0
BEGIN
	SET @prec = @taable
	FETCH NEXT FROM dync INTO @db, @schem, @taable, @attribut
	SET @fetch_outer_cursor =  @@fetch_status
	IF @@FETCH_STATUS <> 0
		BEGIN
			SET @chaine = @chaine + ')'
			PRINT @chaine
		END
	IF @taable = @prec
	BEGIN
		SET @chaine = @chaine + ', '
		DECLARE colcon SCROLL CURSOR FOR SELECT ao.type FROM sys.all_objects ao 
							INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ic 
 							ON ic.CONSTRAINT_NAME = ao.name
 							WHERE ic.column_name = @attribut AND ic.TABLE_NAME = @taable
		OPEN colcon
		FETCH NEXT FROM colcon INTO @var
		SET @fetch_inner_cursor = @@fetch_status
		WHILE @fetch_inner_cursor = 0 
			BEGIN
	 			IF @var = 'PK'
					SET @chaine = @chaine +'#'
				IF @var = 'F'
					SET @chaine = @chaine +'@'
				FETCH NEXT FROM colcon INTO @var
				SET @fetch_inner_cursor = @@fetch_status
			END
		SET @chaine = @chaine + @attribut
		CLOSE colcon
		DEALLOCATE colcon
	END
	ELSE
		BEGIN
			SET @chaine = @chaine + ')'
			PRINT @chaine
			SET @chaine = @db + '.' + @schem + '.' + @taable + '('
			DECLARE colcon SCROLL CURSOR FOR SELECT ao.type FROM sys.all_objects ao 
							INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ic 
 							ON ic.CONSTRAINT_NAME = ao.name
 							WHERE ic.column_name = @attribut AND ic.TABLE_NAME = @taable
			OPEN colcon
			FETCH NEXT FROM colcon INTO @var
			SET @fetch_inner_cursor = @@fetch_status
			WHILE @fetch_inner_cursor = 0 
			BEGIN
	 			IF @var = 'PK'
					SET @chaine = @chaine +'#'
				IF @var = 'F'
					SET @chaine = @chaine +'@'
				FETCH NEXT FROM colcon INTO @var
				SET @fetch_inner_cursor = @@fetch_status
			END
			CLOSE colcon
			DEALLOCATE colcon
			SET @chaine = @chaine + @attribut
		END
END
CLOSE dync
DEALLOCATE dync
GO

PRINT char(13)+'id_rule = 47'+char(13)+'Titre = Affichage des informations des objets stockes'
SELECT name, type
    FROM dbo.sysobjects
    WHERE type IN (
    'P', -- stored procedures
    'FN', -- scalar functions 
    'IF', -- inline table-valued functions
    'TF' -- table-valued functions
	)
    ORDER BY type, name;
GO

PRINT char(13)+'id_rule = 52'+char(13)+'Titre = trouver les tables non indexees et les colonnes de contraintes dans la  base'
SELECT t.name nom , t.object_id 
    FROM sys.tables t 
    INNER JOIN sys.indexes i ON t.object_id = i.object_id
    WHERE t.object_id NOT IN ( SELECT i.object_id
								FROM sys.indexes i)
 UNION ALL
 SELECT c.name nom , c.object_id 
    FROM sys.all_columns c
    WHERE c.object_id IN ( SELECT ck.parent_object_id 
				FROM sys.check_constraints ck UNION
			   SELECT k.parent_object_id 
				FROM sys.key_constraints k  UNION
			   SELECT f.parent_object_id 
				FROM sys.foreign_keys f );
GO


PRINT char(13)+'id_rule = 53'+char(13)+'Titre = cle etrangere sans index'
SELECT DISTINCT f.name, f.object_id, f.parent_object_id 
    FROM sys.foreign_keys f
    INNER JOIN sys.indexes i ON f.key_index_id = i.index_id
    WHERE f.key_index_id IN ( SELECT i.index_id 
				   FROM sys.indexes i);
GO

PRINT char(13)+'id_rule = 127'+char(13)+'Titre = objets avec leurs details des dernieres modifications'
SELECT object_id, create_date, modify_date,current_timestamp AS timestamp   
    FROM sys.all_objects
    WHERE [type]='U';
GO

PRINT char(13)+'id_rule = 128'+char(13)+'Titre = table avec leurs  nombres de lignes'
SELECT t.object_id, t.name, p.row_count
    FROM sys.all_objects t
    INNER JOIN sys.dm_db_partition_stats p
        ON  t.object_id = p.object_id 
    GROUP BY t.object_id, t.name, p.row_count ORDER BY p.row_count ASC;
GO

PRINT char(13)+'id_rule = 139'+char(13)+'Titre = vérifier les statistiques sur les colonnes d\'un utilisateur'
DECLARE @tabname nvarchar(20)
DECLARE tab CURSOR FOR SELECT name FROM sys.tables
OPEN tab 
FETCH NEXT FROM tab INTO @tabname
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @colname nvarchar(20)
	DECLARE col CURSOR FOR SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = @tabname
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
GO

PRINT char(13)+'id_rule = 140'+char(13)+'Titre = statistique sur les indexes des utilisateurs'
DECLARE @indname nvarchar(100)
DECLARE ind CURSOR FOR SELECT i.name
						FROM sys.indexes i INNER JOIN sys.tables t ON i.object_id = t.object_id
						WHERE i.name IS NOT NULL 
OPEN ind
FETCH NEXT FROM ind INTO @indname
WHILE @@FETCH_STATUS = 0
BEGIN
 	DECLARE @tabname nvarchar(20)
	DECLARE tab CURSOR FOR SELECT t.name
							FROM sys.tables t INNER JOIN sys.indexes i ON i.object_id = t.object_id 
							WHERE i.name = @indname
	OPEN tab 
	FETCH NEXT FROM tab INTO @tabname
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Nom index : '+@indname
		DBCC SHOW_STATISTICS (@tabname , @indname)
	 	FETCH NEXT FROM tab INTO @tabname 
	END
	CLOSE tab 
	DEALLOCATE tab  
FETCH NEXT FROM ind INTO @indname
END
CLOSE ind 
DEALLOCATE ind
GO

PRINT char(13)+'id_rule = 171'+char(13)+'Titre = rapport sur les objets qui n\'ont pas de statistique'
SELECT o.object_id, o.name , s.name stat_name
    FROM sys.all_objects o
    INNER JOIN sys.stats s ON o.object_id = s.object_id
    WHERE o.object_id NOT IN ( SELECT object_id FROM sys.stats );
GO

PRINT char(13)+'id_rule = 213'+char(13)+'Titre = affichage le nombre de lignes pour chaque table qui a ete analyser d\'un proprietaire donnee'
SELECT t.object_id,t.schema_id ,t.name, p.row_count
    FROM sys.tables t
    INNER JOIN sys.dm_db_partition_stats p ON t.object_id = p.object_id
    WHERE p.row_count > 0 AND t.schema_id = <table_schema>;
GO

PRINT char(13)+'id_rule = 216'+char(13)+'Titre = afficher tous les indexes existants pour un proprietaire '
SELECT i.object_id, i.name, i.index_id, i.type 
    FROM sys.indexes i
    INNER JOIN sys.tables t on i.object_id = t.object_id
    WHERE  t.schema_id = <table_schema>
    ORDER BY i.object_id, i.name, i.index_id ;
GO

PRINT char(13)+'id_rule = 279'+char(13)+'Titre = informations sur les objets d`\'un utilisateur'
SELECT o.name, o.object_id, o.type, count(1) 
    FROM sys.all_objects o
    WHERE o.type='u' GROUP BY o.name, o.object_id, o.type ORDER BY o.type;
GO

PRINT char(13)+'id_rule = 280'+char(13)+'Titre = informations sur les indexes'
SELECT i.object_id, i.name, i.index_id, i.type_desc, i.is_unique, i.is_primary_key 
    FROM sys.indexes i
    INNER JOIN sys.all_objects o ON i.object_id = o.object_id
    WHERE o.type_desc='user_table';
GO

PRINT char(13)+'id_rule = 316'+char(13)+'Titre = lister les colonnes indexees'
SELECT i.object_id, id.name, i.index_id, i.index_column_id, i.column_id, i.key_ordinal  
   FROM sys.index_columns i , sys.indexes id 
   WHERE i.object_id = id.object_id;
GO

PRINT char(13)+'id_rule = 569'+char(13)+'Titre = liste de toutes les tables partitionnees de la base'
SELECT DISTINCT t.name
    FROM sys.partitions p
    INNER JOIN sys.tables t ON p.object_id = t.object_id
    WHERE p.partition_number <> 1;
GO

PRINT char(13)+'id_rule = 571'+char(13)+'Titre = liste des tables non indexees de la base'
SELECT t.object_id, t.name 
    FROM sys.tables t 
    INNER JOIN sys.indexes i ON t.object_id = i.object_id
    WHERE t.object_id NOT IN ( SELECT object_id FROM sys.indexes );
GO

PRINT char(13)+'id_rule = 572'+char(13)+'Titre = liste des tables sur indexees de la base'
SELECT t.object_id, t.name 
    FROM sys.tables t
    INNER JOIN sys.indexes i ON t.object_id = i.object_id
    WHERE t.object_id IN ( SELECT object_id FROM sys.indexes );
GO

PRINT char(13)+'id_rule = 577'+char(13)+'Titre = Desactive les cles etrangères d\'un utilisateur'
DECLARE @fkname nvarchar(100)
DECLARE fk CURSOR FOR  SELECT name FROM sys.foreign_keys
OPEN fk 
FETCH NEXT FROM fk INTO @fkname
WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @tabname nvarchar(20)
	 	SELECT @tabname = t.name 
	 	FROM sys.tables t 
	  	WHERE t.object_id = (SELECT parent_object_id FROM sys.foreign_keys WHERE name = @fkname)
  		BEGIN
			DECLARE @sql nvarchar(MAX)
	 		SET @sql = 'ALTER TABLE '+@tabname+' NOCHECK CONSTRAINT '+@fkname+';'
	 		EXEC sp_executeSQL @sql 
	 		SELECT 'la cle etrangere '+@fkname+' a ete desactivee'
  		END
 	FETCH NEXT FROM fk INTO @fkname
	END
CLOSE fk 
DEALLOCATE fk
GO

PRINT char(13)+'id_rule = 578'+char(13)+'Titre = Active les cles etrangeres d\'un utilisateur'
DECLARE @fkname nvarchar(100)
DECLARE fk CURSOR FOR  SELECT name FROM sys.foreign_keys
OPEN fk 
FETCH NEXT FROM fk INTO @fkname
WHILE @@FETCH_STATUS = 0
	BEGIN
	DECLARE @tabname nvarchar(100)
	SELECT @tabname = t.name 
	FROM sys.tables t 
	WHERE t.object_id = (SELECT parent_object_id FROM sys.foreign_keys WHERE name = @fkname)
  		BEGIN
			DECLARE @sql nvarchar(MAX)
	 		SET @sql = 'ALTER TABLE '+@tabname+' CHECK CONSTRAINT '+@fkname+';'
	 		EXEC sp_executeSQL @sql 
	 		SELECT 'la cle etrangere '+@fkname+' a ete activee'
  		END
        FETCH NEXT FROM fk INTO @fkname
	END
CLOSE fk 
DEALLOCATE fk 
GO

PRINT char(13)+'id_rule = 580'+char(13)+'Titre = objets de type clustered de la base'
SELECT DISTINCT c.object_id 
    FROM sys.all_columns c 
    INNER JOIN sys.indexes i ON c.object_id = i.object_id
    WHERE i.type_desc = 'clustered';
GO

PRINT char(13)+'id_rule = 630'+char(13)+'Titre = details sur les tables d\'un propriétaire donnee'
SELECT name, object_id, schema_id, parent_object_id, type
    FROM sys.tables
    WHERE [type]='u' AND schema_id = <table_schema>;
GO

PRINT char(13)+'id_rule = 763'+char(13)+'Titre = statistique sur les indexes'
DECLARE @indname nvarchar(100)
DECLARE ind CURSOR FOR SELECT i.name
						FROM sys.indexes i INNER JOIN sys.tables t ON i.object_id = t.object_id
						WHERE i.name IS NOT NULL 
OPEN ind
FETCH NEXT FROM ind INTO @indname
WHILE @@FETCH_STATUS = 0
BEGIN
 	DECLARE @tabname nvarchar(20)
	DECLARE tab CURSOR FOR SELECT t.name
							FROM sys.tables t INNER JOIN sys.indexes i ON i.object_id = t.object_id 
							WHERE i.name = @indname
	OPEN tab 
	FETCH NEXT FROM tab INTO @tabname
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Nom index : '+@indname
		DBCC SHOW_STATISTICS (@tabname , @indname)
	 	FETCH NEXT FROM tab INTO @tabname 
	END
	CLOSE tab 
	DEALLOCATE tab  
FETCH NEXT FROM ind INTO @indname
END
CLOSE ind 
DEALLOCATE ind
GO

PRINT char(13)+'id_rule = 869'+char(13)+'Titre = nombre total de ligne de la base'
SELECT sum(row_count) nbr_ligne_total 
    FROM sys.dm_db_partition_stats;
GO

PRINT char(13)+'id_rule = 927'+char(13)+'Titre = Determination des indexes invalides pour un proprietaire'
SELECT sys.objects.name AS table_name, sys.indexes.name AS index_name
    FROM sys.indexes
    INNER JOIN sys.objects ON sys.objects.object_id = sys.indexes.object_id
   WHERE sys.indexes.is_disabled = 1
   ORDER BY sys.objects.name, sys.indexes.name;
GO

PRINT char(13)+'id_rule = 1024'+char(13)+'Titre = Informations sur les tables actives qui sont deverouillees'
SELECT  
    object_name(p.object_id) AS TableName, 
    resource_type, resource_description
   FROM
    sys.dm_tran_locks l
    JOIN sys.partitions p ON l.resource_associated_entity_id = p.hobt_id;
GO

PRINT char(13)+'id_rule = 1025'+char(13)+'Titre = statistique sur les tables des utilisateurs'
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
GO

PRINT char(13)+'id_rule = 1027'+char(13)+'Titre = tables sans cle etrangere'
SELECT DISTINCT t.name, t.object_id 
    FROM sys.tables t 
     INNER JOIN sys.columns c ON t.object_id = c.object_id
    WHERE c.object_id NOT IN ( SELECT f.parent_object_id
				   FROM sys.foreign_keys f );
GO

PRINT char(13)+'id_rule = 1029'+char(13)+'Titre = colonne d\'une cle composite qui n\'est pas une cle primaire dans d\'autres tables'
SELECT SCHEMA_NAME(o.schema_id) AS 'Schema' 
 , OBJECT_NAME(i2.object_id) AS 'TableName'
 , STUFF( (SELECT ',' + COL_NAME(ic.object_id,ic.column_ID) 
              FROM sys.indexes i1
               INNER JOIN sys.index_columns ic ON i1.object_id = ic.object_id AND i1.index_id = ic.index_id
           WHERE i1.is_primary_key = 1
           AND i1.object_id = i2.object_id AND i1.index_id = i2.index_id
  FOR XML PATH('')),1,1,'') AS PK
  FROM sys.indexes i2
  INNER JOIN sys.objects o ON i2.object_id = o.object_id
  WHERE i2.is_primary_key = 1
  AND o.type_desc = 'USER_TABLE';
GO

PRINT char(13)+'id_rule = 1037'+char(13)+'Titre = Details concernant  les  colonnes  des cles primaires indexees'
SELECT DISTINCT i.TABLE_NAME,   i.CONSTRAINT_NAME, id.index_id,  id.index_column_id 
     FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE i 
      INNER JOIN sys.index_columns id ON i.ordinal_position = id.column_id
     WHERE i.CONSTRAINT_NAME IN ( SELECT name 
				     FROM sys.key_constraints);
GO

PRINT char(13)+'id_rule = 1041'+char(13)+'Titre = Resultat sur les Intersection des indexes(2 indexes ou plus sur même colonne)'
SELECT a.object_id, a.index_id, a.index_column_id, a.column_id, 
		b.index_id, b.index_column_id, b.column_id 
    FROM sys.index_columns a, sys.index_columns b
    WHERE a.object_id = b.object_id
     AND a.index_id = b.index_id
     AND a.index_column_id < b.index_column_id ORDER BY 3;
GO

PRINT char(13)+²'id_rule = 1042'+char(13)+'Titre = Liste des cles etrangeres qui ne sont pas nommees comme les cles primaires'
SELECT c.name 
     FROM sys.all_columns c 
     WHERE c.object_id IN ( SELECT parent_object_id
			       FROM sys.foreign_keys)
     AND c.name NOT IN ( SELECT name 
  			    FROM sys.all_columns
			    WHERE object_id IN ( SELECT parent_object_id
			                           FROM sys.key_constraints 
						   WHERE type='PK' ) );
GO

PRINT char(13)+'id_rule = 1043'+char(13)+'Titre = type de cle etrangere different de cle primaire'
SELECT isc.table_name nom_table_referée , isc.column_name, isc.data_type, isc1.table_name nom_table_origin, isc1.column_name, isc1.data_type  
    FROM INFORMATION_SCHEMA.COLUMNS isc, INFORMATION_SCHEMA.COLUMNS isc1, INFORMATION_SCHEMA.TABLE_CONSTRAINTS istc, sys.foreign_keys fk
    WHERE isc.TABLE_NAME <> isc1.TABLE_NAME
     AND isc.COLUMN_NAME = isc1.COLUMN_NAME
     AND isc.TABLE_NAME = istc.TABLE_NAME
     AND istc.CONSTRAINT_name = fk.name
     AND isc.DATA_TYPE <> isc1.DATA_TYPE ;
GO

PRINT char(13)+'id_rule = 1047'+char(13)+'Titre = Nom de colonnes identiques et de types differents dans differentes tables'
SELECT DISTINCT i.TABLE_NAME, i.COLUMN_name , i.data_type, ic.TABLE_NAME, ic.COLUMN_name , ic.data_type 
    FROM INFORMATION_SCHEMA.COLUMNS i,INFORMATION_SCHEMA.COLUMNS ic
   WHERE i.COLUMN_NAME = ic.COLUMN_NAME
    AND i.DATA_TYPE <> ic.DATA_TYPE;
GO

PRINT char(13)+'id_rule = 1048'+char(13)+'Titre = Nom de colonnes identiques et de taille differents dans differentes tables'
SELECT DISTINCT i.TABLE_NAME, i.COLUMN_name, ic.TABLE_NAME, ic.COLUMN_name , ic.data_type
   FROM INFORMATION_SCHEMA.COLUMNS i,INFORMATION_SCHEMA.COLUMNS ic
   WHERE i.COLUMN_NAME = ic.COLUMN_NAME
   AND col_length('i.table_name', 'i.column_name') <> col_length('ic.table_name', 'ic.column_name') ;
GO

PRINT char(13)+'id_rule = 1054'+char(13)+'Titre = cle etrangere reflexive '
SELECT name, object_id, parent_object_id, referenced_object_id
   FROM sys.foreign_keys
   WHERE referenced_object_id = object_id;
GO

PRINT char(13)+'id_rule = 2001'+char(13)+'Titre = tables ayant le meme nom dans des schemas differents'
SELECT * FROM INFORMATION_SCHEMA.TABLES it, INFORMATION_SCHEMA.TABLES it1
WHERE it.TABLE_NAME = it1.TABLE_NAME 
AND it.TABLE_SCHEMA <> it1.TABLE_SCHEMA
GO

PRINT char(13)+'id_rule = 2002'+char(13)+'Titre = liste des bases et schemas par serveur'
DECLARE @sql nvarchar(max);
SET @sql = N'SELECT CAST(''master'' AS sysname) AS db_name, name schema_name, schema_id, CAST(1 AS int) AS database_id FROM master.sys.schemas ';
SELECT @sql = @sql + N' UNION ALL SELECT ' + quotename(name,'''')+ N', name schema_name, schema_id, ' + CAST(database_id AS nvarchar(10)) + N' FROM ' + quotename(name) + N'.sys.schemas'
FROM sys.databases WHERE database_id > 1
AND state = 0
AND user_access = 0;
EXEC sp_executesql @sql;
GO
