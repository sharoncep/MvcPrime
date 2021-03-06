USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_Update_Patient]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_Update_Patient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Patient in the database.
	 
CREATE PROCEDURE [Patient].[usp_Update_Patient]
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
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @PatientID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @PatientID_PREV BIGINT;
		SELECT @PatientID_PREV = [Patient].[ufn_IsExists_Patient] (@ClinicID, @ChartNumber, @MedicareID, @LastName, @MiddleName, @FirstName, @Sex, @DOB, @SSN, @ProviderID, @InsuranceID, @PolicyNumber, @GroupNumber, @PolicyHolderChartNumber, @RelationshipID, @IsInsuranceBenefitAccepted, @IsCapitated, @InsuranceEffectFrom, @InsuranceEffectTo, @PhotoRelPath, @IsSignedFile, @SignedDate, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @SecondaryPhoneNumber, @Email, @SecondaryEmail, @Fax, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Patient].[Patient].[PatientID] FROM [Patient].[Patient] WHERE [Patient].[Patient].[PatientID] = @PatientID AND [Patient].[Patient].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@PatientID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Patient].[Patient].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Patient].[Patient].[LastModifiedOn]
			FROM 
				[Patient].[Patient] WITH (NOLOCK)
			WHERE
				[Patient].[Patient].[PatientID] = @PatientID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Patient].[PatientHistory]
					(
						[PatientID]
						, [ClinicID]
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
				SELECT
					[Patient].[Patient].[PatientID]
					, [Patient].[Patient].[ClinicID]
					, [Patient].[Patient].[ChartNumber]
					, [Patient].[Patient].[MedicareID]
					, [Patient].[Patient].[LastName]
					, [Patient].[Patient].[MiddleName]
					, [Patient].[Patient].[FirstName]
					, [Patient].[Patient].[Sex]
					, [Patient].[Patient].[DOB]
					, [Patient].[Patient].[SSN]
					, [Patient].[Patient].[ProviderID]
					, [Patient].[Patient].[InsuranceID]
					, [Patient].[Patient].[PolicyNumber]
					, [Patient].[Patient].[GroupNumber]
					, [Patient].[Patient].[PolicyHolderChartNumber]
					, [Patient].[Patient].[RelationshipID]
					, [Patient].[Patient].[IsInsuranceBenefitAccepted]
					, [Patient].[Patient].[IsCapitated]
					, [Patient].[Patient].[InsuranceEffectFrom]
					, [Patient].[Patient].[InsuranceEffectTo]
					, [Patient].[Patient].[PhotoRelPath]
					, [Patient].[Patient].[IsSignedFile]
					, [Patient].[Patient].[SignedDate]
					, [Patient].[Patient].[StreetName]
					, [Patient].[Patient].[Suite]
					, [Patient].[Patient].[CityID]
					, [Patient].[Patient].[StateID]
					, [Patient].[Patient].[CountyID]
					, [Patient].[Patient].[CountryID]
					, [Patient].[Patient].[PhoneNumber]
					, [Patient].[Patient].[SecondaryPhoneNumber]
					, [Patient].[Patient].[Email]
					, [Patient].[Patient].[SecondaryEmail]
					, [Patient].[Patient].[Fax]
					, [Patient].[Patient].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Patient].[Patient].[IsActive]
				FROM 
					[Patient].[Patient]
				WHERE
					[Patient].[Patient].[PatientID] = @PatientID;
				
				UPDATE 
					[Patient].[Patient]
				SET
					[Patient].[Patient].[ClinicID] = @ClinicID
					, [Patient].[Patient].[ChartNumber] = @ChartNumber
					, [Patient].[Patient].[MedicareID] = @MedicareID
					, [Patient].[Patient].[LastName] = @LastName
					, [Patient].[Patient].[MiddleName] = @MiddleName
					, [Patient].[Patient].[FirstName] = @FirstName
					, [Patient].[Patient].[Sex] = @Sex
					, [Patient].[Patient].[DOB] = @DOB
					, [Patient].[Patient].[SSN] = @SSN
					, [Patient].[Patient].[ProviderID] = @ProviderID
					, [Patient].[Patient].[InsuranceID] = @InsuranceID
					, [Patient].[Patient].[PolicyNumber] = @PolicyNumber
					, [Patient].[Patient].[GroupNumber] = @GroupNumber
					, [Patient].[Patient].[PolicyHolderChartNumber] = @PolicyHolderChartNumber
					, [Patient].[Patient].[RelationshipID] = @RelationshipID
					, [Patient].[Patient].[IsInsuranceBenefitAccepted] = @IsInsuranceBenefitAccepted
					, [Patient].[Patient].[IsCapitated] = @IsCapitated
					, [Patient].[Patient].[InsuranceEffectFrom] = @InsuranceEffectFrom
					, [Patient].[Patient].[InsuranceEffectTo] = @InsuranceEffectTo
					, [Patient].[Patient].[PhotoRelPath] = @PhotoRelPath
					, [Patient].[Patient].[IsSignedFile] = @IsSignedFile
					, [Patient].[Patient].[SignedDate] = @SignedDate
					, [Patient].[Patient].[StreetName] = @StreetName
					, [Patient].[Patient].[Suite] = @Suite
					, [Patient].[Patient].[CityID] = @CityID
					, [Patient].[Patient].[StateID] = @StateID
					, [Patient].[Patient].[CountyID] = @CountyID
					, [Patient].[Patient].[CountryID] = @CountryID
					, [Patient].[Patient].[PhoneNumber] = @PhoneNumber
					, [Patient].[Patient].[SecondaryPhoneNumber] = @SecondaryPhoneNumber
					, [Patient].[Patient].[Email] = @Email
					, [Patient].[Patient].[SecondaryEmail] = @SecondaryEmail
					, [Patient].[Patient].[Fax] = @Fax
					, [Patient].[Patient].[Comment] = @Comment
					, [Patient].[Patient].[LastModifiedBy] = @CurrentModificationBy
					, [Patient].[Patient].[LastModifiedOn] = @CurrentModificationOn
					, [Patient].[Patient].[IsActive] = @IsActive
				WHERE
					[Patient].[Patient].[PatientID] = @PatientID;				
			END
			ELSE
			BEGIN
				SELECT @PatientID = -2;
			END
		END
		ELSE IF @PatientID_PREV <> @PatientID
		BEGIN			
			SELECT @PatientID = -1;			
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
			SELECT @PatientID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
