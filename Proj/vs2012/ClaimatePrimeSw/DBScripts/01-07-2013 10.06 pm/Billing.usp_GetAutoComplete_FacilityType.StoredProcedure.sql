USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetAutoComplete_FacilityType]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetAutoComplete_FacilityType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Billing].[usp_GetAutoComplete_FacilityType] 
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
			([Billing].[FacilityType].[FacilityTypeName] + ' [' +[Billing].[FacilityType].[FacilityTypeCode] + ']') AS [NAME_CODE]
		FROM
			[Billing].[FacilityType]
		WHERE
			[Billing].[FacilityType].[IsActive] = 1
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
			([Billing].[FacilityType].[FacilityTypeName] + ' [' +[Billing].[FacilityType].[FacilityTypeCode] + ']') AS [NAME_CODE]
		FROM
			[Billing].[FacilityType]
		WHERE
			([Billing].[FacilityType].[FacilityTypeName] + ' [' +[Billing].[FacilityType].[FacilityTypeCode] + ']') LIKE @stats ESCAPE '\'
		AND
			[Billing].[FacilityType].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				([Billing].[FacilityType].[FacilityTypeName] + ' [' +[Billing].[FacilityType].[FacilityTypeCode] + ']') AS [NAME_CODE]
			FROM
				[Billing].[FacilityType]
			WHERE
				[Billing].[FacilityType].[FacilityTypeCode] LIKE @stats ESCAPE '\'
			AND
				[Billing].[FacilityType].[IsActive] = 1
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
				([Billing].[FacilityType].[FacilityTypeName] + ' [' +[Billing].[FacilityType].[FacilityTypeCode] + ']') AS [NAME_CODE]
			FROM
				[Billing].[FacilityType]
			WHERE
				([Billing].[FacilityType].[FacilityTypeName] + ' [' +[Billing].[FacilityType].[FacilityTypeCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[Billing].[FacilityType].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			END
	END
		
	SELECT * FROM @TBL_ANS;
	---- EXEC [Billing].[usp_GetAutoComplete_FacilityType] 'I'
	---- EXEC [Billing].[usp_GetAutoComplete_FacilityType] '00'
	
	
	
END
GO
