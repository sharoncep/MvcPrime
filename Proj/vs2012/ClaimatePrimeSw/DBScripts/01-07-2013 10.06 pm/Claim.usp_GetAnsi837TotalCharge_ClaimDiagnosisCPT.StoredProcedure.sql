USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837TotalCharge_ClaimDiagnosisCPT]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetAnsi837TotalCharge_ClaimDiagnosisCPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetAnsi837TotalCharge_ClaimDiagnosisCPT]
	@PatientVisitID	BIGINT 
	, @ClaimNumber BIGINT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT
		SUM([Claim].[ClaimDiagnosisCPT].[ChargePerUnit] * [Claim].[ClaimDiagnosisCPT].[Unit]) AS [SUM_CHARGE]
	FROM
		[Claim].[ClaimDiagnosisCPT]
	INNER JOIN
		[Claim].[ClaimDiagnosis]
	ON
		[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
	WHERE
		[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
	AND
		[Claim].[ClaimDiagnosis].[ClaimNumber] IN (@ClaimNumber, '-1')
	AND
		[Claim].[ClaimDiagnosisCPT].[IsActive] = 1
	
	-- EXEC [Claim].[usp_GetAnsi837TotalCharge_ClaimDiagnosisCPT] @PatientVisitID = 23199, @ClaimNumber=5
END
GO
