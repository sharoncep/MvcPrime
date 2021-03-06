USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_Update_Clinic]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_Update_Clinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Clinic in the database.
	 
CREATE PROCEDURE [Billing].[usp_Update_Clinic]
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
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @ClinicID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @ClinicID_PREV BIGINT;
		SELECT @ClinicID_PREV = [Billing].[ufn_IsExists_Clinic] (@IPAID, @ClinicCode, @ClinicName, @NPI, @TaxID, @EntityTypeQualifierID, @SpecialtyID, @ICDFormat, @LogoRelPath, @IsPatientDemographicsPull, @IsPatVisitDocManadatory, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @PhoneNumberExtn, @SecondaryPhoneNumber, @SecondaryPhoneNumberExtn, @Email, @SecondaryEmail, @Fax, @ContactPersonLastName, @ContactPersonMiddleName, @ContactPersonFirstName, @ContactPersonPhoneNumber, @ContactPersonPhoneNumberExtn, @ContactPersonSecondaryPhoneNumber, @ContactPersonSecondaryPhoneNumberExtn, @ContactPersonEmail, @ContactPersonSecondaryEmail, @ContactPersonFax, @PatientVisitComplexity, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Billing].[Clinic].[ClinicID] FROM [Billing].[Clinic] WHERE [Billing].[Clinic].[ClinicID] = @ClinicID AND [Billing].[Clinic].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@ClinicID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Billing].[Clinic].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Billing].[Clinic].[LastModifiedOn]
			FROM 
				[Billing].[Clinic] WITH (NOLOCK)
			WHERE
				[Billing].[Clinic].[ClinicID] = @ClinicID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Billing].[ClinicHistory]
					(
						[ClinicID]
						, [IPAID]
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
				SELECT
					[Billing].[Clinic].[ClinicID]
					, [Billing].[Clinic].[IPAID]
					, [Billing].[Clinic].[ClinicCode]
					, [Billing].[Clinic].[ClinicName]
					, [Billing].[Clinic].[NPI]
					, [Billing].[Clinic].[TaxID]
					, [Billing].[Clinic].[EntityTypeQualifierID]
					, [Billing].[Clinic].[SpecialtyID]
					, [Billing].[Clinic].[ICDFormat]
					, [Billing].[Clinic].[LogoRelPath]
					, [Billing].[Clinic].[IsPatientDemographicsPull]
					, [Billing].[Clinic].[IsPatVisitDocManadatory]
					, [Billing].[Clinic].[StreetName]
					, [Billing].[Clinic].[Suite]
					, [Billing].[Clinic].[CityID]
					, [Billing].[Clinic].[StateID]
					, [Billing].[Clinic].[CountyID]
					, [Billing].[Clinic].[CountryID]
					, [Billing].[Clinic].[PhoneNumber]
					, [Billing].[Clinic].[PhoneNumberExtn]
					, [Billing].[Clinic].[SecondaryPhoneNumber]
					, [Billing].[Clinic].[SecondaryPhoneNumberExtn]
					, [Billing].[Clinic].[Email]
					, [Billing].[Clinic].[SecondaryEmail]
					, [Billing].[Clinic].[Fax]
					, [Billing].[Clinic].[ContactPersonLastName]
					, [Billing].[Clinic].[ContactPersonMiddleName]
					, [Billing].[Clinic].[ContactPersonFirstName]
					, [Billing].[Clinic].[ContactPersonPhoneNumber]
					, [Billing].[Clinic].[ContactPersonPhoneNumberExtn]
					, [Billing].[Clinic].[ContactPersonSecondaryPhoneNumber]
					, [Billing].[Clinic].[ContactPersonSecondaryPhoneNumberExtn]
					, [Billing].[Clinic].[ContactPersonEmail]
					, [Billing].[Clinic].[ContactPersonSecondaryEmail]
					, [Billing].[Clinic].[ContactPersonFax]
					, [Billing].[Clinic].[PatientVisitComplexity]
					, [Billing].[Clinic].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Billing].[Clinic].[IsActive]
				FROM 
					[Billing].[Clinic]
				WHERE
					[Billing].[Clinic].[ClinicID] = @ClinicID;
				
				UPDATE 
					[Billing].[Clinic]
				SET
					[Billing].[Clinic].[IPAID] = @IPAID
					, [Billing].[Clinic].[ClinicCode] = @ClinicCode
					, [Billing].[Clinic].[ClinicName] = @ClinicName
					, [Billing].[Clinic].[NPI] = @NPI
					, [Billing].[Clinic].[TaxID] = @TaxID
					, [Billing].[Clinic].[EntityTypeQualifierID] = @EntityTypeQualifierID
					, [Billing].[Clinic].[SpecialtyID] = @SpecialtyID
					, [Billing].[Clinic].[ICDFormat] = @ICDFormat
					, [Billing].[Clinic].[LogoRelPath] = @LogoRelPath
					, [Billing].[Clinic].[IsPatientDemographicsPull] = @IsPatientDemographicsPull
					, [Billing].[Clinic].[IsPatVisitDocManadatory] = @IsPatVisitDocManadatory
					, [Billing].[Clinic].[StreetName] = @StreetName
					, [Billing].[Clinic].[Suite] = @Suite
					, [Billing].[Clinic].[CityID] = @CityID
					, [Billing].[Clinic].[StateID] = @StateID
					, [Billing].[Clinic].[CountyID] = @CountyID
					, [Billing].[Clinic].[CountryID] = @CountryID
					, [Billing].[Clinic].[PhoneNumber] = @PhoneNumber
					, [Billing].[Clinic].[PhoneNumberExtn] = @PhoneNumberExtn
					, [Billing].[Clinic].[SecondaryPhoneNumber] = @SecondaryPhoneNumber
					, [Billing].[Clinic].[SecondaryPhoneNumberExtn] = @SecondaryPhoneNumberExtn
					, [Billing].[Clinic].[Email] = @Email
					, [Billing].[Clinic].[SecondaryEmail] = @SecondaryEmail
					, [Billing].[Clinic].[Fax] = @Fax
					, [Billing].[Clinic].[ContactPersonLastName] = @ContactPersonLastName
					, [Billing].[Clinic].[ContactPersonMiddleName] = @ContactPersonMiddleName
					, [Billing].[Clinic].[ContactPersonFirstName] = @ContactPersonFirstName
					, [Billing].[Clinic].[ContactPersonPhoneNumber] = @ContactPersonPhoneNumber
					, [Billing].[Clinic].[ContactPersonPhoneNumberExtn] = @ContactPersonPhoneNumberExtn
					, [Billing].[Clinic].[ContactPersonSecondaryPhoneNumber] = @ContactPersonSecondaryPhoneNumber
					, [Billing].[Clinic].[ContactPersonSecondaryPhoneNumberExtn] = @ContactPersonSecondaryPhoneNumberExtn
					, [Billing].[Clinic].[ContactPersonEmail] = @ContactPersonEmail
					, [Billing].[Clinic].[ContactPersonSecondaryEmail] = @ContactPersonSecondaryEmail
					, [Billing].[Clinic].[ContactPersonFax] = @ContactPersonFax
					, [Billing].[Clinic].[PatientVisitComplexity] = @PatientVisitComplexity
					, [Billing].[Clinic].[Comment] = @Comment
					, [Billing].[Clinic].[LastModifiedBy] = @CurrentModificationBy
					, [Billing].[Clinic].[LastModifiedOn] = @CurrentModificationOn
					, [Billing].[Clinic].[IsActive] = @IsActive
				WHERE
					[Billing].[Clinic].[ClinicID] = @ClinicID;				
			END
			ELSE
			BEGIN
				SELECT @ClinicID = -2;
			END
		END
		ELSE IF @ClinicID_PREV <> @ClinicID
		BEGIN			
			SELECT @ClinicID = -1;			
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
			SELECT @ClinicID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
