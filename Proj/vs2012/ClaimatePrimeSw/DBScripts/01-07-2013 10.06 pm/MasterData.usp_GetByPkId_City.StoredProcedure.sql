USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetByPkId_City]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetByPkId_City]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetByPkId_City] 
	@CityID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[MasterData].[City].*
	FROM
		[MasterData].[City]
	WHERE
		[MasterData].[City].[CityID] = @CityID
	AND
		[MasterData].[City].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[City].[IsActive] ELSE @IsActive END;

	-- EXEC [MasterData].[usp_GetByPkId_City] 1, NULL
	-- EXEC [MasterData].[usp_GetByPkId_City] 1, 1
	-- EXEC [MasterData].[usp_GetByPkId_City] 1, 0
END
GO
