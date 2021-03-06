USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_IsExists_Insurance]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_IsExists_Insurance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Insurance].[usp_IsExists_Insurance]
	@InsuranceCode NVARCHAR(15)
	, @InsuranceName NVARCHAR(150)
	, @PayerID NVARCHAR(15)
	, @InsuranceTypeID TINYINT
	, @EDIReceiverID INT
	, @PrintPinID TINYINT
	, @PatientPrintSignID TINYINT
	, @InsuredPrintSignID TINYINT
	, @PhysicianPrintSignID TINYINT
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
	, @Email NVARCHAR(256) = NULL
	, @SecondaryEmail NVARCHAR(256) = NULL
	, @Fax NVARCHAR(13) = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @InsuranceID	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @InsuranceID = [Insurance].[ufn_IsExists_Insurance] (@InsuranceCode, @InsuranceName, @PayerID, @InsuranceTypeID, @EDIReceiverID, @PrintPinID, @PatientPrintSignID, @InsuredPrintSignID, @PhysicianPrintSignID, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @PhoneNumberExtn, @SecondaryPhoneNumber, @SecondaryPhoneNumberExtn, @Email, @SecondaryEmail, @Fax, @Comment, 0);
END
GO
