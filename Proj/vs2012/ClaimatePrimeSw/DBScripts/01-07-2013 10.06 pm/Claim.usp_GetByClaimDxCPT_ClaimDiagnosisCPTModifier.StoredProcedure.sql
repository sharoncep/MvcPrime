USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetByClaimDxCPT_ClaimDiagnosisCPTModifier]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetByClaimDxCPT_ClaimDiagnosisCPTModifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Claim].[usp_GetByClaimDxCPT_ClaimDiagnosisCPTModifier] 
	@ClaimDiagnosisCPTID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Claim].[ClaimDiagnosisCPTModifier].*
	FROM
		[Claim].[ClaimDiagnosisCPTModifier]
	WHERE
		@ClaimDiagnosisCPTID = [Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTID]
	AND
		[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosisCPTModifier].[IsActive] ELSE @IsActive END;

	-- EXEC [Claim].[usp_GetByClaimDxCPT_ClaimDiagnosisCPTModifier] 8, NULL
	-- EXEC [Claim].[usp_GetByClaimDxCPT_ClaimDiagnosisCPTModifier] 1, 1
	-- EXEC [Claim].[usp_GetByClaimDxCPT_ClaimDiagnosisCPTModifier] 1, 0
END
GO
