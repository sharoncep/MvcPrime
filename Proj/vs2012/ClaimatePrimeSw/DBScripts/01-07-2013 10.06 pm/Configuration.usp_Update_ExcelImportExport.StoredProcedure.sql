USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_Update_ExcelImportExport]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_Update_ExcelImportExport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the ExcelImportExport in the database.
	 
CREATE PROCEDURE [Configuration].[usp_Update_ExcelImportExport]
	@ExcelRelPath NVARCHAR(256) = NULL
	, @TableName NVARCHAR(256) = NULL
	, @IsImport BIT
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @ExcelImportExportID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @ExcelImportExportID_PREV BIGINT;
		SELECT @ExcelImportExportID_PREV = [Configuration].[ufn_IsExists_ExcelImportExport] (@ExcelRelPath, @TableName, @IsImport, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Configuration].[ExcelImportExport].[ExcelImportExportID] FROM [Configuration].[ExcelImportExport] WHERE [Configuration].[ExcelImportExport].[ExcelImportExportID] = @ExcelImportExportID AND [Configuration].[ExcelImportExport].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@ExcelImportExportID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Configuration].[ExcelImportExport].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Configuration].[ExcelImportExport].[LastModifiedOn]
			FROM 
				[Configuration].[ExcelImportExport] WITH (NOLOCK)
			WHERE
				[Configuration].[ExcelImportExport].[ExcelImportExportID] = @ExcelImportExportID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Configuration].[ExcelImportExportHistory]
					(
						[ExcelImportExportID]
						, [ExcelRelPath]
						, [TableName]
						, [IsImport]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Configuration].[ExcelImportExport].[ExcelImportExportID]
					, [Configuration].[ExcelImportExport].[ExcelRelPath]
					, [Configuration].[ExcelImportExport].[TableName]
					, [Configuration].[ExcelImportExport].[IsImport]
					, [Configuration].[ExcelImportExport].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Configuration].[ExcelImportExport].[IsActive]
				FROM 
					[Configuration].[ExcelImportExport]
				WHERE
					[Configuration].[ExcelImportExport].[ExcelImportExportID] = @ExcelImportExportID;
				
				UPDATE 
					[Configuration].[ExcelImportExport]
				SET
					[Configuration].[ExcelImportExport].[ExcelRelPath] = @ExcelRelPath
					, [Configuration].[ExcelImportExport].[TableName] = @TableName
					, [Configuration].[ExcelImportExport].[IsImport] = @IsImport
					, [Configuration].[ExcelImportExport].[Comment] = @Comment
					, [Configuration].[ExcelImportExport].[LastModifiedBy] = @CurrentModificationBy
					, [Configuration].[ExcelImportExport].[LastModifiedOn] = @CurrentModificationOn
					, [Configuration].[ExcelImportExport].[IsActive] = @IsActive
				WHERE
					[Configuration].[ExcelImportExport].[ExcelImportExportID] = @ExcelImportExportID;				
			END
			ELSE
			BEGIN
				SELECT @ExcelImportExportID = -2;
			END
		END
		ELSE IF @ExcelImportExportID_PREV <> @ExcelImportExportID
		BEGIN			
			SELECT @ExcelImportExportID = -1;			
		END
		-- ELSE
		-- BEGIN
		--	 SELECT @CurrentModificationOn = @LastModifiedOn;
		-- END
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
