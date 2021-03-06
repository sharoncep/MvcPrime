USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetIDAutoComplete_PrintPin]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetIDAutoComplete_PrintPin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [EDI].[usp_GetIDAutoComplete_PrintPin] 
	@PrintPinCode	nvarchar(3)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [PrintPin_ID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[EDI].[PrintPin].[PrintPinID]
	FROM
		[EDI].[PrintPin]
	WHERE
		@PrintPinCode = [EDI].[PrintPin].[PrintPinCode]
	AND
		[EDI].[PrintPin].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [EDI].[usp_GetByPkId_PrintPin] 1, NULL
	-- EXEC [EDI].[usp_GetByPkId_PrintPin] 1, 1
	-- EXEC [EDI].[usp_GetByPkId_PrintPin] 1, 0
END
GO
