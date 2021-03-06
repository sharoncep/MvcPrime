USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_Update_Insurance]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_Update_Insurance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Insurance in the database.
	 
CREATE PROCEDURE [Insurance].[usp_Update_Insurance]
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
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @InsuranceID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @InsuranceID_PREV BIGINT;
		SELECT @InsuranceID_PREV = [Insurance].[ufn_IsExists_Insurance] (@InsuranceCode, @InsuranceName, @PayerID, @InsuranceTypeID, @EDIReceiverID, @PrintPinID, @PatientPrintSignID, @InsuredPrintSignID, @PhysicianPrintSignID, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @PhoneNumberExtn, @SecondaryPhoneNumber, @SecondaryPhoneNumberExtn, @Email, @SecondaryEmail, @Fax, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Insurance].[Insurance].[InsuranceID] FROM [Insurance].[Insurance] WHERE [Insurance].[Insurance].[InsuranceID] = @InsuranceID AND [Insurance].[Insurance].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@InsuranceID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Insurance].[Insurance].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Insurance].[Insurance].[LastModifiedOn]
			FROM 
				[Insurance].[Insurance] WITH (NOLOCK)
			WHERE
				[Insurance].[Insurance].[InsuranceID] = @InsuranceID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Insurance].[InsuranceHistory]
					(
						[InsuranceID]
						, [InsuranceCode]
						, [InsuranceName]
						, [PayerID]
						, [InsuranceTypeID]
						, [EDIReceiverID]
						, [PrintPinID]
						, [PatientPrintSignID]
						, [InsuredPrintSignID]
						, [PhysicianPrintSignID]
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
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Insurance].[Insurance].[InsuranceID]
					, [Insurance].[Insurance].[InsuranceCode]
					, [Insurance].[Insurance].[InsuranceName]
					, [Insurance].[Insurance].[PayerID]
					, [Insurance].[Insurance].[InsuranceTypeID]
					, [Insurance].[Insurance].[EDIReceiverID]
					, [Insurance].[Insurance].[PrintPinID]
					, [Insurance].[Insurance].[PatientPrintSignID]
					, [Insurance].[Insurance].[InsuredPrintSignID]
					, [Insurance].[Insurance].[PhysicianPrintSignID]
					, [Insurance].[Insurance].[StreetName]
					, [Insurance].[Insurance].[Suite]
					, [Insurance].[Insurance].[CityID]
					, [Insurance].[Insurance].[StateID]
					, [Insurance].[Insurance].[CountyID]
					, [Insurance].[Insurance].[CountryID]
					, [Insurance].[Insurance].[PhoneNumber]
					, [Insurance].[Insurance].[PhoneNumberExtn]
					, [Insurance].[Insurance].[SecondaryPhoneNumber]
					, [Insurance].[Insurance].[SecondaryPhoneNumberExtn]
					, [Insurance].[Insurance].[Email]
					, [Insurance].[Insurance].[SecondaryEmail]
					, [Insurance].[Insurance].[Fax]
					, [Insurance].[Insurance].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Insurance].[Insurance].[IsActive]
				FROM 
					[Insurance].[Insurance]
				WHERE
					[Insurance].[Insurance].[InsuranceID] = @InsuranceID;
				
				UPDATE 
					[Insurance].[Insurance]
				SET
					[Insurance].[Insurance].[InsuranceCode] = @InsuranceCode
					, [Insurance].[Insurance].[InsuranceName] = @InsuranceName
					, [Insurance].[Insurance].[PayerID] = @PayerID
					, [Insurance].[Insurance].[InsuranceTypeID] = @InsuranceTypeID
					, [Insurance].[Insurance].[EDIReceiverID] = @EDIReceiverID
					, [Insurance].[Insurance].[PrintPinID] = @PrintPinID
					, [Insurance].[Insurance].[PatientPrintSignID] = @PatientPrintSignID
					, [Insurance].[Insurance].[InsuredPrintSignID] = @InsuredPrintSignID
					, [Insurance].[Insurance].[PhysicianPrintSignID] = @PhysicianPrintSignID
					, [Insurance].[Insurance].[StreetName] = @StreetName
					, [Insurance].[Insurance].[Suite] = @Suite
					, [Insurance].[Insurance].[CityID] = @CityID
					, [Insurance].[Insurance].[StateID] = @StateID
					, [Insurance].[Insurance].[CountyID] = @CountyID
					, [Insurance].[Insurance].[CountryID] = @CountryID
					, [Insurance].[Insurance].[PhoneNumber] = @PhoneNumber
					, [Insurance].[Insurance].[PhoneNumberExtn] = @PhoneNumberExtn
					, [Insurance].[Insurance].[SecondaryPhoneNumber] = @SecondaryPhoneNumber
					, [Insurance].[Insurance].[SecondaryPhoneNumberExtn] = @SecondaryPhoneNumberExtn
					, [Insurance].[Insurance].[Email] = @Email
					, [Insurance].[Insurance].[SecondaryEmail] = @SecondaryEmail
					, [Insurance].[Insurance].[Fax] = @Fax
					, [Insurance].[Insurance].[Comment] = @Comment
					, [Insurance].[Insurance].[LastModifiedBy] = @CurrentModificationBy
					, [Insurance].[Insurance].[LastModifiedOn] = @CurrentModificationOn
					, [Insurance].[Insurance].[IsActive] = @IsActive
				WHERE
					[Insurance].[Insurance].[InsuranceID] = @InsuranceID;				
			END
			ELSE
			BEGIN
				SELECT @InsuranceID = -2;
			END
		END
		ELSE IF @InsuranceID_PREV <> @InsuranceID
		BEGIN			
			SELECT @InsuranceID = -1;			
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
			SELECT @InsuranceID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
