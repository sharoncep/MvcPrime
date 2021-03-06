USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_IsExists_ExcelImportExport]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_IsExists_ExcelImportExport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Configuration].[usp_IsExists_ExcelImportExport]
	@ExcelRelPath NVARCHAR(256) = NULL
	, @TableName NVARCHAR(256) = NULL
	, @IsImport BIT
	, @Comment NVARCHAR(4000) = NULL
	, @ExcelImportExportID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @ExcelImportExportID = [Configuration].[ufn_IsExists_ExcelImportExport] (@ExcelRelPath, @TableName, @IsImport, @Comment, 0);
END
GO
