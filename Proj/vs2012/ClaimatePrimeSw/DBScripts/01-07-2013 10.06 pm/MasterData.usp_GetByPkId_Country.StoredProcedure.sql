USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetByPkId_Country]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetByPkId_Country]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetByPkId_Country] 
	@CountryID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[MasterData].[Country].*
	FROM
		[MasterData].[Country]
	WHERE
		[MasterData].[Country].[CountryID] = @CountryID
	AND
		[MasterData].[Country].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[Country].[IsActive] ELSE @IsActive END;

	-- EXEC [MasterData].[usp_GetByPkId_Country] 1, NULL
	-- EXEC [MasterData].[usp_GetByPkId_Country] 1, 1
	-- EXEC [MasterData].[usp_GetByPkId_Country] 1, 0
END
GO
