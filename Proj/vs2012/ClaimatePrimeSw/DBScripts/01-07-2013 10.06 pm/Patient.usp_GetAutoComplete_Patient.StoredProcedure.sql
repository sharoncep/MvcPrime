USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetAutoComplete_Patient]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetAutoComplete_Patient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Patient].[usp_GetAutoComplete_Patient] 
	@ClinicID int
	, @stats	NVARCHAR (150) = NULL
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
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], '')))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') AS [NAME_CODE]
		FROM
			[Patient].[Patient]
		WHERE
			[Patient].[Patient].[ClinicID] = @ClinicID
		AND
			[Patient].[Patient].[IsActive] = 1
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
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], '')))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') AS [NAME_CODE]
		FROM
			[Patient].[Patient]
		WHERE
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], '')))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE @stats ESCAPE '\'
		AND
			[Patient].[Patient].[ClinicID] = @ClinicID
		AND
			[Patient].[Patient].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], '')))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') AS [NAME_CODE]
			FROM
				[Patient].[Patient]
			WHERE
				[Patient].[Patient].[ChartNumber] LIKE @stats ESCAPE '\'
			AND
				[Patient].[Patient].[ClinicID] = @ClinicID
			AND
				[Patient].[Patient].[IsActive] = 1
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
				((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], '')))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') AS [NAME_CODE]
			FROM
				[Patient].[Patient]
			WHERE
				((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], '')))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE @stats ESCAPE '\'
			AND
				[Patient].[Patient].[ClinicID] = @ClinicID
			AND
				[Patient].[Patient].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			END
	END
		
	SELECT * FROM @TBL_ANS;	
	-- EXEC [Patient].[usp_GetAutoComplete_Patient] @ClinicID = '2', @stats = 'XAVC'
	-- EXEC [Patient].[usp_GetAutoComplete_Patient] @ClinicID = '2', @stats = ' '
END
GO
