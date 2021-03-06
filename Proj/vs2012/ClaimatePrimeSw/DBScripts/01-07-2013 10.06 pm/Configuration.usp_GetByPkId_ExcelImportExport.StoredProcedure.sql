USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_GetByPkId_ExcelImportExport]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_GetByPkId_ExcelImportExport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Configuration].[usp_GetByPkId_ExcelImportExport] 
	@ExcelImportExportID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Configuration].[ExcelImportExport].*
	FROM
		[Configuration].[ExcelImportExport]
	WHERE
		[Configuration].[ExcelImportExport].[ExcelImportExportID] = @ExcelImportExportID
	AND
		[Configuration].[ExcelImportExport].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Configuration].[ExcelImportExport].[IsActive] ELSE @IsActive END;

	-- EXEC [Configuration].[usp_GetByPkId_ExcelImportExport] 1, NULL
	-- EXEC [Configuration].[usp_GetByPkId_ExcelImportExport] 1, 1
	-- EXEC [Configuration].[usp_GetByPkId_ExcelImportExport] 1, 0
END
GO
