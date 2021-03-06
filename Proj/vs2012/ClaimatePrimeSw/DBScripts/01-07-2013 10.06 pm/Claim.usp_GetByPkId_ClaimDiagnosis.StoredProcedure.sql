USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetByPkId_ClaimDiagnosis]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetByPkId_ClaimDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Claim].[usp_GetByPkId_ClaimDiagnosis] 
	@ClaimDiagnosisID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Claim].[ClaimDiagnosis].*
	FROM
		[Claim].[ClaimDiagnosis]
	WHERE
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = @ClaimDiagnosisID
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosis].[IsActive] ELSE @IsActive END;

	-- EXEC [Claim].[usp_GetByPkId_ClaimDiagnosis] 1, NULL
	-- EXEC [Claim].[usp_GetByPkId_ClaimDiagnosis] 1, 1
	-- EXEC [Claim].[usp_GetByPkId_ClaimDiagnosis] 1, 0
END
GO
