USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetAutoComplete_City]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetAutoComplete_City]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [MasterData].[usp_GetAutoComplete_City] 
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
			([MasterData].[City].[CityName] + ' [' + [MasterData].[City].[ZipCode] + ']') AS [NAME_CODE]
		FROM
			[MasterData].[City]
		WHERE
			[MasterData].[City].[IsActive] = 1
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
			([MasterData].[City].[CityName] + ' [' + [MasterData].[City].[ZipCode] + ']') AS [NAME_CODE]
		FROM
			[MasterData].[City]
		WHERE
			([MasterData].[City].[CityName] + ' [' + [MasterData].[City].[ZipCode] + ']') LIKE @stats ESCAPE '\'
		AND
			[MasterData].[City].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
			
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				([MasterData].[City].[CityName] + ' [' + [MasterData].[City].[ZipCode] + ']') AS [NAME_CODE]
			FROM
				[MasterData].[City]
			WHERE
				[MasterData].[City].[ZipCode] LIKE @stats ESCAPE '\'
			AND
				[MasterData].[City].[IsActive] = 1
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
				([MasterData].[City].[CityName] + ' [' + [MasterData].[City].[ZipCode] + ']') AS [NAME_CODE]
			FROM
				[MasterData].[City]
			WHERE
				([MasterData].[City].[CityName] + ' [' + [MasterData].[City].[ZipCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[MasterData].[City].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
	END
		
	SELECT * FROM @TBL_ANS;
		
	-- EXEC [MasterData].[usp_GetAutoComplete_City]
	-- EXEC [MasterData].[usp_GetAutoComplete_City] 'a'
	-- EXEC [MasterData].[usp_GetAutoComplete_City] 'Abbeville [31001-0000'
	-- EXEC [MasterData].[usp_GetAutoComplete_City] '31'
	-- EXEC [MasterData].[usp_GetAutoComplete_City] '[31'
END
GO
