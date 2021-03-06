USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_Insert_UserRoleSelect]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_Insert_UserRoleSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Audit].[usp_Insert_UserRoleSelect]
	@UserID INT
	, @RoleID INT
	, @UserRoleSelectID BIGINT OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		IF @UserRoleSelectID = 0
		BEGIN
			INSERT INTO [Audit].[UserRoleSelect]
			(
				[UserID]
			   , [RoleID]
			   , [AuditOn]
			)
			VALUES
			(
				@UserID 
				, @RoleID 
				, @CurrentModificationOn 
			);
			
			SELECT @UserRoleSelectID = MAX([Audit].[UserRoleSelect].[UserRoleSelectID]) FROM [Audit].[UserRoleSelect];
		END
		ELSE
		BEGIN			
			SELECT @UserRoleSelectID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @UserRoleSelectID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
