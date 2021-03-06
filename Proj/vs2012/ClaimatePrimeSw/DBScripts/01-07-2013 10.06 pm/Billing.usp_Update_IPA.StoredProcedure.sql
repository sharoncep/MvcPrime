USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_Update_IPA]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_Update_IPA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the IPA in the database.
	 
CREATE PROCEDURE [Billing].[usp_Update_IPA]
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
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @IPAID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @IPAID_PREV BIGINT;
		SELECT @IPAID_PREV = [Billing].[ufn_IsExists_IPA] (@IPACode, @IPAName, @NPI, @TaxID, @EntityTypeQualifierID, @LogoRelPath, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @PhoneNumberExtn, @SecondaryPhoneNumber, @SecondaryPhoneNumberExtn, @Email, @SecondaryEmail, @Fax, @ContactPersonLastName, @ContactPersonMiddleName, @ContactPersonFirstName, @ContactPersonPhoneNumber, @ContactPersonPhoneNumberExtn, @ContactPersonSecondaryPhoneNumber, @ContactPersonSecondaryPhoneNumberExtn, @ContactPersonEmail, @ContactPersonSecondaryEmail, @ContactPersonFax, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Billing].[IPA].[IPAID] FROM [Billing].[IPA] WHERE [Billing].[IPA].[IPAID] = @IPAID AND [Billing].[IPA].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@IPAID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Billing].[IPA].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Billing].[IPA].[LastModifiedOn]
			FROM 
				[Billing].[IPA] WITH (NOLOCK)
			WHERE
				[Billing].[IPA].[IPAID] = @IPAID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Billing].[IPAHistory]
					(
						[IPAID]
						, [IPACode]
						, [IPAName]
						, [NPI]
						, [TaxID]
						, [EntityTypeQualifierID]
						, [LogoRelPath]
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
				SELECT
					[Billing].[IPA].[IPAID]
					, [Billing].[IPA].[IPACode]
					, [Billing].[IPA].[IPAName]
					, [Billing].[IPA].[NPI]
					, [Billing].[IPA].[TaxID]
					, [Billing].[IPA].[EntityTypeQualifierID]
					, [Billing].[IPA].[LogoRelPath]
					, [Billing].[IPA].[StreetName]
					, [Billing].[IPA].[Suite]
					, [Billing].[IPA].[CityID]
					, [Billing].[IPA].[StateID]
					, [Billing].[IPA].[CountyID]
					, [Billing].[IPA].[CountryID]
					, [Billing].[IPA].[PhoneNumber]
					, [Billing].[IPA].[PhoneNumberExtn]
					, [Billing].[IPA].[SecondaryPhoneNumber]
					, [Billing].[IPA].[SecondaryPhoneNumberExtn]
					, [Billing].[IPA].[Email]
					, [Billing].[IPA].[SecondaryEmail]
					, [Billing].[IPA].[Fax]
					, [Billing].[IPA].[ContactPersonLastName]
					, [Billing].[IPA].[ContactPersonMiddleName]
					, [Billing].[IPA].[ContactPersonFirstName]
					, [Billing].[IPA].[ContactPersonPhoneNumber]
					, [Billing].[IPA].[ContactPersonPhoneNumberExtn]
					, [Billing].[IPA].[ContactPersonSecondaryPhoneNumber]
					, [Billing].[IPA].[ContactPersonSecondaryPhoneNumberExtn]
					, [Billing].[IPA].[ContactPersonEmail]
					, [Billing].[IPA].[ContactPersonSecondaryEmail]
					, [Billing].[IPA].[ContactPersonFax]
					, [Billing].[IPA].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Billing].[IPA].[IsActive]
				FROM 
					[Billing].[IPA]
				WHERE
					[Billing].[IPA].[IPAID] = @IPAID;
				
				UPDATE 
					[Billing].[IPA]
				SET
					[Billing].[IPA].[IPACode] = @IPACode
					, [Billing].[IPA].[IPAName] = @IPAName
					, [Billing].[IPA].[NPI] = @NPI
					, [Billing].[IPA].[TaxID] = @TaxID
					, [Billing].[IPA].[EntityTypeQualifierID] = @EntityTypeQualifierID
					, [Billing].[IPA].[LogoRelPath] = @LogoRelPath
					, [Billing].[IPA].[StreetName] = @StreetName
					, [Billing].[IPA].[Suite] = @Suite
					, [Billing].[IPA].[CityID] = @CityID
					, [Billing].[IPA].[StateID] = @StateID
					, [Billing].[IPA].[CountyID] = @CountyID
					, [Billing].[IPA].[CountryID] = @CountryID
					, [Billing].[IPA].[PhoneNumber] = @PhoneNumber
					, [Billing].[IPA].[PhoneNumberExtn] = @PhoneNumberExtn
					, [Billing].[IPA].[SecondaryPhoneNumber] = @SecondaryPhoneNumber
					, [Billing].[IPA].[SecondaryPhoneNumberExtn] = @SecondaryPhoneNumberExtn
					, [Billing].[IPA].[Email] = @Email
					, [Billing].[IPA].[SecondaryEmail] = @SecondaryEmail
					, [Billing].[IPA].[Fax] = @Fax
					, [Billing].[IPA].[ContactPersonLastName] = @ContactPersonLastName
					, [Billing].[IPA].[ContactPersonMiddleName] = @ContactPersonMiddleName
					, [Billing].[IPA].[ContactPersonFirstName] = @ContactPersonFirstName
					, [Billing].[IPA].[ContactPersonPhoneNumber] = @ContactPersonPhoneNumber
					, [Billing].[IPA].[ContactPersonPhoneNumberExtn] = @ContactPersonPhoneNumberExtn
					, [Billing].[IPA].[ContactPersonSecondaryPhoneNumber] = @ContactPersonSecondaryPhoneNumber
					, [Billing].[IPA].[ContactPersonSecondaryPhoneNumberExtn] = @ContactPersonSecondaryPhoneNumberExtn
					, [Billing].[IPA].[ContactPersonEmail] = @ContactPersonEmail
					, [Billing].[IPA].[ContactPersonSecondaryEmail] = @ContactPersonSecondaryEmail
					, [Billing].[IPA].[ContactPersonFax] = @ContactPersonFax
					, [Billing].[IPA].[Comment] = @Comment
					, [Billing].[IPA].[LastModifiedBy] = @CurrentModificationBy
					, [Billing].[IPA].[LastModifiedOn] = @CurrentModificationOn
					, [Billing].[IPA].[IsActive] = @IsActive
				WHERE
					[Billing].[IPA].[IPAID] = @IPAID;				
			END
			ELSE
			BEGIN
				SELECT @IPAID = -2;
			END
		END
		ELSE IF @IPAID_PREV <> @IPAID
		BEGIN			
			SELECT @IPAID = -1;			
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
			SELECT @IPAID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
