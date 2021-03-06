USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [AccessPrivilege].[usp_Update_PageRole]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [AccessPrivilege].[usp_Update_PageRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the PageRole in the database.
	 
CREATE PROCEDURE [AccessPrivilege].[usp_Update_PageRole]
	@RoleID TINYINT
	, @PageID TINYINT
	, @CreatePermission BIT
	, @UpdatePermission BIT
	, @ReadPermission BIT
	, @DeletePermission BIT
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @PageRoleID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @PageRoleID_PREV BIGINT;
		SELECT @PageRoleID_PREV = [AccessPrivilege].[ufn_IsExists_PageRole] (@RoleID, @PageID, @CreatePermission, @UpdatePermission, @ReadPermission, @DeletePermission, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [AccessPrivilege].[PageRole].[PageRoleID] FROM [AccessPrivilege].[PageRole] WHERE [AccessPrivilege].[PageRole].[PageRoleID] = @PageRoleID AND [AccessPrivilege].[PageRole].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@PageRoleID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [AccessPrivilege].[PageRole].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [AccessPrivilege].[PageRole].[LastModifiedOn]
			FROM 
				[AccessPrivilege].[PageRole] WITH (NOLOCK)
			WHERE
				[AccessPrivilege].[PageRole].[PageRoleID] = @PageRoleID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[AccessPrivilege].[PageRoleHistory]
					(
						[PageRoleID]
						, [RoleID]
						, [PageID]
						, [CreatePermission]
						, [UpdatePermission]
						, [ReadPermission]
						, [DeletePermission]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[AccessPrivilege].[PageRole].[PageRoleID]
					, [AccessPrivilege].[PageRole].[RoleID]
					, [AccessPrivilege].[PageRole].[PageID]
					, [AccessPrivilege].[PageRole].[CreatePermission]
					, [AccessPrivilege].[PageRole].[UpdatePermission]
					, [AccessPrivilege].[PageRole].[ReadPermission]
					, [AccessPrivilege].[PageRole].[DeletePermission]
					, [AccessPrivilege].[PageRole].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [AccessPrivilege].[PageRole].[IsActive]
				FROM 
					[AccessPrivilege].[PageRole]
				WHERE
					[AccessPrivilege].[PageRole].[PageRoleID] = @PageRoleID;
				
				UPDATE 
					[AccessPrivilege].[PageRole]
				SET
					[AccessPrivilege].[PageRole].[RoleID] = @RoleID
					, [AccessPrivilege].[PageRole].[PageID] = @PageID
					, [AccessPrivilege].[PageRole].[CreatePermission] = @CreatePermission
					, [AccessPrivilege].[PageRole].[UpdatePermission] = @UpdatePermission
					, [AccessPrivilege].[PageRole].[ReadPermission] = @ReadPermission
					, [AccessPrivilege].[PageRole].[DeletePermission] = @DeletePermission
					, [AccessPrivilege].[PageRole].[Comment] = @Comment
					, [AccessPrivilege].[PageRole].[LastModifiedBy] = @CurrentModificationBy
					, [AccessPrivilege].[PageRole].[LastModifiedOn] = @CurrentModificationOn
					, [AccessPrivilege].[PageRole].[IsActive] = @IsActive
				WHERE
					[AccessPrivilege].[PageRole].[PageRoleID] = @PageRoleID;				
			END
			ELSE
			BEGIN
				SELECT @PageRoleID = -2;
			END
		END
		ELSE IF @PageRoleID_PREV <> @PageRoleID
		BEGIN			
			SELECT @PageRoleID = -1;			
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
			SELECT @PageRoleID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
