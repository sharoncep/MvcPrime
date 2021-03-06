USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetByPkId_ClaimProcess]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetByPkId_ClaimProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Claim].[usp_GetByPkId_ClaimProcess] 
	@ClaimProcessID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Claim].[ClaimProcess].*
	FROM
		[Claim].[ClaimProcess]
	WHERE
		[Claim].[ClaimProcess].[ClaimProcessID] = @ClaimProcessID
	AND
		[Claim].[ClaimProcess].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimProcess].[IsActive] ELSE @IsActive END;

	-- EXEC [Claim].[usp_GetByPkId_ClaimProcess] 1, NULL
	-- EXEC [Claim].[usp_GetByPkId_ClaimProcess] 1, 1
	-- EXEC [Claim].[usp_GetByPkId_ClaimProcess] 1, 0
END
GO
