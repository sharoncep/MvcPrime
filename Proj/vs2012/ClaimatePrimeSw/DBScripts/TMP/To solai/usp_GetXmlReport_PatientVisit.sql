
/****** Object:  StoredProcedure [Patient].[usp_GetXmlReport_PatientVisit]    Script Date: 07/24/2013 13:26:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReport_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReport_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReport_PatientVisit]    Script Date: 07/24/2013 13:26:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetXmlReport_PatientVisit]	
     @UserID INT	
AS
BEGIN
	SET NOCOUNT ON;
	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [Patient].[PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
		, (
			SELECT 
				 ROW_NUMBER() OVER (ORDER BY [Claim].[ClaimDiagnosis].[ClaimDiagnosisID] ASC) AS [SN]
				, [ClaimDiagnosis].[ClaimDiagnosisID] AS [CLAIMDIAGNOSIS_ID]
				, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [DIAGNOSIS_CODE]
				, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
				, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
				, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
				, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
				, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
				, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
				, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
				, (
					SELECT
						ROW_NUMBER() OVER (ORDER BY [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] ASC) AS [SN]
						, [ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPTID]
						, [Diagnosis].[CPT].[CPTCode] AS [CPT_CODE]
						, [Diagnosis].[CPT].[ShortDesc] AS [SHORT_DESC]
						, [Diagnosis].[CPT].[LongDesc] AS [LONG_DESC]
						, [Diagnosis].[CPT].[MediumDesc] AS [MEDIUM_DESC]
						, [Diagnosis].[CPT].[CustomDesc] AS [CUSTOM_DESC]
						, [Billing].[FacilityType].[FacilityTypeName]  AS [FACILITYTYPE_NAME]
						, [Claim].[ClaimDiagnosisCPT].[Unit]  AS [UNIT]
						, [Diagnosis].[CPT].[ChargePerUnit] AS [CHARGE_PER_UNIT]
						, (
							SELECT
								ROW_NUMBER() OVER (ORDER BY [Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTModifierID] ASC) AS [SN]
								, [Diagnosis].[Modifier].[ModifierCode] AS [MODIFIER_CODE]
								, [Diagnosis].[Modifier].[ModifierName] AS [MODIFIER_NAME]
							FROM
								[Claim].[ClaimDiagnosisCPTModifier] WITH (NOLOCK)
							INNER JOIN
								[Diagnosis].[Modifier] WITH (NOLOCK)
							ON
								[Diagnosis].[Modifier].[ModifierID] = [Claim].[ClaimDiagnosisCPTModifier].[ModifierID]
							WHERE 
								[Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID]
							AND
								[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = 1  
							AND
								[Diagnosis].[Modifier].[IsActive] = 1
							FOR XML AUTO, TYPE
						)
					FROM
						[Claim].[ClaimDiagnosisCPT] WITH (NOLOCK)
					INNER JOIN
						[Claim].[ClaimDiagnosis] WITH (NOLOCK)
					ON
						[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID]
					INNER JOIN
						[Diagnosis].[CPT] WITH (NOLOCK)
					ON
						[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
					INNER JOIN
						[Billing].[FacilityType]
					ON  
						[Billing].[FacilityType].[FacilityTypeID] = [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
					WHERE 
						[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
					AND
						[Claim].[ClaimDiagnosisCPT].[IsActive] = 1
					AND
						[Claim].[ClaimDiagnosis].[IsActive] = 1
					AND
						[Diagnosis].[CPT].[IsActive] = 1
					AND
						[Billing].[FacilityType].[IsActive] = 1
					FOR XML AUTO, TYPE
				)
			FROM
				[Claim].[ClaimDiagnosis] WITH (NOLOCK)
			INNER JOIN
				[Diagnosis].[Diagnosis] WITH (NOLOCK)
			ON
				[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			WHERE 
				[Claim].[ClaimDiagnosis].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			FOR XML AUTO, TYPE
		)
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		[Billing].[Clinic].[ClinicID]  IN
		(SELECT [USER].[UserClinic].[ClinicID] FROM [User].[UserClinic] WITH (NOLOCK) WHERE [User].[UserClinic].[UserID] = @UserID)
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1
	FOR XML AUTO, ROOT('GetXmlReports');
	
	
	-- EXEC [Patient].[usp_GetXmlReport_PatientVisit]  @UserID = 1
END


GO


