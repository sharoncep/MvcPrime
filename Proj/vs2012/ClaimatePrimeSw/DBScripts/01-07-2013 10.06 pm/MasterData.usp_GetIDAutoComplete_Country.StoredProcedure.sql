USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetIDAutoComplete_Country]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetIDAutoComplete_Country]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetIDAutoComplete_Country] 
	@CountryCode	nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [COUNTRY_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[MasterData].[Country].[CountryID]
	FROM
		[MasterData].[Country]
	WHERE
		@CountryCode = [MasterData].[Country].[CountryCode]
	AND
		[MasterData].[Country].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [MasterData].[usp_GetByPkId_Country] 1, NULL
	-- EXEC [MasterData].[usp_GetByPkId_Country] 1, 1
	-- EXEC [MasterData].[usp_GetByPkId_Country] 1, 0
END
GO
