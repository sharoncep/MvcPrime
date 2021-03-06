USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByPkId_InterchangeIDQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByPkId_InterchangeIDQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetByPkId_InterchangeIDQualifier] 
	@InterchangeIDQualifierID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Transaction].[InterchangeIDQualifier].*
	FROM
		[Transaction].[InterchangeIDQualifier]
	WHERE
		[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierID] = @InterchangeIDQualifierID
	AND
		[Transaction].[InterchangeIDQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[InterchangeIDQualifier].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetByPkId_InterchangeIDQualifier] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_InterchangeIDQualifier] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_InterchangeIDQualifier] 1, 0
END
GO
