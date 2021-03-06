USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetAutoComplete_Diagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetAutoComplete_Diagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Diagnosis].[usp_GetAutoComplete_Diagnosis] 
	@ClinicID INT
	, @DescType NVARCHAR(15) = NULL
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
	
	DECLARE @ICD_FORMAT TINYINT;
		
	SELECT 
		@ICD_FORMAT = [Billing].[Clinic].[ICDFormat] 
	FROM
		[Billing].[Clinic]
	WHERE 
		[Billing].[Clinic].[ClinicID] = @ClinicID;
	
	IF @DescType = 'ShortDesc'		-- ShortDesc STARTS
	BEGIN
		IF LEN(@stats) = 0 -- Space
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 50
				([Diagnosis].[Diagnosis].[ShortDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			WHERE
				[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
			AND
				[Diagnosis].[Diagnosis].[ShortDesc] IS NOT NULL
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
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
				(ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			WHERE
				[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
			AND
				(ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN	-- look in code
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				(ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			WHERE
				[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
			AND
				CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN -- anywhere
				SELECT @stats = '%' + @stats;
				
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					([Diagnosis].[Diagnosis].[ShortDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
				FROM
					[Diagnosis].[Diagnosis]
				WHERE
					[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
				AND
					[Diagnosis].[Diagnosis].[ShortDesc] IS NOT NULL
				AND
					([Diagnosis].[Diagnosis].[ShortDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[Diagnosis].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
			
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN -- anywhere other group - medium
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 
						([Diagnosis].[Diagnosis].[MediumDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (M)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
					FROM
						[Diagnosis].[Diagnosis]
					WHERE
						[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
					AND
						[Diagnosis].[Diagnosis].[MediumDesc] IS NOT NULL
					AND
						([Diagnosis].[Diagnosis].[MediumDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (M)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
					AND
						[Diagnosis].[Diagnosis].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
			
					IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
					BEGIN	-- anywhere other group - Long
						INSERT INTO
							@TBL_ANS
						SELECT TOP 10 
							([Diagnosis].[Diagnosis].[LongDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (L)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
						FROM
							[Diagnosis].[Diagnosis]
						WHERE
							[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
						AND
							[Diagnosis].[Diagnosis].[LongDesc] IS NOT NULL
						AND
							([Diagnosis].[Diagnosis].[LongDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (L)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
						AND
							[Diagnosis].[Diagnosis].[IsActive] = 1
						ORDER BY 
							[NAME_CODE] 
						ASC;
			
						IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
						BEGIN	-- anywhere other group - Custom
							INSERT INTO
								@TBL_ANS
							SELECT TOP 10 
								([Diagnosis].[Diagnosis].[CustomDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (C)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
							FROM
								[Diagnosis].[Diagnosis]
							WHERE
								[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
							AND
								[Diagnosis].[Diagnosis].[CustomDesc] IS NOT NULL
							AND
								([Diagnosis].[Diagnosis].[CustomDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (C)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
							AND
								[Diagnosis].[Diagnosis].[IsActive] = 1
							ORDER BY 
								[NAME_CODE] 
							ASC;
						END
					END
				END
			END
		END
	END		-- ShortDesc ENDS
	ELSE IF @DescType = 'MediumDesc'		-- MediumDesc STARTS
	BEGIN
		IF LEN(@stats) = 0 -- Space
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 50
				([Diagnosis].[Diagnosis].[MediumDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			WHERE
				[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
			AND
				[Diagnosis].[Diagnosis].[MediumDesc] IS NOT NULL
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
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
				(ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			WHERE
				[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
			AND
				(ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN	-- look in code
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				(ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			WHERE
				[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
			AND
				CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN -- anywhere
				SELECT @stats = '%' + @stats;
				
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					([Diagnosis].[Diagnosis].[MediumDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
				FROM
					[Diagnosis].[Diagnosis]
				WHERE
					[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
				AND
					[Diagnosis].[Diagnosis].[MediumDesc] IS NOT NULL
				AND
					([Diagnosis].[Diagnosis].[MediumDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[Diagnosis].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
			
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN	-- anywhere other group - Long
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 
						([Diagnosis].[Diagnosis].[LongDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (L)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
					FROM
						[Diagnosis].[Diagnosis]
					WHERE
						[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
					AND
						[Diagnosis].[Diagnosis].[LongDesc] IS NOT NULL
					AND
						([Diagnosis].[Diagnosis].[LongDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (L)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
					AND
						[Diagnosis].[Diagnosis].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
		
					IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
					BEGIN	-- anywhere other group - Custom
						INSERT INTO
							@TBL_ANS
						SELECT TOP 10 
							([Diagnosis].[Diagnosis].[CustomDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (C)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
						FROM
							[Diagnosis].[Diagnosis]
						WHERE
							[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
						AND
							[Diagnosis].[Diagnosis].[CustomDesc] IS NOT NULL
						AND
							([Diagnosis].[Diagnosis].[CustomDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (C)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
						AND
							[Diagnosis].[Diagnosis].[IsActive] = 1
						ORDER BY 
							[NAME_CODE] 
						ASC;
						
						IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
						BEGIN -- anywhere other group - Short
							INSERT INTO
								@TBL_ANS
							SELECT TOP 10 
								([Diagnosis].[Diagnosis].[ShortDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (M)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
							FROM
								[Diagnosis].[Diagnosis]
							WHERE
								[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
							AND
								[Diagnosis].[Diagnosis].[ShortDesc] IS NOT NULL
							AND
								([Diagnosis].[Diagnosis].[ShortDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (M)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
							AND
								[Diagnosis].[Diagnosis].[IsActive] = 1
							ORDER BY 
								[NAME_CODE] 
							ASC;
						END
					END
				END
			END
		END
	END		-- MediumDesc ENDS
	ELSE IF @DescType = 'LongDesc'		-- LongDesc STARTS
	BEGIN
		IF LEN(@stats) = 0 -- Space
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 50
				([Diagnosis].[Diagnosis].[LongDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			WHERE
				[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
			AND
				[Diagnosis].[Diagnosis].[LongDesc] IS NOT NULL
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
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
				(ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			WHERE
				[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
			AND
				(ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN	-- look in code
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				(ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			WHERE
				[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
			AND
				CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN -- anywhere
				SELECT @stats = '%' + @stats;
				
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					([Diagnosis].[Diagnosis].[LongDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
				FROM
					[Diagnosis].[Diagnosis]
				WHERE
					[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
				AND
					[Diagnosis].[Diagnosis].[LongDesc] IS NOT NULL
				AND
					([Diagnosis].[Diagnosis].[LongDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[Diagnosis].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
		
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN	-- anywhere other group - Custom
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 
						([Diagnosis].[Diagnosis].[CustomDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (C)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
					FROM
						[Diagnosis].[Diagnosis]
					WHERE
						[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
					AND
						[Diagnosis].[Diagnosis].[CustomDesc] IS NOT NULL
					AND
						([Diagnosis].[Diagnosis].[CustomDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (C)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
					AND
						[Diagnosis].[Diagnosis].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
					
					IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
					BEGIN -- anywhere other group - Short
						INSERT INTO
							@TBL_ANS
						SELECT TOP 10 
							([Diagnosis].[Diagnosis].[ShortDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (M)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
						FROM
							[Diagnosis].[Diagnosis]
						WHERE
							[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
						AND
							[Diagnosis].[Diagnosis].[ShortDesc] IS NOT NULL
						AND
							([Diagnosis].[Diagnosis].[ShortDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (M)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
						AND
							[Diagnosis].[Diagnosis].[IsActive] = 1
						ORDER BY 
							[NAME_CODE] 
						ASC;
						
						IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
						BEGIN -- anywhere other group - medium
							INSERT INTO
								@TBL_ANS
							SELECT TOP 10 
								([Diagnosis].[Diagnosis].[MediumDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (M)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
							FROM
								[Diagnosis].[Diagnosis]
							WHERE
								[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
							AND
								[Diagnosis].[Diagnosis].[MediumDesc] IS NOT NULL
							AND
								([Diagnosis].[Diagnosis].[MediumDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (M)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
							AND
								[Diagnosis].[Diagnosis].[IsActive] = 1
							ORDER BY 
								[NAME_CODE] 
							ASC;
						END
					END
				END
			END
		END
	END		-- LongDesc ENDS
	ELSE IF @DescType = 'CustomDesc'		-- CustomDesc STARTS
	BEGIN
		IF LEN(@stats) = 0 -- Space
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 50
				([Diagnosis].[Diagnosis].[CustomDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			WHERE
				[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
			AND
				[Diagnosis].[Diagnosis].[CustomDesc] IS NOT NULL
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
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
				(ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			WHERE
				[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
			AND
				(ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN	-- look in code
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				(ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			WHERE
				[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
			AND
				CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN -- anywhere
				SELECT @stats = '%' + @stats;
				
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					([Diagnosis].[Diagnosis].[CustomDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
				FROM
					[Diagnosis].[Diagnosis]
				WHERE
					[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
				AND
					[Diagnosis].[Diagnosis].[CustomDesc] IS NOT NULL
				AND
					([Diagnosis].[Diagnosis].[CustomDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[Diagnosis].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
					
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN -- anywhere other group - Short
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 
						([Diagnosis].[Diagnosis].[ShortDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (S)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
					FROM
						[Diagnosis].[Diagnosis]
					WHERE
						[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
					AND
						[Diagnosis].[Diagnosis].[ShortDesc] IS NOT NULL
					AND
						([Diagnosis].[Diagnosis].[ShortDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (S)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
					AND
						[Diagnosis].[Diagnosis].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
					
					IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
					BEGIN -- anywhere other group - medium
						INSERT INTO
							@TBL_ANS
						SELECT TOP 10 
							([Diagnosis].[Diagnosis].[MediumDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (M)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
						FROM
							[Diagnosis].[Diagnosis]
						WHERE
							[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
						AND
							[Diagnosis].[Diagnosis].[MediumDesc] IS NOT NULL
						AND
							([Diagnosis].[Diagnosis].[MediumDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (M)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
						AND
							[Diagnosis].[Diagnosis].[IsActive] = 1
						ORDER BY 
							[NAME_CODE] 
						ASC;
						
						IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
						BEGIN	-- anywhere other group - Long
							INSERT INTO
								@TBL_ANS
							SELECT TOP 10 
								([Diagnosis].[Diagnosis].[LongDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (L)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
							FROM
								[Diagnosis].[Diagnosis]
							WHERE
								[Diagnosis].[Diagnosis].[ICDFormat] = @ICD_FORMAT
							AND
								[Diagnosis].[Diagnosis].[LongDesc] IS NOT NULL
							AND
								([Diagnosis].[Diagnosis].[LongDesc] + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' (L)' + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
							AND
								[Diagnosis].[Diagnosis].[IsActive] = 1
							ORDER BY 
								[NAME_CODE] 
							ASC;
						END
					END
				END
			END
		END
	END		-- CustomDesc ENDS
	
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Diagnosis].[usp_GetAutoComplete_Diagnosis] @ClinicID = 1, @stats = 'chronic'
	-- EXEC [Diagnosis].[usp_GetAutoComplete_Diagnosis] @ClinicID = 1, @stats = 'chronic air'
END
GO
