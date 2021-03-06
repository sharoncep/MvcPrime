USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetNameByID_InterchangeUsageIndicator]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetNameByID_InterchangeUsageIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetNameByID_InterchangeUsageIndicator] 
	@InterchangeUsageIndicatorID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [NAME_CODE] NVARCHAR(500) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		([Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] + ' [' +[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] + ']') AS [NAME_CODE]
	FROM
		[Transaction].[InterchangeUsageIndicator]
	WHERE
		@InterchangeUsageIndicatorID = [Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorID]
	AND
		[Transaction].[InterchangeUsageIndicator].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[InterchangeUsageIndicator].[IsActive] ELSE @IsActive END;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Transaction].[usp_GetNameByID_InterchangeUsageIndicator] 1, NULL
	
END
GO
