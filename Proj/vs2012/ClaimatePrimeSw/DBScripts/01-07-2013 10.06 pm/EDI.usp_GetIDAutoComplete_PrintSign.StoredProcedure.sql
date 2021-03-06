USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetIDAutoComplete_PrintSign]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetIDAutoComplete_PrintSign]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [EDI].[usp_GetIDAutoComplete_PrintSign] 
	@PrintSignCode	nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [PrintSign_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[EDI].[PrintSign].[PrintSignID]
	FROM
		[EDI].[PrintSign]
	WHERE
		@PrintSignCode = [EDI].[PrintSign].[PrintSignCode]
	AND
		[EDI].[PrintSign].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [EDI].[usp_GetByPkId_PrintSign] 1, NULL
	-- EXEC [EDI].[usp_GetByPkId_PrintSign] 1, 1
	-- EXEC [EDI].[usp_GetByPkId_PrintSign] 1, 0
END
GO
