USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetAutoComplete_PrintPin]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetAutoComplete_PrintPin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [EDI].[usp_GetAutoComplete_PrintPin] 
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
			([EDI].[PrintPin].[PrintPinName] + ' [' +[EDI].[PrintPin].[PrintPinCode] + ']') AS [NAME_CODE]
		FROM
			[EDI].[PrintPin]
		WHERE
			[EDI].[PrintPin].[IsActive] = 1
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
			([EDI].[PrintPin].[PrintPinName] + ' [' +[EDI].[PrintPin].[PrintPinCode] + ']') AS [NAME_CODE]
		FROM
			[EDI].[PrintPin]
		WHERE
			([EDI].[PrintPin].[PrintPinName] + ' [' +[EDI].[PrintPin].[PrintPinCode] + ']') LIKE @stats ESCAPE '\'
		AND
			[EDI].[PrintPin].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
	END
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				([EDI].[PrintPin].[PrintPinName] + ' [' +[EDI].[PrintPin].[PrintPinCode] + ']') AS [NAME_CODE]
			FROM
				[EDI].[PrintPin]
			WHERE
				([EDI].[PrintPin].[PrintPinName] + ' [' +[EDI].[PrintPin].[PrintPinCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[EDI].[PrintPin].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				([EDI].[PrintPin].[PrintPinName] + ' [' +[EDI].[PrintPin].[PrintPinCode] + ']') AS [NAME_CODE]
			FROM
				[EDI].[PrintPin]
			WHERE
				[EDI].[PrintPin].[PrintPinCode] LIKE @stats ESCAPE '\'
			AND
				[EDI].[PrintPin].[IsActive] = 1
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
				([EDI].[PrintPin].[PrintPinName] + ' [' +[EDI].[PrintPin].[PrintPinCode] + ']') AS [NAME_CODE]
			FROM
				[EDI].[PrintPin]
			WHERE
				([EDI].[PrintPin].[PrintPinName] + ' [' +[EDI].[PrintPin].[PrintPinCode] + ']') LIKE @stats ESCAPE '\'
			AND
				[EDI].[PrintPin].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
	END
		
	SELECT * FROM @TBL_ANS;
			
			
	-- EXEC [EDI].[usp_GetAutoComplete_PrintPin] ' '
	-- EXEC [EDI].[usp_GetAutoComplete_PrintPin] 'I'
END
GO
