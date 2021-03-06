USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_Insert_ExcelImportExport]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_Insert_ExcelImportExport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Configuration].[usp_Insert_ExcelImportExport]
	@ExcelRelPath NVARCHAR(256) = NULL
	, @TableName NVARCHAR(256) = NULL
	, @IsImport BIT
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @ExcelImportExportID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @ExcelImportExportID = [Configuration].[ufn_IsExists_ExcelImportExport] (@ExcelRelPath, @TableName, @IsImport, @Comment, 0);
		
		IF @ExcelImportExportID = 0
		BEGIN
			INSERT INTO [Configuration].[ExcelImportExport]
			(
				[ExcelRelPath]
				, [TableName]
				, [IsImport]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@ExcelRelPath
				, @TableName
				, @IsImport
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @ExcelImportExportID = MAX([Configuration].[ExcelImportExport].[ExcelImportExportID]) FROM [Configuration].[ExcelImportExport];
		END
		ELSE
		BEGIN			
			SELECT @ExcelImportExportID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @ExcelImportExportID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
