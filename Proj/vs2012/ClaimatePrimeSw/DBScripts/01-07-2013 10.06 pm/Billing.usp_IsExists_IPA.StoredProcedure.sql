USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_IsExists_IPA]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_IsExists_IPA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Billing].[usp_IsExists_IPA]
	@IPACode NVARCHAR(5)
	, @IPAName NVARCHAR(40)
	, @NPI NVARCHAR(10) = NULL
	, @TaxID NVARCHAR(9) = NULL
	, @EntityTypeQualifierID TINYINT
	, @LogoRelPath NVARCHAR(350) = NULL
	, @StreetName NVARCHAR(500)
	, @Suite NVARCHAR(500) = NULL
	, @CityID INT
	, @StateID INT
	, @CountyID INT = NULL
	, @CountryID INT
	, @PhoneNumber NVARCHAR(13)
	, @PhoneNumberExtn INT = NULL
	, @SecondaryPhoneNumber NVARCHAR(13) = NULL
	, @SecondaryPhoneNumberExtn INT = NULL
	, @Email NVARCHAR(256)
	, @SecondaryEmail NVARCHAR(256) = NULL
	, @Fax NVARCHAR(13) = NULL
	, @ContactPersonLastName NVARCHAR(150)
	, @ContactPersonMiddleName NVARCHAR(50) = NULL
	, @ContactPersonFirstName NVARCHAR(150)
	, @ContactPersonPhoneNumber NVARCHAR(13)
	, @ContactPersonPhoneNumberExtn INT = NULL
	, @ContactPersonSecondaryPhoneNumber NVARCHAR(13) = NULL
	, @ContactPersonSecondaryPhoneNumberExtn INT = NULL
	, @ContactPersonEmail NVARCHAR(256)
	, @ContactPersonSecondaryEmail NVARCHAR(256) = NULL
	, @ContactPersonFax NVARCHAR(13) = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @IPAID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @IPAID = [Billing].[ufn_IsExists_IPA] (@IPACode, @IPAName, @NPI, @TaxID, @EntityTypeQualifierID, @LogoRelPath, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @PhoneNumberExtn, @SecondaryPhoneNumber, @SecondaryPhoneNumberExtn, @Email, @SecondaryEmail, @Fax, @ContactPersonLastName, @ContactPersonMiddleName, @ContactPersonFirstName, @ContactPersonPhoneNumber, @ContactPersonPhoneNumberExtn, @ContactPersonSecondaryPhoneNumber, @ContactPersonSecondaryPhoneNumberExtn, @ContactPersonEmail, @ContactPersonSecondaryEmail, @ContactPersonFax, @Comment, 0);
END
GO
