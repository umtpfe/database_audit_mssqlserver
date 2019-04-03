DECLARE dync SCROLL CURSOR FOR SELECT
	TABLE_CATALOG,
	TABLE_SCHEMA,
	table_name,
	column_name
FROM
	INFORMATION_SCHEMA.COLUMNS DECLARE @db nvarchar(max) DECLARE @schem nvarchar(MAX) DECLARE @taable nvarchar(MAX) DECLARE @attribut nvarchar(MAX) DECLARE @prec nvarchar(MAX) DECLARE @chaine nvarchar(MAX) DECLARE @var nvarchar(5) DECLARE @var2 nvarchar(10) declare @fetch_outer_cursor int declare @fetch_inner_cursor int PRINT N'Regle: Les tables utilisateurs:' OPEN dync FETCH NEXT
FROM
	dync INTO
		@db,
		@schem,
		@taable,
		@attribut close dync SET
		@chaine = @db + '.' + @schem + '.' + @taable + '(' SELECT
			@var2 = is_nullable
		FROM
			INFORMATION_SCHEMA.COLUMNS
		WHERE
			column_name = @attribut
			AND TABLE_NAME = @taable IF @var2 = 'YES' SET
			@chaine = @chaine + '?' DECLARE colcon CURSOR FOR SELECT
				ao.type
			FROM
				sys.all_objects ao
			INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ic ON
				ic.CONSTRAINT_NAME = ao.name
			WHERE
				ic.column_name = @attribut
				AND ic.TABLE_NAME = @taable OPEN colcon FETCH NEXT
			FROM
				colcon into
					@var WHILE @@fetch_status = 0
				BEGIN
					IF @var = 'PK' SET
					@chaine = @chaine + '#' IF @var = 'F' SET
					@chaine = @chaine + '@' IF @var = 'C' SET
					@chaine = @chaine + '%' IF @var = 'UQ' SET
					@chaine = @chaine + '!' FETCH NEXT
				FROM
					colcon into
						@var
					END SET
					@chaine = @chaine + @attribut close colcon DEALLOCATE colcon open dync FETCH FIRST
				FROM
					dync INTO
						@db,
						@schem,
						@taable,
						@attribut SET
						@fetch_outer_cursor = @@fetch_status WHILE @fetch_outer_cursor = 0
					BEGIN
						SET
						@prec = @taable FETCH NEXT
					FROM
						dync INTO
							@db,
							@schem,
							@taable,
							@attribut SET
							@fetch_outer_cursor = @@fetch_status IF @@FETCH_STATUS <> 0
						BEGIN
							SET
							@chaine = @chaine + ')' PRINT @chaine
						END IF @taable = @prec
					BEGIN
						SET
						@chaine = @chaine + ', ' SELECT
							@var2 = is_nullable
						FROM
							INFORMATION_SCHEMA.COLUMNS
						WHERE
							column_name = @attribut
							AND TABLE_NAME = @taable IF @var2 = 'YES' SET
							@chaine = @chaine + '?' DECLARE colcon SCROLL CURSOR FOR SELECT
								ao.type
							FROM
								sys.all_objects ao
							INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ic ON
								ic.CONSTRAINT_NAME = ao.name
							WHERE
								ic.column_name = @attribut
								AND ic.TABLE_NAME = @taable OPEN colcon FETCH NEXT
							FROM
								colcon into
									@var SET
									@fetch_inner_cursor = @@fetch_status WHILE @fetch_inner_cursor = 0
								BEGIN
									IF @var = 'PK' SET
									@chaine = @chaine + '#' IF @var = 'F' SET
									@chaine = @chaine + '@' IF @var = 'C' SET
									@chaine = @chaine + '%' IF @var = 'UQ' SET
									@chaine = @chaine + '!' FETCH NEXT
								FROM
									colcon into
										@var SET
										@fetch_inner_cursor = @@fetch_status
									END SET
									@chaine = @chaine + @attribut close colcon DEALLOCATE colcon
								END
								ELSE
							BEGIN
								SET
								@chaine = @chaine + ')' PRINT @chaine SET
								@chaine = @db + '.' + @schem + '.' + @taable + '(' SELECT
									@var2 = is_nullable
								FROM
									INFORMATION_SCHEMA.COLUMNS
								WHERE
									column_name = @attribut
									AND TABLE_NAME = @taable IF @var2 = 'YES' SET
									@chaine = @chaine + '?' DECLARE colcon SCROLL CURSOR FOR SELECT
										ao.type
									FROM
										sys.all_objects ao
									INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ic ON
										ic.CONSTRAINT_NAME = ao.name
									WHERE
										ic.column_name = @attribut
										AND ic.TABLE_NAME = @taable OPEN colcon FETCH NEXT
									FROM
										colcon into
											@var SET
											@fetch_inner_cursor = @@fetch_status WHILE @fetch_inner_cursor = 0
										BEGIN
											IF @var = 'PK' SET
											@chaine = @chaine + '#' IF @var = 'F' SET
											@chaine = @chaine + '@' IF @var = 'C' SET
											@chaine = @chaine + '%' IF @var = 'UQ' SET
											@chaine = @chaine + '!' FETCH NEXT
										FROM
											colcon into
												@var SET
												@fetch_inner_cursor = @@fetch_status
											END close colcon DEALLOCATE colcon SET
											@chaine = @chaine + @attribut
										END
									END close dync DEALLOCATE dync
