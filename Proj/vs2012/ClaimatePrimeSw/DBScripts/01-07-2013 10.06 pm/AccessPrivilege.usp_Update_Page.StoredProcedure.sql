USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [AccessPrivilege].[usp_Update_Page]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [AccessPrivilege].[usp_Update_Page]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Page in the database.
	 
CREATE PROCEDURE [AccessPrivilege].[usp_Update_Page]
	@SessionName NVARCHAR(15) = NULL
	, @ControllerName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @PageID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @PageID_PREV BIGINT;
		SELECT @PageID_PREV = [AccessPrivilege].[ufn_IsExists_Page] (@SessionName, @ControllerName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [AccessPrivilege].[Page].[PageID] FROM [AccessPrivilege].[Page] WHERE [AccessPrivilege].[Page].[PageID] = @PageID AND [AccessPrivilege].[Page].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@PageID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [AccessPrivilege].[Page].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [AccessPrivilege].[Page].[LastModifiedOn]
			FROM 
				[AccessPrivilege].[Page] WITH (NOLOCK)
			WHERE
				[AccessPrivilege].[Page].[PageID] = @PageID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[AccessPrivilege].[PageHistory]
					(
						[PageID]
						, [SessionName]
						, [ControllerName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[AccessPrivilege].[Page].[PageID]
					, [AccessPrivilege].[Page].[SessionName]
					, [AccessPrivilege].[Page].[ControllerName]
					, [AccessPrivilege].[Page].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [AccessPrivilege].[Page].[IsActive]
				FROM 
					[AccessPrivilege].[Page]
				WHERE
					[AccessPrivilege].[Page].[PageID] = @PageID;
				
				UPDATE 
					[AccessPrivilege].[Page]
				SET
					[AccessPrivilege].[Page].[SessionName] = @SessionName
					, [AccessPrivilege].[Page].[ControllerName] = @ControllerName
					, [AccessPrivilege].[Page].[Comment] = @Comment
					, [AccessPrivilege].[Page].[LastModifiedBy] = @CurrentModificationBy
					, [AccessPrivilege].[Page].[LastModifiedOn] = @CurrentModificationOn
					, [AccessPrivilege].[Page].[IsActive] = @IsActive
				WHERE
					[AccessPrivilege].[Page].[PageID] = @PageID;				
			END
			ELSE
			BEGIN
				SELECT @PageID = -2;
			END
		END
		ELSE IF @PageID_PREV <> @PageID
		BEGIN			
			SELECT @PageID = -1;			
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
			SELECT @PageID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
