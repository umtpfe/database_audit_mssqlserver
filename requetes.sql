SELECT DISTINCT t.name, t.object_id 
    FROM sys.tables t
    INNER JOIN sys.columns c ON t.object_id = c.object_id
    WHERE c.object_id NOT IN (SELECT ck.parent_object_id
	FROM sys.key_constraints ck );
GO 

SELECT f.name 
    FROM sys.foreign_keys f 
    WHERE f.parent_object_id NOT IN ( SELECT  i.object_id FROM sys.indexes i )
	AND f.referenced_object_id NOT IN ( SELECT parent_object_id FROM sys.key_constraints);
GO

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

SELECT t.object_id, t.name 
    FROM sys.tables t
    INNER JOIN sys.dm_db_partition_stats p ON t.object_id = p.object_id 
    WHERE p.row_count = 0;
GO

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

SELECT DISTINCT f.name, f.object_id, f.parent_object_id 
    FROM sys.foreign_keys f
    INNER JOIN sys.indexes i ON f.key_index_id = i.index_id
    WHERE f.key_index_id IN ( SELECT i.index_id 
				   FROM sys.indexes i);
GO

SELECT object_id, create_date, modify_date,current_timestamp AS timestamp   
    FROM sys.all_objects
    WHERE [type]='U';
GO

SELECT t.object_id, t.name, p.row_count
    FROM sys.all_objects t
    INNER JOIN sys.dm_db_partition_stats p
        ON  t.object_id = p.object_id 
    GROUP BY t.object_id, t.name, p.row_count ORDER BY p.row_count ASC;
GO

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

SELECT o.object_id, o.name , s.name stat_name
    FROM sys.all_objects o
    INNER JOIN sys.stats s ON o.object_id = s.object_id
    WHERE o.object_id NOT IN ( SELECT object_id FROM sys.stats );
GO

SELECT t.object_id,t.schema_id ,t.name, p.row_count
    FROM sys.tables t
    INNER JOIN sys.dm_db_partition_stats p ON t.object_id = p.object_id
    WHERE p.row_count > 0 AND t.schema_id = <table_schema>;
GO

SELECT i.object_id, i.name, i.index_id, i.type 
    FROM sys.indexes i
    INNER JOIN sys.tables t on i.object_id = t.object_id
    WHERE  t.schema_id = <table_schema>
    ORDER BY i.object_id, i.name, i.index_id ;
GO

SELECT o.name, o.object_id, o.type, count(1) 
    FROM sys.all_objects o
    WHERE o.type='u' GROUP BY o.name, o.object_id, o.type ORDER BY o.type;
GO

SELECT i.object_id, i.name, i.index_id, i.type_desc, i.is_unique, i.is_primary_key 
    FROM sys.indexes i
    INNER JOIN sys.all_objects o ON i.object_id = o.object_id
    WHERE o.type_desc='user_table';
GO

SELECT i.object_id, id.name, i.index_id, i.index_column_id, i.column_id, i.key_ordinal  
   FROM sys.index_columns i , sys.indexes id 
   WHERE i.object_id = id.object_id;
GO

SELECT DISTINCT t.name
    FROM sys.partitions p
    INNER JOIN sys.tables t ON p.object_id = t.object_id
    WHERE p.partition_number <> 1;
GO

SELECT t.object_id, t.name 
    FROM sys.tables t 
    INNER JOIN sys.indexes i ON t.object_id = i.object_id
    WHERE t.object_id NOT IN ( SELECT object_id FROM sys.indexes );
GO

SELECT t.object_id, t.name 
    FROM sys.tables t
    INNER JOIN sys.indexes i ON t.object_id = i.object_id
    WHERE t.object_id IN ( SELECT object_id FROM sys.indexes );
GO

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
	 		SELECT 'la clé etrangere '+@fkname+' a ete desactivée'
  		END
 	FETCH NEXT FROM fk INTO @fkname
	END
CLOSE fk 
DEALLOCATE fk
GO

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
	 		SELECT 'la clé etrangere '+@fkname+' a ete activée'
  		END
        FETCH NEXT FROM fk INTO @fkname
	END
CLOSE fk 
DEALLOCATE fk 
GO

SELECT DISTINCT c.object_id 
    FROM sys.all_columns c 
    INNER JOIN sys.indexes i ON c.object_id = i.object_id
    WHERE i.type_desc = 'clustered';
GO

SELECT name, object_id, schema_id, parent_object_id, type
    FROM sys.tables
    WHERE [type]='u' AND schema_id = <table_schema>;
GO

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

SELECT name, object_id, parent_object_id, referenced_object_id
   FROM sys.foreign_keys
   WHERE referenced_object_id = object_id;
GO

SELECT DISTINCT i.TABLE_NAME, i.COLUMN_name, ic.TABLE_NAME, ic.COLUMN_name , ic.data_type
   FROM INFORMATION_SCHEMA.COLUMNS i,INFORMATION_SCHEMA.COLUMNS ic
   WHERE i.COLUMN_NAME = ic.COLUMN_NAME
   AND col_length('i.table_name', 'i.column_name') <> col_length('ic.table_name', 'ic.column_name') ;
GO

SELECT * FROM INFORMATION_SCHEMA.TABLES it, INFORMATION_SCHEMA.TABLES it1
WHERE it.TABLE_NAME = it1.TABLE_NAME 
AND it.TABLE_SCHEMA <> it1.TABLE_SCHEMA
GO