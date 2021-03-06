USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetAutoComplete_Provider]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetAutoComplete_Provider]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetAutoComplete_Provider] 
	@stats	NVARCHAR (150) = NULL,
	@cliniccode int
AS
BEGIN
	SET NOCOUNT ON;
		
	DECLARE @TBL_ANS TABLE ([ID] INT NOT NULL IDENTITY (1, 1), [NAME_CODE] NVARCHAR(400) NOT NULL);
	
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
			([Billing].[Provider].[LastName] +[Billing].[Provider].[FirstName]+ ' [' +[Billing].[Provider].[ProviderCode] + ']') AS [NAME_CODE]
		FROM
			[Billing].[Provider]
		WHERE
			[Billing].[Provider].[ClinicID] = @cliniccode
		AND
			[Billing].[Provider].[IsActive] = 1
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
			([Billing].[Provider].[LastName] +[Billing].[Provider].[FirstName]+ ' [' +[Billing].[Provider].[ProviderCode] + ']') AS [NAME_CODE]
		FROM
			[Billing].[Provider]
		WHERE
			([Billing].[Provider].[LastName] +[Billing].[Provider].[FirstName]+ ' [' +[Billing].[Provider].[ProviderCode] + ']') LIKE @stats ESCAPE '\'
		AND
			[Billing].[Provider].[ClinicID] = @cliniccode
		AND
			[Billing].[Provider].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				([Billing].[Provider].[LastName] +[Billing].[Provider].[FirstName]+ ' [' +[Billing].[Provider].[ProviderCode] + ']') AS [NAME_CODE]
			FROM
				[Billing].[Provider]
			WHERE
				[Billing].[Provider].[ProviderCode] LIKE @stats ESCAPE '\'
			AND
				[Billing].[Provider].[ClinicID] = @cliniccode
			AND
				[Billing].[Provider].[IsActive] = 1
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
				([Billing].[Provider].[LastName] +[Billing].[Provider].[FirstName]+ ' [' +[Billing].[Provider].[ProviderCode] + ']') AS [NAME_CODE]
			FROM
				[Billing].[Provider]
			WHERE
				([Billing].[Provider].[LastName] +[Billing].[Provider].[FirstName]+ ' [' +[Billing].[Provider].[ProviderCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[Billing].[Provider].[ClinicID] = @cliniccode
			AND
				[Billing].[Provider].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			END
	END
		
	SELECT * FROM @TBL_ANS;		
	
	-- EXEC [Billing].[usp_GetAutoComplete_Provider] 'M',2
	-- EXEC [Billing].[usp_GetAutoComplete_Provider] ' ', 2
	-- EXEC [Billing].[usp_GetAutoComplete_Provider] 'A', 2
END
GO
