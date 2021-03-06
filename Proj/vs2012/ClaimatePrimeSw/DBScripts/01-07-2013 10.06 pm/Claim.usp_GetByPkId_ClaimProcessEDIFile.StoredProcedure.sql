USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetByPkId_ClaimProcessEDIFile]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetByPkId_ClaimProcessEDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Claim].[usp_GetByPkId_ClaimProcessEDIFile] 
	@ClaimProcessEDIFileID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Claim].[ClaimProcessEDIFile].*
	FROM
		[Claim].[ClaimProcessEDIFile]
	WHERE
		[Claim].[ClaimProcessEDIFile].[ClaimProcessEDIFileID] = @ClaimProcessEDIFileID
	AND
		[Claim].[ClaimProcessEDIFile].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimProcessEDIFile].[IsActive] ELSE @IsActive END;

	-- EXEC [Claim].[usp_GetByPkId_ClaimProcessEDIFile] 1, NULL
	-- EXEC [Claim].[usp_GetByPkId_ClaimProcessEDIFile] 1, 1
	-- EXEC [Claim].[usp_GetByPkId_ClaimProcessEDIFile] 1, 0
END
GO
