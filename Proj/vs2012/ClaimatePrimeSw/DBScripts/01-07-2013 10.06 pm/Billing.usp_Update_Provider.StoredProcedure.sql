USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_Update_Provider]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_Update_Provider]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Provider in the database.
	 
CREATE PROCEDURE [Billing].[usp_Update_Provider]
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
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @ProviderID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @ProviderID_PREV BIGINT;
		SELECT @ProviderID_PREV = [Billing].[ufn_IsExists_Provider] (@ClinicID, @ProviderCode, @LastName, @MiddleName, @FirstName, @CredentialID, @NPI, @TaxID, @SSN, @IsTaxIDPrimaryOption, @SpecialtyID, @PhotoRelPath, @IsSignedFile, @SignedDate, @LicenseNumber, @CLIANumber, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @SecondaryPhoneNumber, @Email, @SecondaryEmail, @Fax, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Billing].[Provider].[ProviderID] FROM [Billing].[Provider] WHERE [Billing].[Provider].[ProviderID] = @ProviderID AND [Billing].[Provider].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@ProviderID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Billing].[Provider].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Billing].[Provider].[LastModifiedOn]
			FROM 
				[Billing].[Provider] WITH (NOLOCK)
			WHERE
				[Billing].[Provider].[ProviderID] = @ProviderID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Billing].[ProviderHistory]
					(
						[ProviderID]
						, [ClinicID]
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
				SELECT
					[Billing].[Provider].[ProviderID]
					, [Billing].[Provider].[ClinicID]
					, [Billing].[Provider].[ProviderCode]
					, [Billing].[Provider].[LastName]
					, [Billing].[Provider].[MiddleName]
					, [Billing].[Provider].[FirstName]
					, [Billing].[Provider].[CredentialID]
					, [Billing].[Provider].[NPI]
					, [Billing].[Provider].[TaxID]
					, [Billing].[Provider].[SSN]
					, [Billing].[Provider].[IsTaxIDPrimaryOption]
					, [Billing].[Provider].[SpecialtyID]
					, [Billing].[Provider].[PhotoRelPath]
					, [Billing].[Provider].[IsSignedFile]
					, [Billing].[Provider].[SignedDate]
					, [Billing].[Provider].[LicenseNumber]
					, [Billing].[Provider].[CLIANumber]
					, [Billing].[Provider].[StreetName]
					, [Billing].[Provider].[Suite]
					, [Billing].[Provider].[CityID]
					, [Billing].[Provider].[StateID]
					, [Billing].[Provider].[CountyID]
					, [Billing].[Provider].[CountryID]
					, [Billing].[Provider].[PhoneNumber]
					, [Billing].[Provider].[SecondaryPhoneNumber]
					, [Billing].[Provider].[Email]
					, [Billing].[Provider].[SecondaryEmail]
					, [Billing].[Provider].[Fax]
					, [Billing].[Provider].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Billing].[Provider].[IsActive]
				FROM 
					[Billing].[Provider]
				WHERE
					[Billing].[Provider].[ProviderID] = @ProviderID;
				
				UPDATE 
					[Billing].[Provider]
				SET
					[Billing].[Provider].[ClinicID] = @ClinicID
					, [Billing].[Provider].[ProviderCode] = @ProviderCode
					, [Billing].[Provider].[LastName] = @LastName
					, [Billing].[Provider].[MiddleName] = @MiddleName
					, [Billing].[Provider].[FirstName] = @FirstName
					, [Billing].[Provider].[CredentialID] = @CredentialID
					, [Billing].[Provider].[NPI] = @NPI
					, [Billing].[Provider].[TaxID] = @TaxID
					, [Billing].[Provider].[SSN] = @SSN
					, [Billing].[Provider].[IsTaxIDPrimaryOption] = @IsTaxIDPrimaryOption
					, [Billing].[Provider].[SpecialtyID] = @SpecialtyID
					, [Billing].[Provider].[PhotoRelPath] = @PhotoRelPath
					, [Billing].[Provider].[IsSignedFile] = @IsSignedFile
					, [Billing].[Provider].[SignedDate] = @SignedDate
					, [Billing].[Provider].[LicenseNumber] = @LicenseNumber
					, [Billing].[Provider].[CLIANumber] = @CLIANumber
					, [Billing].[Provider].[StreetName] = @StreetName
					, [Billing].[Provider].[Suite] = @Suite
					, [Billing].[Provider].[CityID] = @CityID
					, [Billing].[Provider].[StateID] = @StateID
					, [Billing].[Provider].[CountyID] = @CountyID
					, [Billing].[Provider].[CountryID] = @CountryID
					, [Billing].[Provider].[PhoneNumber] = @PhoneNumber
					, [Billing].[Provider].[SecondaryPhoneNumber] = @SecondaryPhoneNumber
					, [Billing].[Provider].[Email] = @Email
					, [Billing].[Provider].[SecondaryEmail] = @SecondaryEmail
					, [Billing].[Provider].[Fax] = @Fax
					, [Billing].[Provider].[Comment] = @Comment
					, [Billing].[Provider].[LastModifiedBy] = @CurrentModificationBy
					, [Billing].[Provider].[LastModifiedOn] = @CurrentModificationOn
					, [Billing].[Provider].[IsActive] = @IsActive
				WHERE
					[Billing].[Provider].[ProviderID] = @ProviderID;				
			END
			ELSE
			BEGIN
				SELECT @ProviderID = -2;
			END
		END
		ELSE IF @ProviderID_PREV <> @ProviderID
		BEGIN			
			SELECT @ProviderID = -1;			
		END
		-- ELSE
		-- BEGIN
		--	 SELECT @CurrentModificationOn = @LastModifiedOn;
		-- END
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
