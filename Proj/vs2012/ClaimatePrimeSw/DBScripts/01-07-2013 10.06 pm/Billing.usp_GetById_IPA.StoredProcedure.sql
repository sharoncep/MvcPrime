USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetById_IPA]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetById_IPA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Billing].[usp_GetById_IPA] 
	@IPAID	INT
	, @IsActive	BIT = NULL
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
	[Billing].[IPA].[IPACode]
      ,[Billing].[IPA].[IPAName]
      ,[Billing].[IPA].[NPI]
      ,[Billing].[IPA].[TaxID]
      ,[Transaction].[EntityTypeQualifier].[EntityTypeQualifierName]
      ,[Billing].[IPA].[LogoRelPath]
      ,[Billing].[IPA].[StreetName]
      ,[Billing].[IPA].[Suite]
      ,[MasterData].[City].[CityName]
      ,[MasterData].[City].[ZipCode]
      ,[MasterData].[State].[StateName]
      ,[MasterData].[State].[StateCode]
      ,[MasterData].[County].[CountyName]
      ,[MasterData].[County].[CountyCode]
      ,[MasterData].[Country].[CountryName]
      ,[MasterData].[Country].[CountryCode]
      ,[Billing].[IPA].[PhoneNumber]
      ,[Billing].[IPA].[PhoneNumberExtn]
      ,[Billing].[IPA].[SecondaryPhoneNumber]
      ,[Billing].[IPA].[SecondaryPhoneNumberExtn]
      ,[Billing].[IPA].[Email]
      ,[Billing].[IPA].[SecondaryEmail]
      ,[Billing].[IPA].[Fax]
      ,[Billing].[IPA].[ContactPersonLastName]
      ,[Billing].[IPA].[ContactPersonMiddleName]
      ,[Billing].[IPA].[ContactPersonFirstName]
      ,[Billing].[IPA].[ContactPersonPhoneNumber]
      ,[Billing].[IPA].[ContactPersonPhoneNumberExtn]
      ,[Billing].[IPA].[ContactPersonSecondaryPhoneNumber]
      ,[Billing].[IPA].[ContactPersonSecondaryPhoneNumberExtn]
      ,[Billing].[IPA].[ContactPersonEmail]
      ,[Billing].[IPA].[ContactPersonSecondaryEmail]
      ,[Billing].[IPA].[ContactPersonFax]
	FROM
		[Billing].[IPA]
	 INNER JOIN
	 [MasterData].[City]
	 
	 ON
	 [Billing].[IPA].[CityID]=[MasterData].[City].[CityID]
	 
	  INNER JOIN
	 [Transaction].[EntityTypeQualifier]
	 
	 ON
	 [Billing].[IPA].[EntityTypeQualifierID]=[Transaction].[EntityTypeQualifier].[EntityTypeQualifierID]
	  INNER JOIN
	 [MasterData].[State]
	 
	 ON
	 [Billing].[IPA].[StateID]=[MasterData].[State].[StateID]
	  INNER JOIN
	 [MasterData].[County]
	 
	 ON
	 [Billing].[IPA].[CountyID]=[MasterData].[County].[CountyID]
	 
	  INNER JOIN
	 [MasterData].[Country]
	 
	 ON
	 [Billing].[IPA].[CountryID]=[MasterData].[Country].[CountryID]
		
	WHERE
		@IPAID = [Billing].[IPA].[IPAID]
	AND
		[Billing].[IPA].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[IPA].[IsActive] ELSE @IsActive END;

	-- EXEC [Billing].[usp_GetById_IPA] 21, NULL
	-- EXEC [Billing].[usp_GetByPkId_IPA] 1, 1
	-- EXEC [Billing].[usp_GetByPkId_IPA] 1, 0
END
GO
