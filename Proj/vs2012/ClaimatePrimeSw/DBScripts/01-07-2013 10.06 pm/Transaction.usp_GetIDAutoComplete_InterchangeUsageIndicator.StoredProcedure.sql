USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetIDAutoComplete_InterchangeUsageIndicator]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetIDAutoComplete_InterchangeUsageIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetIDAutoComplete_InterchangeUsageIndicator] 
	@InterchangeUsageIndicatorCode	nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [InterchangeUsageIndicator_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorID]
	FROM
		[Transaction].[InterchangeUsageIndicator]
	WHERE
		@InterchangeUsageIndicatorCode = [Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode]
	AND
		[Transaction].[InterchangeUsageIndicator].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Diagnosis].[usp_GetIDAutoComplete_InterchangeUsageIndicator] 1, NULL
	-- EXEC [Diagnosis].[usp_GetIDAutoComplete_InterchangeUsageIndicator] 1, 1
	-- EXEC [Diagnosis].[usp_GetIDAutoComplete_InterchangeUsageIndicator] 1, 0
END
GO
