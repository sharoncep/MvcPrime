USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetIDAutoComplete_County]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetIDAutoComplete_County]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetIDAutoComplete_County] 
	@CountyCode	NVARCHAR(6)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [COUNTY_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[MasterData].[County].[CountyID]
	FROM
		[MasterData].[County]
	WHERE
		@CountyCode = [MasterData].[County].[CountyCode]
	AND
		[MasterData].[County].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [MasterData].[usp_GetIDAutoComplete_County] '46-055'
	-- EXEC [MasterData].[usp_GetIDAutoComplete_County] 1
	-- EXEC [MasterData].[usp_GetIDAutoComplete_County] 1
END
GO
