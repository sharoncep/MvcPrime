USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetByPkId_ClaimStatus]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetByPkId_ClaimStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetByPkId_ClaimStatus] 
	@ClaimStatusID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[MasterData].[ClaimStatus].*
	FROM
		[MasterData].[ClaimStatus]
	WHERE
		[MasterData].[ClaimStatus].[ClaimStatusID] = @ClaimStatusID
	AND
		[MasterData].[ClaimStatus].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[ClaimStatus].[IsActive] ELSE @IsActive END;

	-- EXEC [MasterData].[usp_GetByPkId_ClaimStatus] 1, NULL
	-- EXEC [MasterData].[usp_GetByPkId_ClaimStatus] 1, 1
	-- EXEC [MasterData].[usp_GetByPkId_ClaimStatus] 1, 0
END
GO
