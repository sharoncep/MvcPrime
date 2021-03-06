USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_Update_FacilityDone]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_Update_FacilityDone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the FacilityDone in the database.
	 
CREATE PROCEDURE [Billing].[usp_Update_FacilityDone]
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
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @FacilityDoneID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @FacilityDoneID_PREV BIGINT;
		SELECT @FacilityDoneID_PREV = [Billing].[ufn_IsExists_FacilityDone] (@FacilityDoneCode, @FacilityDoneName, @NPI, @TaxID, @FacilityTypeID, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @PhoneNumberExtn, @SecondaryPhoneNumber, @SecondaryPhoneNumberExtn, @Email, @SecondaryEmail, @Fax, @ContactPersonLastName, @ContactPersonMiddleName, @ContactPersonFirstName, @ContactPersonPhoneNumber, @ContactPersonPhoneNumberExtn, @ContactPersonSecondaryPhoneNumber, @ContactPersonSecondaryPhoneNumberExtn, @ContactPersonEmail, @ContactPersonSecondaryEmail, @ContactPersonFax, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Billing].[FacilityDone].[FacilityDoneID] FROM [Billing].[FacilityDone] WHERE [Billing].[FacilityDone].[FacilityDoneID] = @FacilityDoneID AND [Billing].[FacilityDone].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@FacilityDoneID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Billing].[FacilityDone].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Billing].[FacilityDone].[LastModifiedOn]
			FROM 
				[Billing].[FacilityDone] WITH (NOLOCK)
			WHERE
				[Billing].[FacilityDone].[FacilityDoneID] = @FacilityDoneID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Billing].[FacilityDoneHistory]
					(
						[FacilityDoneID]
						, [FacilityDoneCode]
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
				SELECT
					[Billing].[FacilityDone].[FacilityDoneID]
					, [Billing].[FacilityDone].[FacilityDoneCode]
					, [Billing].[FacilityDone].[FacilityDoneName]
					, [Billing].[FacilityDone].[NPI]
					, [Billing].[FacilityDone].[TaxID]
					, [Billing].[FacilityDone].[FacilityTypeID]
					, [Billing].[FacilityDone].[StreetName]
					, [Billing].[FacilityDone].[Suite]
					, [Billing].[FacilityDone].[CityID]
					, [Billing].[FacilityDone].[StateID]
					, [Billing].[FacilityDone].[CountyID]
					, [Billing].[FacilityDone].[CountryID]
					, [Billing].[FacilityDone].[PhoneNumber]
					, [Billing].[FacilityDone].[PhoneNumberExtn]
					, [Billing].[FacilityDone].[SecondaryPhoneNumber]
					, [Billing].[FacilityDone].[SecondaryPhoneNumberExtn]
					, [Billing].[FacilityDone].[Email]
					, [Billing].[FacilityDone].[SecondaryEmail]
					, [Billing].[FacilityDone].[Fax]
					, [Billing].[FacilityDone].[ContactPersonLastName]
					, [Billing].[FacilityDone].[ContactPersonMiddleName]
					, [Billing].[FacilityDone].[ContactPersonFirstName]
					, [Billing].[FacilityDone].[ContactPersonPhoneNumber]
					, [Billing].[FacilityDone].[ContactPersonPhoneNumberExtn]
					, [Billing].[FacilityDone].[ContactPersonSecondaryPhoneNumber]
					, [Billing].[FacilityDone].[ContactPersonSecondaryPhoneNumberExtn]
					, [Billing].[FacilityDone].[ContactPersonEmail]
					, [Billing].[FacilityDone].[ContactPersonSecondaryEmail]
					, [Billing].[FacilityDone].[ContactPersonFax]
					, [Billing].[FacilityDone].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Billing].[FacilityDone].[IsActive]
				FROM 
					[Billing].[FacilityDone]
				WHERE
					[Billing].[FacilityDone].[FacilityDoneID] = @FacilityDoneID;
				
				UPDATE 
					[Billing].[FacilityDone]
				SET
					[Billing].[FacilityDone].[FacilityDoneCode] = @FacilityDoneCode
					, [Billing].[FacilityDone].[FacilityDoneName] = @FacilityDoneName
					, [Billing].[FacilityDone].[NPI] = @NPI
					, [Billing].[FacilityDone].[TaxID] = @TaxID
					, [Billing].[FacilityDone].[FacilityTypeID] = @FacilityTypeID
					, [Billing].[FacilityDone].[StreetName] = @StreetName
					, [Billing].[FacilityDone].[Suite] = @Suite
					, [Billing].[FacilityDone].[CityID] = @CityID
					, [Billing].[FacilityDone].[StateID] = @StateID
					, [Billing].[FacilityDone].[CountyID] = @CountyID
					, [Billing].[FacilityDone].[CountryID] = @CountryID
					, [Billing].[FacilityDone].[PhoneNumber] = @PhoneNumber
					, [Billing].[FacilityDone].[PhoneNumberExtn] = @PhoneNumberExtn
					, [Billing].[FacilityDone].[SecondaryPhoneNumber] = @SecondaryPhoneNumber
					, [Billing].[FacilityDone].[SecondaryPhoneNumberExtn] = @SecondaryPhoneNumberExtn
					, [Billing].[FacilityDone].[Email] = @Email
					, [Billing].[FacilityDone].[SecondaryEmail] = @SecondaryEmail
					, [Billing].[FacilityDone].[Fax] = @Fax
					, [Billing].[FacilityDone].[ContactPersonLastName] = @ContactPersonLastName
					, [Billing].[FacilityDone].[ContactPersonMiddleName] = @ContactPersonMiddleName
					, [Billing].[FacilityDone].[ContactPersonFirstName] = @ContactPersonFirstName
					, [Billing].[FacilityDone].[ContactPersonPhoneNumber] = @ContactPersonPhoneNumber
					, [Billing].[FacilityDone].[ContactPersonPhoneNumberExtn] = @ContactPersonPhoneNumberExtn
					, [Billing].[FacilityDone].[ContactPersonSecondaryPhoneNumber] = @ContactPersonSecondaryPhoneNumber
					, [Billing].[FacilityDone].[ContactPersonSecondaryPhoneNumberExtn] = @ContactPersonSecondaryPhoneNumberExtn
					, [Billing].[FacilityDone].[ContactPersonEmail] = @ContactPersonEmail
					, [Billing].[FacilityDone].[ContactPersonSecondaryEmail] = @ContactPersonSecondaryEmail
					, [Billing].[FacilityDone].[ContactPersonFax] = @ContactPersonFax
					, [Billing].[FacilityDone].[Comment] = @Comment
					, [Billing].[FacilityDone].[LastModifiedBy] = @CurrentModificationBy
					, [Billing].[FacilityDone].[LastModifiedOn] = @CurrentModificationOn
					, [Billing].[FacilityDone].[IsActive] = @IsActive
				WHERE
					[Billing].[FacilityDone].[FacilityDoneID] = @FacilityDoneID;				
			END
			ELSE
			BEGIN
				SELECT @FacilityDoneID = -2;
			END
		END
		ELSE IF @FacilityDoneID_PREV <> @FacilityDoneID
		BEGIN			
			SELECT @FacilityDoneID = -1;			
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
			SELECT @FacilityDoneID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
