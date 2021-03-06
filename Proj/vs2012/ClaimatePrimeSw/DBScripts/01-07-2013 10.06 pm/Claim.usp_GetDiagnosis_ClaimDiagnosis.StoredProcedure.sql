USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetDiagnosis_ClaimDiagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_GetDiagnosis_ClaimDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetDiagnosis_ClaimDiagnosis] 
	@PatientVisitID  BIGINT 
	,@IsActive BIT 
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
		,[Claim].[ClaimDiagnosis].[DiagnosisID]
	FROM
		[Claim].[ClaimDiagnosis]
	INNER JOIN
		[Patient].[PatientVisit]
	ON
		[Patient].[PatientVisit].[PatientVisitID] = [Claim].[ClaimDiagnosis].[PatientVisitID]
	WHERE
		[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID 
	AND
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] <> [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND 
		[Claim].[ClaimDiagnosis].[IsActive] = @IsActive
	ORDER BY
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
	ASC;
	
	-- EXEC [Claim].[usp_GetDiagnosis_ClaimDiagnosis] 4286, 0
	-- EXEC [Claim].[usp_GetDiagnosis_ClaimDiagnosis] 4286, 1
END
GO
