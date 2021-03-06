USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_Insert_Provider]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_Insert_Provider]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Billing].[usp_Insert_Provider]
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
	, @CurrentModificationBy BIGINT
	, @ProviderID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @ProviderID = [Billing].[ufn_IsExists_Provider] (@ClinicID, @ProviderCode, @LastName, @MiddleName, @FirstName, @CredentialID, @NPI, @TaxID, @SSN, @IsTaxIDPrimaryOption, @SpecialtyID, @PhotoRelPath, @IsSignedFile, @SignedDate, @LicenseNumber, @CLIANumber, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @SecondaryPhoneNumber, @Email, @SecondaryEmail, @Fax, @Comment, 0);
		
		IF @ProviderID = 0
		BEGIN
			INSERT INTO [Billing].[Provider]
			(
				[ClinicID]
				, [ProviderCode]
				, [LastName]
				, [MiddleName]
				, [FirstName]
				, [CredentialID]
				, [NPI]
				, [TaxID]
				, [SSN]
				, [IsTaxIDPrimaryOption]
				, [SpecialtyID]
				, [PhotoRelPath]
				, [IsSignedFile]
				, [SignedDate]
				, [LicenseNumber]
				, [CLIANumber]
				, [StreetName]
				, [Suite]
				, [CityID]
				, [StateID]
				, [CountyID]
				, [CountryID]
				, [PhoneNumber]
				, [SecondaryPhoneNumber]
				, [Email]
				, [SecondaryEmail]
				, [Fax]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@ClinicID
				, @ProviderCode
				, @LastName
				, @MiddleName
				, @FirstName
				, @CredentialID
				, @NPI
				, @TaxID
				, @SSN
				, @IsTaxIDPrimaryOption
				, @SpecialtyID
				, @PhotoRelPath
				, @IsSignedFile
				, @SignedDate
				, @LicenseNumber
				, @CLIANumber
				, @StreetName
				, @Suite
				, @CityID
				, @StateID
				, @CountyID
				, @CountryID
				, @PhoneNumber
				, @SecondaryPhoneNumber
				, @Email
				, @SecondaryEmail
				, @Fax
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @ProviderID = MAX([Billing].[Provider].[ProviderID]) FROM [Billing].[Provider];
		END
		ELSE
		BEGIN			
			SELECT @ProviderID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @ProviderID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
