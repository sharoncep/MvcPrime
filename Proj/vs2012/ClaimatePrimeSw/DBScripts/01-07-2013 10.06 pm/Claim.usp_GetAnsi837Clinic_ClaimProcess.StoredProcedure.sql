USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837Clinic_ClaimProcess]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetAnsi837Clinic_ClaimProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetAnsi837Clinic_ClaimProcess]
	@ClinicID INT
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT
		[Billing].[Clinic].[ClinicID]
		, [Billing].[Clinic].[ClinicCode]
		, [Billing].[Clinic].[ClinicName]
		, [Billing].[Clinic].[ContactPersonLastName]
		, [Billing].[Clinic].[ContactPersonFirstName]
		, [Billing].[Clinic].[ContactPersonMiddleName]
		, [Billing].[Clinic].[ContactPersonEmail]
		, [Billing].[Clinic].[ContactPersonPhoneNumber]
		, [Billing].[Clinic].[ContactPersonFax]
		, [Billing].[Clinic].[NPI] AS [CLINIC_NPI]
		, [Billing].[Clinic].[TaxID] AS [CLINIC_TAX_ID]
		
		, [Billing].[IPA].[IPAName]
		, [Billing].[IPA].[NPI] AS [IPA_NPI]
		, [Billing].[IPA].[StreetName]
		, [Billing].[IPA].[TaxID] AS [IPA_TAX_ID]
		, [CLINIC_ENTITY_TYPE].[EntityTypeQualifierCode] AS [ClinicEntityTypeQualifierCode]
		, [IPA_ENTITY_TYPE].[EntityTypeQualifierCode] AS [IPAEntityTypeQualifierCode]
		, [MasterData].[City].[CityName] AS [IPACityName]
		, [MasterData].[City].[ZipCode] AS [IPAZipCode]
		, [MasterData].[State].[StateCode] AS [IPAStateCode]
		, [MasterData].[Country].[CountryCode] AS [IPACountryCode]
		
	FROM
		[Billing].[Clinic]
	INNER JOIN
		[Billing].[IPA]
	ON
		[Billing].[IPA].[IPAID] = [Billing].[Clinic].[IPAID]
	INNER JOIN
		[Transaction].[EntityTypeQualifier] CLINIC_ENTITY_TYPE
	ON
		[CLINIC_ENTITY_TYPE].[EntityTypeQualifierID] = [Billing].[Clinic].[EntityTypeQualifierID]
	INNER JOIN
		[Transaction].[EntityTypeQualifier] IPA_ENTITY_TYPE
	ON
		[IPA_ENTITY_TYPE].[EntityTypeQualifierID] = [Billing].[IPA].[EntityTypeQualifierID]
	INNER JOIN
		[MasterData].[City]
	ON
		[MasterData].[City].[CityID] = [Billing].[IPA].[CityID]
	INNER JOIN
		[MasterData].[State]
	ON
		[MasterData].[State].[StateID] = [Billing].[IPA].[StateID]
	INNER JOIN
		[MasterData].[Country]
	ON
		[MasterData].[Country].[CountryID] = [Billing].[IPA].[CountryID]
	WHERE
		[Billing].[Clinic].[ClinicID] = @ClinicID
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[IPA].[IsActive] = 1
	AND
		[CLINIC_ENTITY_TYPE].[IsActive] = 1
	AND
		[IPA_ENTITY_TYPE].[IsActive] = 1
	AND
		[MasterData].[City].[IsActive] = 1
	AND
		[MasterData].[State].[IsActive] = 1
	AND
		[MasterData].[Country].[IsActive] = 1
		
	-- EXEC [Claim].[usp_GetAnsi837Clinic_ClaimProcess] 1
END
GO
