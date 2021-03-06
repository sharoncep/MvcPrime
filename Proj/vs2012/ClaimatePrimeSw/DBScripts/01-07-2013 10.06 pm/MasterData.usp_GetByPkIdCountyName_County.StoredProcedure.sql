USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetByPkIdCountyName_County]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetByPkIdCountyName_County]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetByPkIdCountyName_County] 
	@CountyID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @TBL_RES TABLE
	(
		[CountyName] NVARCHAR(150) NOT NULL 
		, [CountyCode] NVARCHAR(6) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[MasterData].[County].[CountyName],[MasterData].[County].[CountyCode]
	FROM
		[MasterData].[County]
	WHERE
		@CountyID = [MasterData].[County].[CountyID]
	AND
		[MasterData].[County].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[County].[IsActive] ELSE @IsActive END;
		
	SELECT * FROM @TBL_RES;
	-- EXEC [MasterData].[usp_GetByPkIdCountyName_County] 1, NULL
	-- EXEC [MasterData].[usp_GetByPkIdCountyName_County] 1, 1
	-- EXEC [MasterData].[usp_GetByPkIdCountyName_County] 1, 0
END
GO
