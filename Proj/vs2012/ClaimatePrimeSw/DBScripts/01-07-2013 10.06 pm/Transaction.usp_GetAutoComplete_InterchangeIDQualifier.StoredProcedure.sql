USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetAutoComplete_InterchangeIDQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetAutoComplete_InterchangeIDQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Transaction].[usp_GetAutoComplete_InterchangeIDQualifier] 
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
			([Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] + ' [' +[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] + ']') AS [NAME_CODE]
		FROM
			[Transaction].[InterchangeIDQualifier]
		WHERE
			[Transaction].[InterchangeIDQualifier].[IsActive] = 1
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
			([Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] + ' [' +[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] + ']') AS [NAME_CODE]
		FROM
			[Transaction].[InterchangeIDQualifier]
		WHERE
			([Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] + ' [' +[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] + ']') LIKE @stats ESCAPE '\'
		AND
			[Transaction].[InterchangeIDQualifier].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
	
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				([Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] + ' [' +[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] + ']') AS [NAME_CODE]
			FROM
				[Transaction].[InterchangeIDQualifier]
			WHERE
				[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] LIKE @stats ESCAPE '\'
			AND
				[Transaction].[InterchangeIDQualifier].[IsActive] = 1
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
				([Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] + ' [' +[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] + ']') AS [NAME_CODE]
			FROM
				[Transaction].[InterchangeIDQualifier]
			WHERE
				([Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] + ' [' +[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[Transaction].[InterchangeIDQualifier].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
			END
			END
		
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Transaction].[usp_GetAutoComplete_InterchangeIDQualifier] ' '
	-- EXEC [Transaction].[usp_GetAutoComplete_InterchangeIDQualifier] 'I'
END
GO
