USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_Update_UserRole]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_Update_UserRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the UserRole in the database.
	 
CREATE PROCEDURE [User].[usp_Update_UserRole]
	@UserID INT
	, @RoleID TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @UserRoleID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @UserRoleID_PREV BIGINT;
		SELECT @UserRoleID_PREV = [User].[ufn_IsExists_UserRole] (@UserID, @RoleID, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [User].[UserRole].[UserRoleID] FROM [User].[UserRole] WHERE [User].[UserRole].[UserRoleID] = @UserRoleID AND [User].[UserRole].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@UserRoleID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [User].[UserRole].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [User].[UserRole].[LastModifiedOn]
			FROM 
				[User].[UserRole] WITH (NOLOCK)
			WHERE
				[User].[UserRole].[UserRoleID] = @UserRoleID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[User].[UserRoleHistory]
					(
						[UserRoleID]
						, [UserID]
						, [RoleID]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[User].[UserRole].[UserRoleID]
					, [User].[UserRole].[UserID]
					, [User].[UserRole].[RoleID]
					, [User].[UserRole].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [User].[UserRole].[IsActive]
				FROM 
					[User].[UserRole]
				WHERE
					[User].[UserRole].[UserRoleID] = @UserRoleID;
				
				UPDATE 
					[User].[UserRole]
				SET
					[User].[UserRole].[UserID] = @UserID
					, [User].[UserRole].[RoleID] = @RoleID
					, [User].[UserRole].[Comment] = @Comment
					, [User].[UserRole].[LastModifiedBy] = @CurrentModificationBy
					, [User].[UserRole].[LastModifiedOn] = @CurrentModificationOn
					, [User].[UserRole].[IsActive] = @IsActive
				WHERE
					[User].[UserRole].[UserRoleID] = @UserRoleID;				
			END
			ELSE
			BEGIN
				SELECT @UserRoleID = -2;
			END
		END
		ELSE IF @UserRoleID_PREV <> @UserRoleID
		BEGIN			
			SELECT @UserRoleID = -1;			
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
			SELECT @UserRoleID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
