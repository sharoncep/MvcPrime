USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_Insert_Patient]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_Insert_Patient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Patient].[usp_Insert_Patient]
	@ClinicID INT
	, @ChartNumber NVARCHAR(20)
	, @MedicareID NVARCHAR(12) = NULL
	, @LastName NVARCHAR(150)
	, @MiddleName NVARCHAR(50) = NULL
	, @FirstName NVARCHAR(150)
	, @Sex NVARCHAR(1)
	, @DOB DATE
	, @SSN NVARCHAR(20) = NULL
	, @ProviderID INT
	, @InsuranceID INT
	, @PolicyNumber NVARCHAR(27)
	, @GroupNumber NVARCHAR(15) = NULL
	, @PolicyHolderChartNumber NVARCHAR(20)
	, @RelationshipID TINYINT
	, @IsInsuranceBenefitAccepted BIT
	, @IsCapitated BIT
	, @InsuranceEffectFrom DATE
	, @InsuranceEffectTo DATE = NULL
	, @PhotoRelPath NVARCHAR(350) = NULL
	, @IsSignedFile BIT
	, @SignedDate DATE = NULL
	, @StreetName NVARCHAR(500)
	, @Suite NVARCHAR(500) = NULL
	, @CityID INT
	, @StateID INT
	, @CountyID INT = NULL
	, @CountryID INT
	, @PhoneNumber NVARCHAR(13) = NULL
	, @SecondaryPhoneNumber NVARCHAR(13) = NULL
	, @Email NVARCHAR(256) = NULL
	, @SecondaryEmail NVARCHAR(256) = NULL
	, @Fax NVARCHAR(13) = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @PatientID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @PatientID = [Patient].[ufn_IsExists_Patient] (@ClinicID, @ChartNumber, @MedicareID, @LastName, @MiddleName, @FirstName, @Sex, @DOB, @SSN, @ProviderID, @InsuranceID, @PolicyNumber, @GroupNumber, @PolicyHolderChartNumber, @RelationshipID, @IsInsuranceBenefitAccepted, @IsCapitated, @InsuranceEffectFrom, @InsuranceEffectTo, @PhotoRelPath, @IsSignedFile, @SignedDate, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @SecondaryPhoneNumber, @Email, @SecondaryEmail, @Fax, @Comment, 0);
		
		IF @PatientID = 0
		BEGIN
			INSERT INTO [Patient].[Patient]
			(
				[ClinicID]
				, [ChartNumber]
				, [MedicareID]
				, [LastName]
				, [MiddleName]
				, [FirstName]
				, [Sex]
				, [DOB]
				, [SSN]
				, [ProviderID]
				, [InsuranceID]
				, [PolicyNumber]
				, [GroupNumber]
				, [PolicyHolderChartNumber]
				, [RelationshipID]
				, [IsInsuranceBenefitAccepted]
				, [IsCapitated]
				, [InsuranceEffectFrom]
				, [InsuranceEffectTo]
				, [PhotoRelPath]
				, [IsSignedFile]
				, [SignedDate]
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
				, @ChartNumber
				, @MedicareID
				, @LastName
				, @MiddleName
				, @FirstName
				, @Sex
				, @DOB
				, @SSN
				, @ProviderID
				, @InsuranceID
				, @PolicyNumber
				, @GroupNumber
				, @PolicyHolderChartNumber
				, @RelationshipID
				, @IsInsuranceBenefitAccepted
				, @IsCapitated
				, @InsuranceEffectFrom
				, @InsuranceEffectTo
				, @PhotoRelPath
				, @IsSignedFile
				, @SignedDate
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
			
			SELECT @PatientID = MAX([Patient].[Patient].[PatientID]) FROM [Patient].[Patient];
		END
		ELSE
		BEGIN			
			SELECT @PatientID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @PatientID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
