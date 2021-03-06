USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetByPkId_County]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetByPkId_County]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetByPkId_County] 
	@CountyID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[MasterData].[County].*
	FROM
		[MasterData].[County]
	WHERE
		[MasterData].[County].[CountyID] = @CountyID
	AND
		[MasterData].[County].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[County].[IsActive] ELSE @IsActive END;

	-- EXEC [MasterData].[usp_GetByPkId_County] 1, NULL
	-- EXEC [MasterData].[usp_GetByPkId_County] 1, 1
	-- EXEC [MasterData].[usp_GetByPkId_County] 1, 0
END
GO
