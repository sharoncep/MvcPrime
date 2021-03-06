USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetByPkIdStateName_State]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetByPkIdStateName_State]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetByPkIdStateName_State] 
	@StateID	INT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[StateName] NVARCHAR(150) NOT NULL 
		, [StateCode] NVARCHAR(2) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[MasterData].[State].[StateName],[MasterData].[State].[StateCode]
	FROM
		[MasterData].[State]
	WHERE
		@StateID = [MasterData].[State].[StateID]
	AND
		[MasterData].[State].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[State].[IsActive] ELSE @IsActive END;

	SELECT * FROM @TBL_RES;
	
	-- EXEC [MasterData].[usp_GetByPkIdStateName_State] 1, NULL
	-- EXEC [MasterData].[usp_GetByPkIdStateName_State] 1, 1
	-- EXEC [MasterData].[usp_GetByPkIdStateName_State] 1, 0
END
GO
