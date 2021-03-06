USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByPkId_InterchangeUsageIndicator]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByPkId_InterchangeUsageIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetByPkId_InterchangeUsageIndicator] 
	@InterchangeUsageIndicatorID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Transaction].[InterchangeUsageIndicator].*
	FROM
		[Transaction].[InterchangeUsageIndicator]
	WHERE
		[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorID] = @InterchangeUsageIndicatorID
	AND
		[Transaction].[InterchangeUsageIndicator].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[InterchangeUsageIndicator].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetByPkId_InterchangeUsageIndicator] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_InterchangeUsageIndicator] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_InterchangeUsageIndicator] 1, 0
END
GO
