USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetPkId_ClaimDiagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_GetPkId_ClaimDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetPkId_ClaimDiagnosis] 
	@PatientVisitID	BIGINT
	, @DiagnosisID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [ClaimDiagnosisID] BIGINT 
	);
	
	INSERT INTO
		@TBL_RES
	SELECT
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] AS [ClaimDiagnosisID]
	FROM
		[Claim].[ClaimDiagnosis]
	WHERE
		@PatientVisitID = [Claim].[ClaimDiagnosis].[PatientVisitID]
	AND
		@DiagnosisID = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 0
		
	SELECT * FROM @TBL_RES;

	-- EXEC [Claim].[usp_GetPkId_ClaimDiagnosis] 1, NULL
	-- EXEC [Claim].[usp_GetPkId_ClaimDiagnosis] 1, 1
	-- EXEC [Claim].[usp_GetPkId_ClaimDiagnosis] 1, 0
END
GO
