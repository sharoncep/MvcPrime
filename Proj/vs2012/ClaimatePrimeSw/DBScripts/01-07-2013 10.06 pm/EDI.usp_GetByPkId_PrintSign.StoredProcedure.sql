USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetByPkId_PrintSign]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetByPkId_PrintSign]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [EDI].[usp_GetByPkId_PrintSign] 
	@PrintSignID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[EDI].[PrintSign].*
	FROM
		[EDI].[PrintSign]
	WHERE
		[EDI].[PrintSign].[PrintSignID] = @PrintSignID
	AND
		[EDI].[PrintSign].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[PrintSign].[IsActive] ELSE @IsActive END;

	-- EXEC [EDI].[usp_GetByPkId_PrintSign] 1, NULL
	-- EXEC [EDI].[usp_GetByPkId_PrintSign] 1, 1
	-- EXEC [EDI].[usp_GetByPkId_PrintSign] 1, 0
END
GO
