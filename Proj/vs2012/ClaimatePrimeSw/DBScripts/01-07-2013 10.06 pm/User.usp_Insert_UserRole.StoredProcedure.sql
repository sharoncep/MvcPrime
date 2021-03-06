USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_Insert_UserRole]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_Insert_UserRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [User].[usp_Insert_UserRole]
	@UserID INT
	, @RoleID TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @UserRoleID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @UserRoleID = [User].[ufn_IsExists_UserRole] (@UserID, @RoleID, @Comment, 0);
		
		IF @UserRoleID = 0
		BEGIN
			INSERT INTO [User].[UserRole]
			(
				[UserID]
				, [RoleID]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@UserID
				, @RoleID
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @UserRoleID = MAX([User].[UserRole].[UserRoleID]) FROM [User].[UserRole];
		END
		ELSE
		BEGIN			
			SELECT @UserRoleID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @UserRoleID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
