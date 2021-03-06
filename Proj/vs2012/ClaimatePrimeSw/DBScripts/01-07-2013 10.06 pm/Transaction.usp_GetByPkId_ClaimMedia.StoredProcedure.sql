USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetByPkId_ClaimMedia]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetByPkId_ClaimMedia]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Transaction].[usp_GetByPkId_ClaimMedia] 
	@ClaimMediaID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Transaction].[ClaimMedia].*
	FROM
		[Transaction].[ClaimMedia]
	WHERE
		[Transaction].[ClaimMedia].[ClaimMediaID] = @ClaimMediaID
	AND
		[Transaction].[ClaimMedia].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[ClaimMedia].[IsActive] ELSE @IsActive END;

	-- EXEC [Transaction].[usp_GetByPkId_ClaimMedia] 1, NULL
	-- EXEC [Transaction].[usp_GetByPkId_ClaimMedia] 1, 1
	-- EXEC [Transaction].[usp_GetByPkId_ClaimMedia] 1, 0
END
GO
