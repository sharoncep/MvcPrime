USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetAutoComplete_InsuranceType]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetAutoComplete_InsuranceType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Insurance].[usp_GetAutoComplete_InsuranceType] 
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
			([Insurance].[InsuranceType].[InsuranceTypeName] + ' [' +[Insurance].[InsuranceType].[InsuranceTypeCode] + ']') AS [NAME_CODE]
		FROM
			[Insurance].[InsuranceType]
		WHERE
			[Insurance].[InsuranceType].[IsActive] = 1
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
			([Insurance].[InsuranceType].[InsuranceTypeName] + ' [' +[Insurance].[InsuranceType].[InsuranceTypeCode] + ']') AS [NAME_CODE]
		FROM
			[Insurance].[InsuranceType]
		WHERE
			([Insurance].[InsuranceType].[InsuranceTypeName] + ' [' +[Insurance].[InsuranceType].[InsuranceTypeCode] + ']') LIKE @stats ESCAPE '\'
		AND
			[Insurance].[InsuranceType].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
	END
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				([Insurance].[InsuranceType].[InsuranceTypeName] + ' [' +[Insurance].[InsuranceType].[InsuranceTypeCode] + ']') AS [NAME_CODE]
			FROM
				[Insurance].[InsuranceType]
			WHERE
				([Insurance].[InsuranceType].[InsuranceTypeName] + ' [' +[Insurance].[InsuranceType].[InsuranceTypeCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[Insurance].[InsuranceType].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				([Insurance].[InsuranceType].[InsuranceTypeName] + ' [' +[Insurance].[InsuranceType].[InsuranceTypeCode] + ']') AS [NAME_CODE]
			FROM
				[Insurance].[InsuranceType]
			WHERE
				[Insurance].[InsuranceType].[InsuranceTypeCode] LIKE @stats ESCAPE '\'
			AND
				[Insurance].[InsuranceType].[IsActive] = 1
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
				([Insurance].[InsuranceType].[InsuranceTypeName] + ' [' +[Insurance].[InsuranceType].[InsuranceTypeCode] + ']') AS [NAME_CODE]
			FROM
				[Insurance].[InsuranceType]
			WHERE
				([Insurance].[InsuranceType].[InsuranceTypeName] + ' [' +[Insurance].[InsuranceType].[InsuranceTypeCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[Insurance].[InsuranceType].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
	END
		
	SELECT * FROM @TBL_ANS;
			
			
	-- EXEC [Insurance].[usp_GetAutoComplete_InsuranceType] ' '
	-- EXEC [Insurance].[usp_GetAutoComplete_InsuranceType] 'I'
END
GO
