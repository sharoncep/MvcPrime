USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetByPkId_PrintPin]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetByPkId_PrintPin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [EDI].[usp_GetByPkId_PrintPin] 
	@PrintPinID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[EDI].[PrintPin].*
	FROM
		[EDI].[PrintPin]
	WHERE
		[EDI].[PrintPin].[PrintPinID] = @PrintPinID
	AND
		[EDI].[PrintPin].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[PrintPin].[IsActive] ELSE @IsActive END;

	-- EXEC [EDI].[usp_GetByPkId_PrintPin] 1, NULL
	-- EXEC [EDI].[usp_GetByPkId_PrintPin] 1, 1
	-- EXEC [EDI].[usp_GetByPkId_PrintPin] 1, 0
END
GO
