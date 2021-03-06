USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetAutoComplete_CPT]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetAutoComplete_CPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Diagnosis].[usp_GetAutoComplete_CPT] 
	 @DescType NVARCHAR(15) = NULL
	, @stats NVARCHAR (150) = NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE @TBL_ANS TABLE ([ID] INT NOT NULL IDENTITY (1, 1), [NAME_CODE] NVARCHAR(400) NOT NULL);
	
	IF (@DescType IS NULL) OR (NOT (@DescType = 'ShortDesc' OR @DescType = 'MediumDesc' OR @DescType = 'LongDesc' OR @DescType = 'CustomDesc'))
	BEGIN
		SELECT @DescType = 'ShortDesc';
	END
	
	IF @stats IS NULL
	BEGIN
		SELECT @stats = '';
	END
	ELSE
	BEGIN
		SELECT @stats = LTRIM(RTRIM(@stats));
	END
	
	IF @DescType = 'ShortDesc'		-- ShortDesc STARTS
	BEGIN
		IF LEN(@stats) = 0
		BEGIN	-- Space
			INSERT INTO
				@TBL_ANS
			SELECT TOP 50 
				(ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
			FROM
				[Diagnosis].[CPT]
			WHERE
				[Diagnosis].[CPT].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		ELSE
		BEGIN	-- user enter ky
			SELECT @stats = REPLACE(@stats, '[', '\[');
			SELECT @stats = @stats + '%';
			
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				(ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
			FROM
				[Diagnosis].[CPT]
			WHERE
				(ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[CPT].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN	-- look in code
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					(ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
				FROM
					[Diagnosis].[CPT]
				WHERE
					[Diagnosis].[CPT].[CPTCode] LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[CPT].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
			END
			
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN		-- anywhere
				SELECT @stats = '%' + @stats;
				
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					(ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
				FROM
					[Diagnosis].[CPT]
				WHERE
					(ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[CPT].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN		 -- anywhere other group - Medium
					SELECT @stats = '%' + @stats;
					
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 
						(ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
					FROM
						[Diagnosis].[CPT]
					WHERE
						(ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
					AND
						[Diagnosis].[CPT].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
					IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
					BEGIN		 -- anywhere other group - Long
						SELECT @stats = '%' + @stats;
						
						INSERT INTO
							@TBL_ANS
						SELECT TOP 10 
							(ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
						FROM
							[Diagnosis].[CPT]
						WHERE
							(ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
						AND
							[Diagnosis].[CPT].[IsActive] = 1
						ORDER BY 
							[NAME_CODE] 
						ASC;
						IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
						BEGIN		 -- anywhere other group - Custom
							SELECT @stats = '%' + @stats;
							
							INSERT INTO
								@TBL_ANS
							SELECT TOP 10 
								(ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
							FROM
								[Diagnosis].[CPT]
							WHERE
								(ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
							AND
								[Diagnosis].[CPT].[IsActive] = 1
							ORDER BY 
								[NAME_CODE] 
							ASC;
						END
					END
				END
			END
		END
	END	
	ELSE IF @DescType = 'MediumDesc'		-- MediumDesc STARTS
	BEGIN
		IF LEN(@stats) = 0
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 50 
				(ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
			FROM
				[Diagnosis].[CPT]
			WHERE
				[Diagnosis].[CPT].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		ELSE
		BEGIN
			SELECT @stats = REPLACE(@stats, '[', '\[');
			SELECT @stats = @stats + '%';
			
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				(ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
			FROM
				[Diagnosis].[CPT]
			WHERE
				(ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[CPT].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					(ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
				FROM
					[Diagnosis].[CPT]
				WHERE
					[Diagnosis].[CPT].[CPTCode] LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[CPT].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
			END
			
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN
				SELECT @stats = '%' + @stats;
				
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					(ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
				FROM
					[Diagnosis].[CPT]
				WHERE
					(ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[CPT].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
				
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN
					SELECT @stats = '%' + @stats;
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 
						(ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
					FROM
						[Diagnosis].[CPT]
					WHERE
						(ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
					AND
						[Diagnosis].[CPT].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
					
					IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
					BEGIN
						SELECT @stats = '%' + @stats;
						INSERT INTO
							@TBL_ANS
						SELECT TOP 10 
							(ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
						FROM
							[Diagnosis].[CPT]
						WHERE
							(ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
						AND
							[Diagnosis].[CPT].[IsActive] = 1
						ORDER BY 
							[NAME_CODE] 
						ASC;
						IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
						BEGIN
							SELECT @stats = '%' + @stats;
							INSERT INTO
								@TBL_ANS
							SELECT TOP 10 
								(ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
							FROM
								[Diagnosis].[CPT]
							WHERE
								(ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
							AND
								[Diagnosis].[CPT].[IsActive] = 1
							ORDER BY 
								[NAME_CODE] 
							ASC;
						END
					END
				END
			END
		END
	END	
	ELSE IF @DescType = 'LongDesc'		-- LongDesc STARTS
	BEGIN
		IF LEN(@stats) = 0
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 50 
				(ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
			FROM
				[Diagnosis].[CPT]
			WHERE
				[Diagnosis].[CPT].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		ELSE
		BEGIN
			SELECT @stats = REPLACE(@stats, '[', '\[');
			SELECT @stats = @stats + '%';
			
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				(ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
			FROM
				[Diagnosis].[CPT]
			WHERE
				(ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[CPT].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					(ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
				FROM
					[Diagnosis].[CPT]
				WHERE
					[Diagnosis].[CPT].[CPTCode] LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[CPT].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
			END
			
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN
				SELECT @stats = '%' + @stats;
				
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					(ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
				FROM
					[Diagnosis].[CPT]
				WHERE
					(ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[CPT].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
				
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN
					SELECT @stats = '%' + @stats;
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 
						(ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
					FROM
						[Diagnosis].[CPT]
					WHERE
						(ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
					AND
						[Diagnosis].[CPT].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
					
					IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
					BEGIN
						SELECT @stats = '%' + @stats;
						INSERT INTO
							@TBL_ANS
						SELECT TOP 10 
							(ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
						FROM
							[Diagnosis].[CPT]
						WHERE
							(ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
						AND
							[Diagnosis].[CPT].[IsActive] = 1
						ORDER BY 
							[NAME_CODE] 
						ASC;
						
						IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
						BEGIN
							SELECT @stats = '%' + @stats;
							INSERT INTO
								@TBL_ANS
							SELECT TOP 10 
								(ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
							FROM
								[Diagnosis].[CPT]
							WHERE
								(ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
							AND
								[Diagnosis].[CPT].[IsActive] = 1
							ORDER BY 
								[NAME_CODE] 
							ASC;
						END
					END
				END
			END
		END
	END	
	ELSE IF @DescType = 'CustomDesc'		-- CustomDesc STARTS
	BEGIN
		IF LEN(@stats) = 0
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 50 
				(ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
			FROM
				[Diagnosis].[CPT]
			WHERE
				[Diagnosis].[CPT].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		ELSE
		BEGIN
			SELECT @stats = REPLACE(@stats, '[', '\[');
			SELECT @stats = @stats + '%';
			
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				(ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
			FROM
				[Diagnosis].[CPT]
			WHERE
				(ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[CPT].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					(ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
				FROM
					[Diagnosis].[CPT]
				WHERE
					[Diagnosis].[CPT].[CPTCode] LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[CPT].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
			END
			
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN
				SELECT @stats = '%' + @stats;
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					(ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
				FROM
					[Diagnosis].[CPT]
				WHERE
					(ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[CPT].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN
					SELECT @stats = '%' + @stats;
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 
						(ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
					FROM
						[Diagnosis].[CPT]
					WHERE
						(ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
					AND
						[Diagnosis].[CPT].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
					
					IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
					BEGIN
						SELECT @stats = '%' + @stats;
						INSERT INTO
							@TBL_ANS
						SELECT TOP 10 
							(ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
						FROM
							[Diagnosis].[CPT]
						WHERE
							(ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
						AND
							[Diagnosis].[CPT].[IsActive] = 1
						ORDER BY 
							[NAME_CODE] 
						ASC;
						
						IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
						BEGIN
							SELECT @stats = '%' + @stats;
							INSERT INTO
								@TBL_ANS
							SELECT TOP 10 
								(ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']')AS [NAME_CODE] 
							FROM
								[Diagnosis].[CPT]
							WHERE
								(ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' +[Diagnosis].[CPT].[CPTCode] + ']') LIKE @stats ESCAPE '\'
							AND
								[Diagnosis].[CPT].[IsActive] = 1
							ORDER BY 
								[NAME_CODE] 
							ASC;
						END
					END
				END
			END
		END
	END	
	
	SELECT * FROM @TBL_ANS;
	-- EXEC [Diagnosis].[usp_GetAutoComplete_CPT] 
	-- EXEC [Diagnosis].[usp_GetAutoComplete_CPT] @DescType= 'MediumDesc'
	-- EXEC [Diagnosis].[usp_GetAutoComplete_CPT] @DescType= 'LongDesc'
	-- EXEC [Diagnosis].[usp_GetAutoComplete_CPT] @DescType= 'CustomDesc'
	
END
GO
