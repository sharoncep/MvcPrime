USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837FacilityDone_ClaimProcess]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetAnsi837FacilityDone_ClaimProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetAnsi837FacilityDone_ClaimProcess]
	@FacilityDoneID INT
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT
		[Billing].[FacilityDone].[FacilityDoneName]
		, [Billing].[FacilityDone].[NPI]
		, [Billing].[FacilityDone].[TaxID]
		, [Billing].[FacilityDone].[StreetName]
		, [MasterData].[City].[CityName]
		, ISNULL([MasterData].[City].[ZipCode], '') AS [ZipCode]
		, [MasterData].[State].[StateCode]
		, [MasterData].[Country].[CountryCode]
	FROM
		[Billing].[FacilityDone]
	LEFT JOIN
		[MasterData].[City]
	ON
		[MasterData].[City].[CityID] = [Billing].[FacilityDone].[CityID]
	LEFT JOIN
		[MasterData].[State]
	ON
		[MasterData].[State].[StateID] = [Billing].[FacilityDone].[StateID]
	LEFT JOIN
		[MasterData].[Country]
	ON
		[MasterData].[Country].[CountryID] = [Billing].[FacilityDone].[CountryID]
	WHERE
		[Billing].[FacilityDone].[FacilityDoneID] = @FacilityDoneID
	AND
		[Billing].[FacilityDone].[IsActive] = 1
	AND
		[MasterData].[City].[IsActive] = 1
	AND
		[MasterData].[State].[IsActive] = 1
	AND
		[MasterData].[Country].[IsActive] = 1
	
		
	-- EXEC [Claim].[usp_GetAnsi837FacilityDone_ClaimProcess] 1
END
GO
