USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetByPkId_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetByPkId_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Patient].[usp_GetByPkId_PatientVisit] 
	@PatientVisitID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Patient].[PatientVisit].*
		, (SELECT
				COUNT([Claim].[ClaimDiagnosis].[ClaimDiagnosisID])
			FROM
				[Claim].[ClaimDiagnosis]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
		) AS [DX_COUNT]
	FROM
		[Patient].[PatientVisit]
	WHERE
		@PatientVisitID = [Patient].[PatientVisit].[PatientVisitID]
	AND
		[Patient].[PatientVisit].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientVisit].[IsActive] ELSE @IsActive END;

	-- EXEC [Patient].[usp_GetByPkId_PatientVisit] 1, NULL
	-- EXEC [Patient].[usp_GetByPkId_PatientVisit] 1, 1
	-- EXEC [Patient].[usp_GetByPkId_PatientVisit] 1, 0
END
GO
