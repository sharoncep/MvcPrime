USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_IsExists_Patient]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_IsExists_Patient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Patient].[usp_IsExists_Patient]
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
	, @PatientID	BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @PatientID = [Patient].[ufn_IsExists_Patient] (@ClinicID, @ChartNumber, @MedicareID, @LastName, @MiddleName, @FirstName, @Sex, @DOB, @SSN, @ProviderID, @InsuranceID, @PolicyNumber, @GroupNumber, @PolicyHolderChartNumber, @RelationshipID, @IsInsuranceBenefitAccepted, @IsCapitated, @InsuranceEffectFrom, @InsuranceEffectTo, @PhotoRelPath, @IsSignedFile, @SignedDate, @StreetName, @Suite, @CityID, @StateID, @CountyID, @CountryID, @PhoneNumber, @SecondaryPhoneNumber, @Email, @SecondaryEmail, @Fax, @Comment, 0);
END
GO
