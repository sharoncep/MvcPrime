USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetAutoComplete_PrintSign]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetAutoComplete_PrintSign]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [EDI].[usp_GetAutoComplete_PrintSign] 
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
			([EDI].[PrintSign].[PrintSignName] + ' [' +[EDI].[PrintSign].[PrintSignCode] + ']') AS [NAME_CODE]
		FROM
			[EDI].[PrintSign]
		WHERE
			[EDI].[PrintSign].[IsActive] = 1
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
			([EDI].[PrintSign].[PrintSignName] + ' [' +[EDI].[PrintSign].[PrintSignCode] + ']') AS [NAME_CODE]
		FROM
			[EDI].[PrintSign]
		WHERE
			([EDI].[PrintSign].[PrintSignName] + ' [' +[EDI].[PrintSign].[PrintSignCode] + ']') LIKE @stats ESCAPE '\'
		AND
			[EDI].[PrintSign].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
	END
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				([EDI].[PrintSign].[PrintSignName] + ' [' +[EDI].[PrintSign].[PrintSignCode] + ']') AS [NAME_CODE]
			FROM
				[EDI].[PrintSign]
			WHERE
				([EDI].[PrintSign].[PrintSignName] + ' [' +[EDI].[PrintSign].[PrintSignCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[EDI].[PrintSign].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				([EDI].[PrintSign].[PrintSignName] + ' [' +[EDI].[PrintSign].[PrintSignCode] + ']') AS [NAME_CODE]
			FROM
				[EDI].[PrintSign]
			WHERE
				[EDI].[PrintSign].[PrintSignCode] LIKE @stats ESCAPE '\'
			AND
				[EDI].[PrintSign].[IsActive] = 1
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
				([EDI].[PrintSign].[PrintSignName] + ' [' +[EDI].[PrintSign].[PrintSignCode] + ']') AS [NAME_CODE]
			FROM
				[EDI].[PrintSign]
			WHERE
				([EDI].[PrintSign].[PrintSignName] + ' [' +[EDI].[PrintSign].[PrintSignCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[EDI].[PrintSign].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
	END
		
	SELECT * FROM @TBL_ANS;
			
			
	-- EXEC [EDI].[usp_GetAutoComplete_PrintSign] ' '
	-- EXEC [EDI].[usp_GetAutoComplete_PrintSign] 'I'
END
GO
