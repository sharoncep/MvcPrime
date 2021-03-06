USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [AccessPrivilege].[usp_Insert_PageRole]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [AccessPrivilege].[usp_Insert_PageRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [AccessPrivilege].[usp_Insert_PageRole]
	@RoleID TINYINT
	, @PageID TINYINT
	, @CreatePermission BIT
	, @UpdatePermission BIT
	, @ReadPermission BIT
	, @DeletePermission BIT
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @PageRoleID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @PageRoleID = [AccessPrivilege].[ufn_IsExists_PageRole] (@RoleID, @PageID, @CreatePermission, @UpdatePermission, @ReadPermission, @DeletePermission, @Comment, 0);
		
		IF @PageRoleID = 0
		BEGIN
			INSERT INTO [AccessPrivilege].[PageRole]
			(
				[RoleID]
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
			VALUES
			(
				@RoleID
				, @PageID
				, @CreatePermission
				, @UpdatePermission
				, @ReadPermission
				, @DeletePermission
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @PageRoleID = MAX([AccessPrivilege].[PageRole].[PageRoleID]) FROM [AccessPrivilege].[PageRole];
		END
		ELSE
		BEGIN			
			SELECT @PageRoleID = -1;
		END		
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
