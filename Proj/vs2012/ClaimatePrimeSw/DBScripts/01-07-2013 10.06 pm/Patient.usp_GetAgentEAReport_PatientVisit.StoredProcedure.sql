USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetAgentEAReport_PatientVisit]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Patient].[usp_GetAgentEAReport_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetAgentEAReport_PatientVisit]	

	
	
AS
BEGIN
	SET NOCOUNT ON;
	
	
	SELECT
	  ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
	  , [Billing].[Clinic].[ClinicName] as [CLINIC_NAME]
	  , (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
	  , (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
	  , [Patient].[PatientVisit].[DOS] as [DOS]
	  	,[MasterData].[ClaimStatus].[ClaimStatusName] as [CLAIM_STATUS]
		,[Patient].[PatientVisit].[PatientVisitID] as [CASE_NO]
		,([Diagnosis].[Diagnosis].[DiagnosisCode]) as DX_COUNT
		
		
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[Patient].[PatientID]=[Patient].[PatientVisit].[PatientID]
		
		INNER JOIN
		
		[Billing].[Clinic]
		
		ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
		
		INNER JOIN
		
		[Billing].[Provider]
		
		ON
		
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
		
		INNER JOIN
		
		[MasterData].[ClaimStatus]
		
		ON
		
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
		
		INNER JOIN
		
	[Diagnosis].[Diagnosis]
	
	ON
	
	
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
		
		WHERE
		
		[Patient].[PatientVisit].[TargetEAUserID] IS NOT NULL
		
		
	
	-- EXEC [Patient].[usp_GetAgentQAReport_PatientVisit]  
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] 
END
GO
