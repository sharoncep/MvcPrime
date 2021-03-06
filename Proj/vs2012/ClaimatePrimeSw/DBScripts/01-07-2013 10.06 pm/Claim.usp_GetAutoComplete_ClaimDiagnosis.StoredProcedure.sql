USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetAutoComplete_ClaimDiagnosis]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetAutoComplete_ClaimDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetAutoComplete_ClaimDiagnosis] 
	@PatientVisitID BIGINT
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
	
	IF @DescType = 'ShortDesc'		-- ShortDesc STARTS
	BEGIN
		IF LEN(@stats) = 0
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 50 
				(ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			INNER JOIN
				[Claim].[ClaimDiagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
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
				(ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			INNER JOIN
				[Claim].[ClaimDiagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				(ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				(ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			INNER JOIN
				[Claim].[ClaimDiagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					(ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
				FROM
					[Diagnosis].[Diagnosis]
				LEFT JOIN
					[Diagnosis].[DiagnosisGroup]
				ON
					[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
				AND
					[Diagnosis].[DiagnosisGroup].[IsActive] = 1
				INNER JOIN
					[Claim].[ClaimDiagnosis]
				ON
					[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
				WHERE
					[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
				AND
					[Diagnosis].[Diagnosis].[DiagnosisCode] LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[Diagnosis].[IsActive] = 1
				AND
					[Claim].[ClaimDiagnosis].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
				
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 
						(ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
					FROM
						[Diagnosis].[Diagnosis]
					LEFT JOIN
						[Diagnosis].[DiagnosisGroup]
					ON
						[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
					AND
						[Diagnosis].[DiagnosisGroup].[IsActive] = 1
					INNER JOIN
						[Claim].[ClaimDiagnosis]
					ON
						[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
					WHERE
						[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
					AND
						ISNULL('DG' + [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] , '*NO DG CODE*') LIKE @stats ESCAPE '\'
					AND
						[Diagnosis].[Diagnosis].[IsActive] = 1
					AND
						[Claim].[ClaimDiagnosis].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
			
					IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
					BEGIN
						SELECT @stats = '%' + @stats;
						
						INSERT INTO
							@TBL_ANS
						SELECT TOP 10 
							(ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
						FROM
							[Diagnosis].[Diagnosis]
						LEFT JOIN
							[Diagnosis].[DiagnosisGroup]
						ON
							[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
						AND
							[Diagnosis].[DiagnosisGroup].[IsActive] = 1
						INNER JOIN
							[Claim].[ClaimDiagnosis]
						ON
							[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
						WHERE
							[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
						AND
							(ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
						AND
							[Diagnosis].[Diagnosis].[IsActive] = 1
						AND
							[Claim].[ClaimDiagnosis].[IsActive] = 1
						ORDER BY 
							[NAME_CODE] 
						ASC;
					END
				END
			END
		END
	END		-- ShortDesc ENDS
	ELSE IF @DescType = 'MediumDesc'		-- MediumDesc STARTS
	BEGIN
		IF LEN(@stats) = 0
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 50 
				(ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			INNER JOIN
				[Claim].[ClaimDiagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
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
				(ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			INNER JOIN
				[Claim].[ClaimDiagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				(ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				(ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			INNER JOIN
				[Claim].[ClaimDiagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					(ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
				FROM
					[Diagnosis].[Diagnosis]
				LEFT JOIN
					[Diagnosis].[DiagnosisGroup]
				ON
					[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
				AND
					[Diagnosis].[DiagnosisGroup].[IsActive] = 1
				INNER JOIN
					[Claim].[ClaimDiagnosis]
				ON
					[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
				WHERE
					[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
				AND
					[Diagnosis].[Diagnosis].[DiagnosisCode] LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[Diagnosis].[IsActive] = 1
				AND
					[Claim].[ClaimDiagnosis].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
				
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 
						(ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
					FROM
						[Diagnosis].[Diagnosis]
					LEFT JOIN
						[Diagnosis].[DiagnosisGroup]
					ON
						[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
					AND
						[Diagnosis].[DiagnosisGroup].[IsActive] = 1
					INNER JOIN
						[Claim].[ClaimDiagnosis]
					ON
						[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
					WHERE
						[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
					AND
						ISNULL('DG' + [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] , '*NO DG CODE*') LIKE @stats ESCAPE '\'
					AND
						[Diagnosis].[Diagnosis].[IsActive] = 1
					AND
						[Claim].[ClaimDiagnosis].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
			
					IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
					BEGIN
						SELECT @stats = '%' + @stats;
						
						INSERT INTO
							@TBL_ANS
						SELECT TOP 10 
							(ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
						FROM
							[Diagnosis].[Diagnosis]
						LEFT JOIN
							[Diagnosis].[DiagnosisGroup]
						ON
							[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
						AND
							[Diagnosis].[DiagnosisGroup].[IsActive] = 1
						INNER JOIN
							[Claim].[ClaimDiagnosis]
						ON
							[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
						WHERE
							[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
						AND
							(ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
						AND
							[Diagnosis].[Diagnosis].[IsActive] = 1
						AND
							[Claim].[ClaimDiagnosis].[IsActive] = 1
						ORDER BY 
							[NAME_CODE] 
						ASC;
					END
				END
			END
		END
	END		-- MediumDesc ENDS
	ELSE IF @DescType = 'LongDesc'		-- LongDesc STARTS
	BEGIN
		IF LEN(@stats) = 0
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 50 
				(ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			INNER JOIN
				[Claim].[ClaimDiagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
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
				(ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			INNER JOIN
				[Claim].[ClaimDiagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				(ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				(ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			INNER JOIN
				[Claim].[ClaimDiagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					(ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
				FROM
					[Diagnosis].[Diagnosis]
				LEFT JOIN
					[Diagnosis].[DiagnosisGroup]
				ON
					[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
				AND
					[Diagnosis].[DiagnosisGroup].[IsActive] = 1
				INNER JOIN
					[Claim].[ClaimDiagnosis]
				ON
					[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
				WHERE
					[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
				AND
					[Diagnosis].[Diagnosis].[DiagnosisCode] LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[Diagnosis].[IsActive] = 1
				AND
					[Claim].[ClaimDiagnosis].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
				
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 
						(ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
					FROM
						[Diagnosis].[Diagnosis]
					LEFT JOIN
						[Diagnosis].[DiagnosisGroup]
					ON
						[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
					AND
						[Diagnosis].[DiagnosisGroup].[IsActive] = 1
					INNER JOIN
						[Claim].[ClaimDiagnosis]
					ON
						[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
					WHERE
						[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
					AND
						ISNULL('DG' + [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] , '*NO DG CODE*') LIKE @stats ESCAPE '\'
					AND
						[Diagnosis].[Diagnosis].[IsActive] = 1
					AND
						[Claim].[ClaimDiagnosis].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
			
					IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
					BEGIN
						SELECT @stats = '%' + @stats;
						
						INSERT INTO
							@TBL_ANS
						SELECT TOP 10 
							(ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
						FROM
							[Diagnosis].[Diagnosis]
						LEFT JOIN
							[Diagnosis].[DiagnosisGroup]
						ON
							[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
						AND
							[Diagnosis].[DiagnosisGroup].[IsActive] = 1
						INNER JOIN
							[Claim].[ClaimDiagnosis]
						ON
							[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
						WHERE
							[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
						AND
							(ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
						AND
							[Diagnosis].[Diagnosis].[IsActive] = 1
						AND
							[Claim].[ClaimDiagnosis].[IsActive] = 1
						ORDER BY 
							[NAME_CODE] 
						ASC;
					END
				END
			END
		END
	END		-- LongDesc ENDS
	ELSE IF @DescType = 'CustomDesc'		-- CustomDesc STARTS
	BEGIN
		IF LEN(@stats) = 0
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 50 
				(ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			INNER JOIN
				[Claim].[ClaimDiagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
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
				(ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			INNER JOIN
				[Claim].[ClaimDiagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				(ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				(ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[Diagnosis]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			INNER JOIN
				[Claim].[ClaimDiagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					(ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
				FROM
					[Diagnosis].[Diagnosis]
				LEFT JOIN
					[Diagnosis].[DiagnosisGroup]
				ON
					[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
				AND
					[Diagnosis].[DiagnosisGroup].[IsActive] = 1
				INNER JOIN
					[Claim].[ClaimDiagnosis]
				ON
					[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
				WHERE
					[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
				AND
					[Diagnosis].[Diagnosis].[DiagnosisCode] LIKE @stats ESCAPE '\'
				AND
					[Diagnosis].[Diagnosis].[IsActive] = 1
				AND
					[Claim].[ClaimDiagnosis].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
				
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 
						(ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
					FROM
						[Diagnosis].[Diagnosis]
					LEFT JOIN
						[Diagnosis].[DiagnosisGroup]
					ON
						[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
					AND
						[Diagnosis].[DiagnosisGroup].[IsActive] = 1
					INNER JOIN
						[Claim].[ClaimDiagnosis]
					ON
						[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
					WHERE
						[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
					AND
						ISNULL('DG' + [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] , '*NO DG CODE*') LIKE @stats ESCAPE '\'
					AND
						[Diagnosis].[Diagnosis].[IsActive] = 1
					AND
						[Claim].[ClaimDiagnosis].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
			
					IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
					BEGIN
						SELECT @stats = '%' + @stats;
						
						INSERT INTO
							@TBL_ANS
						SELECT TOP 10 
							(ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
						FROM
							[Diagnosis].[Diagnosis]
						LEFT JOIN
							[Diagnosis].[DiagnosisGroup]
						ON
							[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
						AND
							[Diagnosis].[DiagnosisGroup].[IsActive] = 1
						INNER JOIN
							[Claim].[ClaimDiagnosis]
						ON
							[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
						WHERE
							[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
						AND
							(ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') LIKE @stats ESCAPE '\'
						AND
							[Diagnosis].[Diagnosis].[IsActive] = 1
						AND
							[Claim].[ClaimDiagnosis].[IsActive] = 1
						ORDER BY 
							[NAME_CODE] 
						ASC;
					END
				END
			END
		END
	END		-- CustomDesc ENDS
	
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Claim].[usp_GetAutoComplete_ClaimDiagnosis] @PatientVisitID=3, @stats =' '
	-- EXEC [Claim].[usp_GetAutoComplete_ClaimDiagnosis] @PatientVisitID=1, @stats ='d'	
END
GO
