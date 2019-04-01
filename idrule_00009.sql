/* modele logique */

DECLARE dync CURSOR FOR SELECT TABLE_CATALOG,TABLE_SCHEMA,table_name,column_name FROM INFORMATION_SCHEMA.COLUMNS 
DECLARE @db nvarchar(max)
DECLARE @schem nvarchar(MAX)
DECLARE @taable nvarchar(MAX)
DECLARE @attribut nvarchar(MAX)
DECLARE @prec nvarchar(MAX)
DECLARE @chaine nvarchar(MAX)
DECLARE @var nvarchar(5)
DECLARE @var2 nvarchar(10)
PRINT N'Regle: Les tables utilisateurs:'
OPEN dync
FETCH NEXT FROM dync INTO @db, @schem, @taable, @attribut
SET @chaine = @db + '.' + @schem + '.' + @taable + '('
SELECT @var = is_nullable FROM INFORMATION_SCHEMA.COLUMNS 
WHERE column_name = @attribut AND TABLE_NAME = @taable 
IF @var = 'YES' 
	SET @chaine = @chaine +'?'
DECLARE  curcons cursor for SELECT ao.type 
			    FROM sys.all_objects ao 
			    INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ic 
 			    ON ic.CONSTRAINT_NAME = ao.name
 			    WHERE ic.column_name = @attribut AND ic.TABLE_NAME = @taable
 	OPEN curcons
 	FETCH next from curcons into @var2
 	WHILE @@fetch_status = 0
 	BEGIN
	 	IF @var2 = 'PK'
			SET @chaine = @chaine +'#'
		IF @var2 = 'F'
			SET @chaine = @chaine +'@'
		IF @var2 = 'UQ'
			SET @chaine = @chaine +'!'
		IF @var2 = 'C'
			SET @chaine = @chaine +'%'
	FETCH next from curcons into @var2
 	END
 	CLOSE curcons
 	DEALLOCATE curcons
close dync
SET @chaine = @chaine + @attribut
PRINT 'valeur de chaine '+@chaine

OPEN dync
FETCH NEXT FROM dync INTO @db, @schem, @taable, @attribut
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @prec = @taable
		FETCH NEXT FROM dync INTO @db, @schem, @taable, @attribut
		IF @@FETCH_STATUS != 0
		BEGIN
			SET @chaine = @chaine + ')'
			PRINT @chaine
		END
		IF @taable = @prec
		BEGIN
			SET @chaine = @chaine + ', '
			SELECT @var = is_nullable FROM INFORMATION_SCHEMA.COLUMNS 
 		 		WHERE column_name = @attribut AND TABLE_NAME = @taable 
 			IF @var = 'YES'
				SET @chaine = @chaine +'?'
			SELECT @var = ao.type FROM sys.all_objects ao 
 				INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ic 
 				ON ic.CONSTRAINT_NAME = ao.name
 				WHERE ic.column_name = @attribut AND ic.TABLE_NAME = @taable
 			IF @var = 'PK'
				SET @chaine = @chaine +'#'
			IF @var = 'F'
				SET @chaine = @chaine +'@'
			IF @var = 'UQ'
				SET @chaine = @chaine +'!'
			IF @var = 'C'
				SET @chaine = @chaine +'%'
			SET @chaine = @chaine + @attribut
		END
		ELSE
			BEGIN
				SET @chaine = @chaine + ')'
				PRINT @chaine
				SET @chaine = @db + '.' + @schem + '.' + @taable + '('
				SELECT @var = is_nullable FROM INFORMATION_SCHEMA.COLUMNS 
 		 		WHERE column_name = @attribut AND TABLE_NAME = @taable 
 				IF @var = 'YES'
					SET @chaine = @chaine +'?'
					SELECT @var = ao.type FROM sys.all_objects ao 
 						INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ic 
 						ON ic.CONSTRAINT_NAME = ao.name
 						WHERE ic.column_name = @attribut AND ic.TABLE_NAME = @taable
 				IF @var = 'PK'
					SET @chaine = @chaine +'#'
				IF @var = 'F'
					SET @chaine = @chaine +'@'
				IF @var = 'UQ'
					SET @chaine = @chaine +'!'
				IF @var = 'C'
					SET @chaine = @chaine +'%'
				SET @chaine = @chaine + @attribut
			END
	END
CLOSE dync
DEALLOCATE dync



/* fiche d'identité
role = DBA
categorie = CON
type = Transact-SQL
basetype  = sqlserver
url = NULL
etat = 1 */
