USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetByPkId_State]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetByPkId_State]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetByPkId_State] 
	@StateID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[MasterData].[State].*
	FROM
		[MasterData].[State]
	WHERE
		[MasterData].[State].[StateID] = @StateID
	AND
		[MasterData].[State].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[State].[IsActive] ELSE @IsActive END;

	-- EXEC [MasterData].[usp_GetByPkId_State] 1, NULL
	-- EXEC [MasterData].[usp_GetByPkId_State] 1, 1
	-- EXEC [MasterData].[usp_GetByPkId_State] 1, 0
END
GO
