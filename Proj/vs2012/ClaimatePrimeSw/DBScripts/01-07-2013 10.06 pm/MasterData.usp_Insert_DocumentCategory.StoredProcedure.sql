USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_Insert_DocumentCategory]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_Insert_DocumentCategory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [MasterData].[usp_Insert_DocumentCategory]
	@DocumentCategoryCode NVARCHAR(2)
	, @DocumentCategoryName NVARCHAR(150)
	, @IsInPatientRelated BIT
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @DocumentCategoryID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @DocumentCategoryID = [MasterData].[ufn_IsExists_DocumentCategory] (@DocumentCategoryCode, @DocumentCategoryName, @IsInPatientRelated, @Comment, 0);
		
		IF @DocumentCategoryID = 0
		BEGIN
			INSERT INTO [MasterData].[DocumentCategory]
			(
				[DocumentCategoryCode]
				, [DocumentCategoryName]
				, [IsInPatientRelated]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@DocumentCategoryCode
				, @DocumentCategoryName
				, @IsInPatientRelated
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @DocumentCategoryID = MAX([MasterData].[DocumentCategory].[DocumentCategoryID]) FROM [MasterData].[DocumentCategory];
		END
		ELSE
		BEGIN			
			SELECT @DocumentCategoryID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @DocumentCategoryID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
