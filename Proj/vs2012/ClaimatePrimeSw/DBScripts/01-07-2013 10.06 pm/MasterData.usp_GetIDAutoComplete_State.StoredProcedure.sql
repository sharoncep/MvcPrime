USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetIDAutoComplete_State]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetIDAutoComplete_State]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [MasterData].[usp_GetIDAutoComplete_State] 
	@StateCode	nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [STATE_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[MasterData].[State].[StateID]
	FROM
		[MasterData].[State]
	WHERE
		@StateCode = [MasterData].[State].[StateCode]
	AND
		[MasterData].[State].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [MasterData].[usp_GetByPkId_State] 1, NULL
	-- EXEC [MasterData].[usp_GetByPkId_State] 1, 1
	-- EXEC [MasterData].[usp_GetByPkId_State] 1, 0
END
GO
