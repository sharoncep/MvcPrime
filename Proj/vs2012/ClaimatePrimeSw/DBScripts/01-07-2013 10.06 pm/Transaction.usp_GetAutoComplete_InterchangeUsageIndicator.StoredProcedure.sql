USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetAutoComplete_InterchangeUsageIndicator]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetAutoComplete_InterchangeUsageIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Transaction].[usp_GetAutoComplete_InterchangeUsageIndicator] 
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
			([Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] + ' [' +[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] + ']') AS [NAME_CODE]
		FROM
			[Transaction].[InterchangeUsageIndicator]
		WHERE
			[Transaction].[InterchangeUsageIndicator].[IsActive] = 1
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
			([Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] + ' [' +[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] + ']') AS [NAME_CODE]
		FROM
			[Transaction].[InterchangeUsageIndicator]
		WHERE
			([Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] + ' [' +[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] + ']') LIKE @stats ESCAPE '\'
		AND
			[Transaction].[InterchangeUsageIndicator].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
	
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				([Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] + ' [' +[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] + ']') AS [NAME_CODE]
			FROM
				[Transaction].[InterchangeUsageIndicator]
			WHERE
				[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] LIKE @stats ESCAPE '\'
			AND
				[Transaction].[InterchangeUsageIndicator].[IsActive] = 1
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
				([Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] + ' [' +[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] + ']') AS [NAME_CODE]
			FROM
				[Transaction].[InterchangeUsageIndicator]
			WHERE
				([Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] + ' [' +[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[Transaction].[InterchangeUsageIndicator].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			END
			END
		
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Transaction].[usp_GetAutoComplete_InterchangeUsageIndicator] ' '
	-- EXEC [Transaction].[usp_GetAutoComplete_InterchangeUsageIndicator] 'I'
END
GO
