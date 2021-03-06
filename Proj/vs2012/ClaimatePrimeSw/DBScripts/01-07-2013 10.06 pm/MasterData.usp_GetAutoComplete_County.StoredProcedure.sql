USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetAutoComplete_County]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetAutoComplete_County]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [MasterData].[usp_GetAutoComplete_County] 
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
			([MasterData].[County].[CountyName] + ' [' +[MasterData].[County].[CountyCode] + ']') AS [NAME_CODE]
		FROM
			[MasterData].[County]
		WHERE
			[MasterData].[County].[IsActive] = 1
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
			([MasterData].[County].[CountyName] + ' [' +[MasterData].[County].[CountyCode] + ']') AS [NAME_CODE]
		FROM
			[MasterData].[County]
		WHERE
			([MasterData].[County].[CountyName] + ' [' +[MasterData].[County].[CountyCode] + ']') LIKE @stats ESCAPE '\'
		AND
			[MasterData].[County].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
		END
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
		([MasterData].[County].[CountyName] + ' [' +[MasterData].[County].[CountyCode] + ']') AS [NAME_CODE]
		FROM
			[MasterData].[County]
		WHERE
			[MasterData].[County].[CountyCode] LIKE @stats ESCAPE '\'
		AND
			[MasterData].[County].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			SELECT @stats = '%' + @stats;
			
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
			([MasterData].[County].[CountyName] + ' [' +[MasterData].[County].[CountyCode] + ']') AS [NAME_CODE]
		FROM
			[MasterData].[County]
		WHERE
			([MasterData].[County].[CountyName] + ' [' +[MasterData].[County].[CountyCode] + ']') LIKE @stats ESCAPE '\'
		AND
			[MasterData].[County].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
		END
	END
SELECT * FROM @TBL_ANS;	
	-- EXEC [MasterData].[usp_GetAutoComplete_County]  ' '
	-- EXEC [MasterData].[usp_GetAutoComplete_County]  'I'
END
GO
