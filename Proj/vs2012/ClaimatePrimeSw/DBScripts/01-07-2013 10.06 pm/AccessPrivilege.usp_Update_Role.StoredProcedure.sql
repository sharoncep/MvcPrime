USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [AccessPrivilege].[usp_Update_Role]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [AccessPrivilege].[usp_Update_Role]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Role in the database.
	 
CREATE PROCEDURE [AccessPrivilege].[usp_Update_Role]
	@RoleCode NVARCHAR(2)
	, @RoleName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @RoleID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @RoleID_PREV BIGINT;
		SELECT @RoleID_PREV = [AccessPrivilege].[ufn_IsExists_Role] (@RoleCode, @RoleName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [AccessPrivilege].[Role].[RoleID] FROM [AccessPrivilege].[Role] WHERE [AccessPrivilege].[Role].[RoleID] = @RoleID AND [AccessPrivilege].[Role].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@RoleID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [AccessPrivilege].[Role].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [AccessPrivilege].[Role].[LastModifiedOn]
			FROM 
				[AccessPrivilege].[Role] WITH (NOLOCK)
			WHERE
				[AccessPrivilege].[Role].[RoleID] = @RoleID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[AccessPrivilege].[RoleHistory]
					(
						[RoleID]
						, [RoleCode]
						, [RoleName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[AccessPrivilege].[Role].[RoleID]
					, [AccessPrivilege].[Role].[RoleCode]
					, [AccessPrivilege].[Role].[RoleName]
					, [AccessPrivilege].[Role].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [AccessPrivilege].[Role].[IsActive]
				FROM 
					[AccessPrivilege].[Role]
				WHERE
					[AccessPrivilege].[Role].[RoleID] = @RoleID;
				
				UPDATE 
					[AccessPrivilege].[Role]
				SET
					[AccessPrivilege].[Role].[RoleCode] = @RoleCode
					, [AccessPrivilege].[Role].[RoleName] = @RoleName
					, [AccessPrivilege].[Role].[Comment] = @Comment
					, [AccessPrivilege].[Role].[LastModifiedBy] = @CurrentModificationBy
					, [AccessPrivilege].[Role].[LastModifiedOn] = @CurrentModificationOn
					, [AccessPrivilege].[Role].[IsActive] = @IsActive
				WHERE
					[AccessPrivilege].[Role].[RoleID] = @RoleID;				
			END
			ELSE
			BEGIN
				SELECT @RoleID = -2;
			END
		END
		ELSE IF @RoleID_PREV <> @RoleID
		BEGIN			
			SELECT @RoleID = -1;			
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
			SELECT @RoleID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
