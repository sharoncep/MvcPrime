USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_Update_DocumentCategory]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_Update_DocumentCategory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the DocumentCategory in the database.
	 
CREATE PROCEDURE [MasterData].[usp_Update_DocumentCategory]
	@DocumentCategoryCode NVARCHAR(2)
	, @DocumentCategoryName NVARCHAR(150)
	, @IsInPatientRelated BIT
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @DocumentCategoryID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @DocumentCategoryID_PREV BIGINT;
		SELECT @DocumentCategoryID_PREV = [MasterData].[ufn_IsExists_DocumentCategory] (@DocumentCategoryCode, @DocumentCategoryName, @IsInPatientRelated, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [MasterData].[DocumentCategory].[DocumentCategoryID] FROM [MasterData].[DocumentCategory] WHERE [MasterData].[DocumentCategory].[DocumentCategoryID] = @DocumentCategoryID AND [MasterData].[DocumentCategory].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@DocumentCategoryID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [MasterData].[DocumentCategory].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [MasterData].[DocumentCategory].[LastModifiedOn]
			FROM 
				[MasterData].[DocumentCategory] WITH (NOLOCK)
			WHERE
				[MasterData].[DocumentCategory].[DocumentCategoryID] = @DocumentCategoryID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[MasterData].[DocumentCategoryHistory]
					(
						[DocumentCategoryID]
						, [DocumentCategoryCode]
						, [DocumentCategoryName]
						, [IsInPatientRelated]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[MasterData].[DocumentCategory].[DocumentCategoryID]
					, [MasterData].[DocumentCategory].[DocumentCategoryCode]
					, [MasterData].[DocumentCategory].[DocumentCategoryName]
					, [MasterData].[DocumentCategory].[IsInPatientRelated]
					, [MasterData].[DocumentCategory].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [MasterData].[DocumentCategory].[IsActive]
				FROM 
					[MasterData].[DocumentCategory]
				WHERE
					[MasterData].[DocumentCategory].[DocumentCategoryID] = @DocumentCategoryID;
				
				UPDATE 
					[MasterData].[DocumentCategory]
				SET
					[MasterData].[DocumentCategory].[DocumentCategoryCode] = @DocumentCategoryCode
					, [MasterData].[DocumentCategory].[DocumentCategoryName] = @DocumentCategoryName
					, [MasterData].[DocumentCategory].[IsInPatientRelated] = @IsInPatientRelated
					, [MasterData].[DocumentCategory].[Comment] = @Comment
					, [MasterData].[DocumentCategory].[LastModifiedBy] = @CurrentModificationBy
					, [MasterData].[DocumentCategory].[LastModifiedOn] = @CurrentModificationOn
					, [MasterData].[DocumentCategory].[IsActive] = @IsActive
				WHERE
					[MasterData].[DocumentCategory].[DocumentCategoryID] = @DocumentCategoryID;				
			END
			ELSE
			BEGIN
				SELECT @DocumentCategoryID = -2;
			END
		END
		ELSE IF @DocumentCategoryID_PREV <> @DocumentCategoryID
		BEGIN			
			SELECT @DocumentCategoryID = -1;			
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
			SELECT @DocumentCategoryID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
