USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetAutoComplete_DiagnosisGroup]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetAutoComplete_DiagnosisGroup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Diagnosis].[usp_GetAutoComplete_DiagnosisGroup] 
	@stats	NVARCHAR (150) = NULL
AS
BEGIN
	SET NOCOUNT ON;
		
	DECLARE @TBL_ANS TABLE ([ID] INT NOT NULL IDENTITY (1, 1), [NAME_CODE] NVARCHAR(165) NOT NULL);
	
	IF @stats IS NULL
	BEGIN
		SELECT @stats = '';
	END
	ELSE
	BEGIN
		SELECT @stats = LTRIM(RTRIM(@stats));
	END
	
	IF LEN(@stats) = 0
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT TOP 50 
			([Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] + ' [' +[Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] + ']') AS [NAME_CODE]
		FROM
			[Diagnosis].[DiagnosisGroup]
		WHERE
			[Diagnosis].[DiagnosisGroup].[IsActive] = 1
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
			([Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] + ' [' +[Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] + ']') AS [NAME_CODE]
		FROM
			[Diagnosis].[DiagnosisGroup]
		WHERE
			([Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] + ' [' +[Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] + ']') LIKE @stats ESCAPE '\'
		AND
			[Diagnosis].[DiagnosisGroup].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				([Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] + ' [' +[Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[DiagnosisGroup]
			WHERE
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
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
				([Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] + ' [' +[Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] + ']') AS [NAME_CODE]
			FROM
				[Diagnosis].[DiagnosisGroup]
			WHERE
				([Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] + ' [' +[Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			END
	END
		
	SELECT * FROM @TBL_ANS;
	---- EXEC [Diagnosis].[usp_GetAutoComplete_DiagnosisGroup] 'I'
	---- EXEC [Diagnosis].[usp_GetAutoComplete_DiagnosisGroup] '00'
	
	
	
END
GO
