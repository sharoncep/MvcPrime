USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetByPkId_ClaimDiagnosisCPT]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetByPkId_ClaimDiagnosisCPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Claim].[usp_GetByPkId_ClaimDiagnosisCPT] 
	@ClaimDiagnosisCPTID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Claim].[ClaimDiagnosisCPT].*
	FROM
		[Claim].[ClaimDiagnosisCPT]
	WHERE
		[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] = @ClaimDiagnosisCPTID
	AND
		[Claim].[ClaimDiagnosisCPT].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosisCPT].[IsActive] ELSE @IsActive END;

	-- EXEC [Claim].[usp_GetByPkId_ClaimDiagnosisCPT] 1, NULL
	-- EXEC [Claim].[usp_GetByPkId_ClaimDiagnosisCPT] 1, 1
	-- EXEC [Claim].[usp_GetByPkId_ClaimDiagnosisCPT] 1, 0
END
GO
