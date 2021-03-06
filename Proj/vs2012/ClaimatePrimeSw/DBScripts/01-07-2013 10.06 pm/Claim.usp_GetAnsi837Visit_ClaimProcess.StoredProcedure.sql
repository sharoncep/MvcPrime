USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837Visit_ClaimProcess]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetAnsi837Visit_ClaimProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetAnsi837Visit_ClaimProcess]
	@ClinicID INT
	, @EDIReceiverID INT
	, @StatusIDs NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		, [Patient].[PatientVisit].[PatientID]
		, [Patient].[PatientVisit].[PatientHospitalizationID]
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[IllnessIndicatorID]
		, [Patient].[PatientVisit].[IllnessIndicatorDate]
		, [Patient].[PatientVisit].[FacilityTypeID]
		, [Billing].[FacilityType].[FacilityTypeCode]
		, [Patient].[PatientVisit].[FacilityDoneID]
		, [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
		, [Patient].[PatientVisit].[DoctorNoteRelPath]
		, [Patient].[PatientVisit].[SuperBillRelPath]
		, [Patient].[PatientVisit].[PatientVisitDesc]
		, [Patient].[PatientVisit].[ClaimStatusID]
		, [Patient].[PatientVisit].[AssignedTo]
		, [Patient].[PatientVisit].[TargetBAUserID]
		, [Patient].[PatientVisit].[TargetQAUserID]
		, [Patient].[PatientVisit].[TargetEAUserID]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
		, [Patient].[PatientVisit].[Comment]
		, [Patient].[PatientVisit].[IsActive]
		, [Patient].[PatientVisit].[LastModifiedBy]
		, [Patient].[PatientVisit].[LastModifiedOn]
		--
		, [Patient].[Patient].[GroupNumber]
		, [Patient].[Patient].[LastName] AS [PATIENT_LAST_NAME]
		, [Patient].[Patient].[MiddleName] AS [PATIENT_MIDDLE_NAME]
		, [Patient].[Patient].[FirstName] AS [PATIENT_FIRST_NAME]
		, [Patient].[Patient].[StreetName] AS [PATIENT_STREET_NAME]
		, [Patient].[Patient].[Suite] AS [PATIENT_SUITE]
		, [Patient].[Patient].[DOB]
		, [Patient].[Patient].[Sex]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[Patient].[PolicyNumber]
		, [Patient].[Patient].[CityID] AS [PATIENT_CITY_ID]
		, [PATIENT_CITY].[CityName] AS [PATIENT_CITY_NAME]
		, [PATIENT_CITY].[ZipCode] AS [PATIENT_CITY_ZIP_CODE]
		, [Patient].[Patient].[StateID] AS [PATIENT_STATE_ID]
		, [PATIENT_STATE].[StateCode] AS [PATIENT_STATE_CODE]
		, [Patient].[Patient].[CountryID] AS [PATIENT_COUNTRY_ID]
		, [PATIENT_COUNTRY].[CountryCode] AS [PATIENT_COUNTRY_CODE]
		, [Patient].[Patient].[MedicareID]
		--
		, [EDI].[PrintPin].[PrintPinCode]
		--
		, [Billing].[Provider].[LastName] AS [PROVIDER_LAST_NAME]
		, [Billing].[Provider].[MiddleName] AS [PROVIDER_MIDDLE_NAME]
		, [Billing].[Provider].[FirstName] AS [PROVIDER_FIRST_NAME]
		, ((LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], ''))))) AS [PROVIDER_NAME]
		, (CASE WHEN 
				[Billing].[Provider].[IsTaxIDPrimaryOption] = 1 THEN 
				(ISNULL([Billing].[Provider].[TaxID], (ISNULL([Billing].[Provider].[NPI], 'NO_TAX_NPI')))) ELSE 
				(ISNULL([Billing].[Provider].[NPI], (ISNULL([Billing].[Provider].[TaxID], 'NO_NPI_TAX')))) END) 
			AS [PROVIDER_TAX_NPI]
		--
		, [Billing].[Credential].[CredentialCode] AS [PROVIDER_CREDENTIAL_CODE]
		--
		, [Billing].[Specialty].[SpecialtyCode]		
		--
		, [Insurance].[Insurance].[InsuranceName]
		, [Insurance].[Insurance].[PayerID]
		, [Insurance].[Insurance].[CityID] AS [INSURANCE_CITY_ID]
		, [INSURANCE_CITY].[CityName] AS [INSURANCE_CITY_NAME]
		, [INSURANCE_CITY].[ZipCode] AS [INSURANCE_CITY_ZIP_CODE]
		, [Insurance].[Insurance].[StateID] AS [INSURANCE_STATE_ID]
		, [INSURANCE_STATE].[StateCode] AS [INSURANCE_STATE_CODE]
		, [Insurance].[Insurance].[CountryID] AS [INSURANCE_COUNTRY_ID]
		, [INSURANCE_COUNTRY].[CountryCode] AS [INSURANCE_COUNTRY_CODE]
		, [Insurance].[Insurance].[PatientPrintSignID]
		, [Insurance].[Insurance].[StreetName] AS [INSURANCE_STREET_NAME]
		, [Insurance].[Insurance].[Suite] AS [INSURANCE_SUITE]
		--
		, [Insurance].[Relationship].[RelationshipCode]
		--
		, [Insurance].[InsuranceType].[InsuranceTypeCode]
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		[Diagnosis].[IllnessIndicator]
	ON
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorID] = [Patient].[PatientVisit].[IllnessIndicatorID]
	INNER JOIN
		[Billing].[FacilityType]
	ON
		[Billing].[FacilityType].[FacilityTypeID] = [Patient].[PatientVisit].[FacilityTypeID]
	INNER JOIN
		[Billing].[Provider]
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[Insurance].[Insurance]
	ON
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	INNER JOIN
		[Insurance].[Relationship]
	ON
		[Insurance].[Relationship].[RelationshipID] = [Patient].[Patient].[RelationshipID]
	INNER JOIN
		[Billing].[Credential]
	ON
		[Billing].[Credential].[CredentialID] = [Billing].[Provider].[CredentialID]
	INNER JOIN
		[Billing].[Specialty]
	ON
		[Billing].[Specialty].[SpecialtyID] = [Billing].[Provider].[SpecialtyID]
	INNER JOIN
		[Insurance].[InsuranceType]
	ON
		[Insurance].[InsuranceType].[InsuranceTypeID] = [Insurance].[Insurance].[InsuranceTypeID]
	INNER JOIN
		[EDI].[PrintPin]
	ON
		[EDI].[PrintPin].[PrintPinID] = [Insurance].[Insurance].[PrintPinID]
	INNER JOIN
		[MasterData].[City] PATIENT_CITY
	ON
		[PATIENT_CITY].[CityID] = [Patient].[Patient].[CityID]
	INNER JOIN
		[MasterData].[State] PATIENT_STATE
	ON
		[PATIENT_STATE].[StateID] = [Patient].[Patient].[StateID]
	INNER JOIN
		[MasterData].[Country] PATIENT_COUNTRY
	ON
		[PATIENT_COUNTRY].[CountryID] = [Patient].[Patient].[CountryID]
	INNER JOIN
		[MasterData].[City] INSURANCE_CITY
	ON
		[INSURANCE_CITY].[CityID] = [Patient].[Patient].[CityID]
	INNER JOIN
		[MasterData].[State] INSURANCE_STATE
	ON
		[INSURANCE_STATE].[StateID] = [Patient].[Patient].[StateID]
	INNER JOIN
		[MasterData].[Country] INSURANCE_COUNTRY
	ON
		[INSURANCE_COUNTRY].[CountryID] = [Patient].[Patient].[CountryID]
	WHERE
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Insurance].[Insurance].[EDIReceiverID] = @EDIReceiverID
	AND
		[Patient].[PatientVisit].[ClaimStatusID] IN
		(
			SELECT 
				[Data] 
			FROM 
				[dbo].[ufn_StringSplit] (@StatusIDs, ',')
		)
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Diagnosis].[IllnessIndicator].[IsActive] = 1
	AND
		[Billing].[FacilityType].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1
	AND
		[Insurance].[Relationship].[IsActive] = 1
	AND
		[Billing].[Credential].[IsActive] = 1
	AND
		[Billing].[Specialty].[IsActive] = 1
	AND
		[Insurance].[InsuranceType].[IsActive] = 1
	AND
		[EDI].[PrintPin].[IsActive] = 1
	AND
		[PATIENT_CITY].[IsActive] = 1
	AND
		[PATIENT_STATE].[IsActive] = 1
	AND
		[PATIENT_COUNTRY].[IsActive] = 1
	AND
		[INSURANCE_CITY].[IsActive] = 1
	AND
		[INSURANCE_STATE].[IsActive] = 1
	AND
		[INSURANCE_COUNTRY].[IsActive] = 1
	ORDER BY
		[Insurance].[Insurance].[InsuranceName]
	ASC,
		[PROVIDER_NAME]
	ASC,
		[Patient].[PatientVisit].[PatientVisitID]
	ASC;
    
    -- EXEC [Claim].[usp_GetAnsi837Visit_ClaimProcess] @ClinicID = 1, @EDIReceiverID = 1, @StatusIDs = '16, 17, 18, 19, 20'
END
GO
