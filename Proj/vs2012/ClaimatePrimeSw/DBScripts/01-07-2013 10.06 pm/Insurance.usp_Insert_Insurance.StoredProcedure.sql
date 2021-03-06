USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_Insert_Insurance]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_Insert_Insurance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Insurance].[usp_Insert_Insurance]
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
	, @CurrentModificationBy BIGINT
	, @InsuranceID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @InsuranceID = [Insurance].[ufn_IsExists_Insurance] (@InsuranceCode, @InsuranceName, @PayerID, @InsuranceTypeID, @EDIReceiverID, @PrintPinID, @PatientPrintSignID, @InsuredPrintSignID, @PhysicianPrintSignID, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @PhoneNumberExtn, @SecondaryPhoneNumber, @SecondaryPhoneNumberExtn, @Email, @SecondaryEmail, @Fax, @Comment, 0);
		
		IF @InsuranceID = 0
		BEGIN
			INSERT INTO [Insurance].[Insurance]
			(
				[InsuranceCode]
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
			VALUES
			(
				@InsuranceCode
				, @InsuranceName
				, @PayerID
				, @InsuranceTypeID
				, @EDIReceiverID
				, @PrintPinID
				, @PatientPrintSignID
				, @InsuredPrintSignID
				, @PhysicianPrintSignID
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
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @InsuranceID = MAX([Insurance].[Insurance].[InsuranceID]) FROM [Insurance].[Insurance];
		END
		ELSE
		BEGIN			
			SELECT @InsuranceID = -1;
		END		
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
