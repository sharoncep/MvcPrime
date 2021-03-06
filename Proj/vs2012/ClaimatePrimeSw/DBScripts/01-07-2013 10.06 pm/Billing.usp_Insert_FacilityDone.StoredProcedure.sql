USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_Insert_FacilityDone]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_Insert_FacilityDone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Billing].[usp_Insert_FacilityDone]
	@FacilityDoneCode NVARCHAR(5)
	, @FacilityDoneName NVARCHAR(40)
	, @NPI NVARCHAR(10) = NULL
	, @TaxID NVARCHAR(9) = NULL
	, @FacilityTypeID TINYINT
	, @StreetName NVARCHAR(500) = NULL
	, @Suite NVARCHAR(500) = NULL
	, @CityID INT = NULL
	, @StateID INT = NULL
	, @CountyID INT = NULL
	, @CountryID INT = NULL
	, @PhoneNumber NVARCHAR(13) = NULL
	, @PhoneNumberExtn INT = NULL
	, @SecondaryPhoneNumber NVARCHAR(13) = NULL
	, @SecondaryPhoneNumberExtn INT = NULL
	, @Email NVARCHAR(256) = NULL
	, @SecondaryEmail NVARCHAR(256) = NULL
	, @Fax NVARCHAR(13) = NULL
	, @ContactPersonLastName NVARCHAR(150) = NULL
	, @ContactPersonMiddleName NVARCHAR(50) = NULL
	, @ContactPersonFirstName NVARCHAR(150) = NULL
	, @ContactPersonPhoneNumber NVARCHAR(13) = NULL
	, @ContactPersonPhoneNumberExtn INT = NULL
	, @ContactPersonSecondaryPhoneNumber NVARCHAR(13) = NULL
	, @ContactPersonSecondaryPhoneNumberExtn INT = NULL
	, @ContactPersonEmail NVARCHAR(256) = NULL
	, @ContactPersonSecondaryEmail NVARCHAR(256) = NULL
	, @ContactPersonFax NVARCHAR(13) = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @FacilityDoneID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @FacilityDoneID = [Billing].[ufn_IsExists_FacilityDone] (@FacilityDoneCode, @FacilityDoneName, @NPI, @TaxID, @FacilityTypeID, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @PhoneNumberExtn, @SecondaryPhoneNumber, @SecondaryPhoneNumberExtn, @Email, @SecondaryEmail, @Fax, @ContactPersonLastName, @ContactPersonMiddleName, @ContactPersonFirstName, @ContactPersonPhoneNumber, @ContactPersonPhoneNumberExtn, @ContactPersonSecondaryPhoneNumber, @ContactPersonSecondaryPhoneNumberExtn, @ContactPersonEmail, @ContactPersonSecondaryEmail, @ContactPersonFax, @Comment, 0);
		
		IF @FacilityDoneID = 0
		BEGIN
			INSERT INTO [Billing].[FacilityDone]
			(
				[FacilityDoneCode]
				, [FacilityDoneName]
				, [NPI]
				, [TaxID]
				, [FacilityTypeID]
				, [StreetName]
				, [Suite]
				, [CityID]
				, [StateID]
				, [CountyID]
				, [CountryID]
				, [PhoneNumber]
				, [PhoneNumberExtn]
				, [SecondaryPhoneNumber]
				, [SecondaryPhoneNumberExtn]
				, [Email]
				, [SecondaryEmail]
				, [Fax]
				, [ContactPersonLastName]
				, [ContactPersonMiddleName]
				, [ContactPersonFirstName]
				, [ContactPersonPhoneNumber]
				, [ContactPersonPhoneNumberExtn]
				, [ContactPersonSecondaryPhoneNumber]
				, [ContactPersonSecondaryPhoneNumberExtn]
				, [ContactPersonEmail]
				, [ContactPersonSecondaryEmail]
				, [ContactPersonFax]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@FacilityDoneCode
				, @FacilityDoneName
				, @NPI
				, @TaxID
				, @FacilityTypeID
				, @StreetName
				, @Suite
				, @CityID
				, @StateID
				, @CountyID
				, @CountryID
				, @PhoneNumber
				, @PhoneNumberExtn
				, @SecondaryPhoneNumber
				, @SecondaryPhoneNumberExtn
				, @Email
				, @SecondaryEmail
				, @Fax
				, @ContactPersonLastName
				, @ContactPersonMiddleName
				, @ContactPersonFirstName
				, @ContactPersonPhoneNumber
				, @ContactPersonPhoneNumberExtn
				, @ContactPersonSecondaryPhoneNumber
				, @ContactPersonSecondaryPhoneNumberExtn
				, @ContactPersonEmail
				, @ContactPersonSecondaryEmail
				, @ContactPersonFax
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @FacilityDoneID = MAX([Billing].[FacilityDone].[FacilityDoneID]) FROM [Billing].[FacilityDone];
		END
		ELSE
		BEGIN			
			SELECT @FacilityDoneID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @FacilityDoneID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
