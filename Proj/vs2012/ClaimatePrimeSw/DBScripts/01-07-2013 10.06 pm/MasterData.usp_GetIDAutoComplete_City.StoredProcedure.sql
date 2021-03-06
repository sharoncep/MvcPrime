USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetIDAutoComplete_City]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetIDAutoComplete_City]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [MasterData].[usp_GetIDAutoComplete_City] 
	@ZipCode	NVARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;
	
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CityID] INT NOT NULL
	);
	INSERT INTO
		@TBL_RES
	SELECT
		[MasterData].[City].[CityID]
	FROM
		[MasterData].[City]
	WHERE
		@ZipCode = [MasterData].[City].[ZipCode]
	AND
		[MasterData].[City].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;
	
	-- EXEC [MasterData].[usp_GetIDAutoComplete_City] 1
	-- EXEC [MasterData].[usp_GetIDAutoComplete_City] 1, 1
	-- EXEC [MasterData].[usp_GetIDAutoComplete_City] 1, 0
END
GO
