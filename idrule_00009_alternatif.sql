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


