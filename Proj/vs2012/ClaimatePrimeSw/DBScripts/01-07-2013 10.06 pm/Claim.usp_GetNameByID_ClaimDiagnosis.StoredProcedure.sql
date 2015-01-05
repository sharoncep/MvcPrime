USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetNameByID_ClaimDiagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_GetNameByID_ClaimDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetNameByID_ClaimDiagnosis] 
	@PatientVisitID BIGINT
	, @IsActive BIT 
	, @DescType NVARCHAR(15) = NULL
	
AS
BEGIN
	SET NOCOUNT ON;
	IF (@DescType IS NULL) OR (NOT (@DescType = 'ShortDesc' OR @DescType = 'MediumDesc' OR @DescType = 'LongDesc' OR @DescType = 'CustomDesc')) OR (@DescType = 'ShortDesc')
	BEGIN
		SELECT
			[Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
			, (ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Claim].[ClaimDiagnosis]
		ON
			[Claim].[ClaimDiagnosis].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
		INNER JOIN
			[Diagnosis].[Diagnosis]
		ON
			[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
		LEFT JOIN
			[Diagnosis].[DiagnosisGroup]
		ON
			[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
		AND
			[Diagnosis].[DiagnosisGroup].[IsActive] = 1
		WHERE
			[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID
		AND
			[Diagnosis].[Diagnosis].[IsActive] = 1
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Claim].[ClaimDiagnosis].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosis].[IsActive] ELSE @IsActive END
		
	END			
	IF (@DescType = 'MediumDesc')
	BEGIN
		SELECT
			[Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
			, (ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Claim].[ClaimDiagnosis]
		ON
			[Claim].[ClaimDiagnosis].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
		INNER JOIN
			[Diagnosis].[Diagnosis]
		ON
			[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
		LEFT JOIN
			[Diagnosis].[DiagnosisGroup]
		ON
			[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
		AND
			[Diagnosis].[DiagnosisGroup].[IsActive] = 1
		WHERE
			[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID
		AND
			[Diagnosis].[Diagnosis].[IsActive] = 1
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Claim].[ClaimDiagnosis].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosis].[IsActive] ELSE @IsActive END
	END	
	IF (@DescType = 'LongDesc')
	BEGIN
		SELECT
			[Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
			, (ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Claim].[ClaimDiagnosis]
		ON
			[Claim].[ClaimDiagnosis].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
		INNER JOIN
			[Diagnosis].[Diagnosis]
		ON
			[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
		LEFT JOIN
			[Diagnosis].[DiagnosisGroup]
		ON
			[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
		AND
			[Diagnosis].[DiagnosisGroup].[IsActive] = 1
		WHERE
			[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID
		AND
			[Diagnosis].[Diagnosis].[IsActive] = 1
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Claim].[ClaimDiagnosis].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosis].[IsActive] ELSE @IsActive END
	END	
	IF (@DescType = 'CustomDesc')
	BEGIN
		SELECT
			[Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
			, (ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Claim].[ClaimDiagnosis]
		ON
			[Claim].[ClaimDiagnosis].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
		INNER JOIN
			[Diagnosis].[Diagnosis]
		ON
			[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
		LEFT JOIN
			[Diagnosis].[DiagnosisGroup]
		ON
			[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
		AND
			[Diagnosis].[DiagnosisGroup].[IsActive] = 1
		WHERE
			[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID
		AND
			[Diagnosis].[Diagnosis].[IsActive] = 1
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Claim].[ClaimDiagnosis].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosis].[IsActive] ELSE @IsActive END
	END			
	
	-- EXEC [Claim].[usp_GetNameByID_ClaimDiagnosis] @PatientVisitID = 22690, @IsActive=1, @DescType = 'LongDesc'
	-- EXEC [Claim].[usp_GetNameByID_ClaimDiagnosis] @PatientVisitID = 2, @IsActive=0
	-- EXEC [Claim].[usp_GetNameByID_ClaimDiagnosis] @PatientVisitID = 4333, @IsActive=1
END
GO
