USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_IsExists_Provider]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_IsExists_Provider]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Billing].[usp_IsExists_Provider]
	@ClinicID INT
	, @ProviderCode NVARCHAR(9)
	, @LastName NVARCHAR(150)
	, @MiddleName NVARCHAR(50) = NULL
	, @FirstName NVARCHAR(150)
	, @CredentialID TINYINT
	, @NPI NVARCHAR(10) = NULL
	, @TaxID NVARCHAR(9) = NULL
	, @SSN NVARCHAR(20) = NULL
	, @IsTaxIDPrimaryOption BIT
	, @SpecialtyID TINYINT
	, @PhotoRelPath NVARCHAR(350) = NULL
	, @IsSignedFile BIT
	, @SignedDate DATE = NULL
	, @LicenseNumber NVARCHAR(25) = NULL
	, @CLIANumber NVARCHAR(25) = NULL
	, @StreetName NVARCHAR(500)
	, @Suite NVARCHAR(500) = NULL
	, @CityID INT
	, @StateID INT
	, @CountyID INT = NULL
	, @CountryID INT
	, @PhoneNumber NVARCHAR(13)
	, @SecondaryPhoneNumber NVARCHAR(13) = NULL
	, @Email NVARCHAR(256)
	, @SecondaryEmail NVARCHAR(256) = NULL
	, @Fax NVARCHAR(13) = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @ProviderID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @ProviderID = [Billing].[ufn_IsExists_Provider] (@ClinicID, @ProviderCode, @LastName, @MiddleName, @FirstName, @CredentialID, @NPI, @TaxID, @SSN, @IsTaxIDPrimaryOption, @SpecialtyID, @PhotoRelPath, @IsSignedFile, @SignedDate, @LicenseNumber, @CLIANumber, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @SecondaryPhoneNumber, @Email, @SecondaryEmail, @Fax, @Comment, 0);
END
GO
