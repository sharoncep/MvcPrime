USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_Insert_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_Insert_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Billing].[usp_Insert_Clinic]
	@IPAID INT
	, @ClinicCode NVARCHAR(7)
	, @ClinicName NVARCHAR(40)
	, @NPI NVARCHAR(10) = NULL
	, @TaxID NVARCHAR(9) = NULL
	, @EntityTypeQualifierID TINYINT
	, @SpecialtyID TINYINT
	, @ICDFormat TINYINT
	, @LogoRelPath NVARCHAR(350) = NULL
	, @IsPatientDemographicsPull BIT
	, @IsPatVisitDocManadatory BIT
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
	, @PatientVisitComplexity TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @ClinicID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @ClinicID = [Billing].[ufn_IsExists_Clinic] (@IPAID, @ClinicCode, @ClinicName, @NPI, @TaxID, @EntityTypeQualifierID, @SpecialtyID, @ICDFormat, @LogoRelPath, @IsPatientDemographicsPull, @IsPatVisitDocManadatory, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @PhoneNumberExtn, @SecondaryPhoneNumber, @SecondaryPhoneNumberExtn, @Email, @SecondaryEmail, @Fax, @ContactPersonLastName, @ContactPersonMiddleName, @ContactPersonFirstName, @ContactPersonPhoneNumber, @ContactPersonPhoneNumberExtn, @ContactPersonSecondaryPhoneNumber, @ContactPersonSecondaryPhoneNumberExtn, @ContactPersonEmail, @ContactPersonSecondaryEmail, @ContactPersonFax, @PatientVisitComplexity, @Comment, 0);
		
		IF @ClinicID = 0
		BEGIN
			INSERT INTO [Billing].[Clinic]
			(
				[IPAID]
				, [ClinicCode]
				, [ClinicName]
				, [NPI]
				, [TaxID]
				, [EntityTypeQualifierID]
				, [SpecialtyID]
				, [ICDFormat]
				, [LogoRelPath]
				, [IsPatientDemographicsPull]
				, [IsPatVisitDocManadatory]
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
				, [PatientVisitComplexity]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@IPAID
				, @ClinicCode
				, @ClinicName
				, @NPI
				, @TaxID
				, @EntityTypeQualifierID
				, @SpecialtyID
				, @ICDFormat
				, @LogoRelPath
				, @IsPatientDemographicsPull
				, @IsPatVisitDocManadatory
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
				, @PatientVisitComplexity
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @ClinicID = MAX([Billing].[Clinic].[ClinicID]) FROM [Billing].[Clinic];
		END
		ELSE
		BEGIN			
			SELECT @ClinicID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @ClinicID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
