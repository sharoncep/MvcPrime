USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_Insert_LogInLogOut]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_Insert_LogInLogOut]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Audit].[usp_Insert_LogInLogOut]
	  @UserID INT
	, @ClientHostIPAddress NVARCHAR(128)
	, @ClientHostName NVARCHAR(512)
	, @SessionID NVARCHAR(4000)
	, @LogInLogOutID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
    BEGIN TRY	
		DECLARE @CurrentModificationOn DATETIME
		SELECT @CurrentModificationOn = GETDATE();
		
		UPDATE 
			[Audit].[LockUnLock]
		SET
			[UnLockOn] = @CurrentModificationOn
		WHERE
			[Audit].[LockUnLock].[UserID] = @UserID 
		AND 
			[Audit].[LockUnLock].[UnLockOn] IS NULL;
		
		UPDATE
			[Audit].[LogInLogOut] 
		SET
			[LogOutOn] = @CurrentModificationOn
		WHERE 
			[Audit].[LogInLogOut].[UserID] = @UserID 
		AND 
			[Audit].[LogInLogOut].[LogOutOn] IS NULL;	

		INSERT INTO [Audit].[LogInLogOut] 
		(
			  [UserID]
			, [LogInOn]
			, [ClientHostIPAddress]
			, [ClientHostName]
			, [SessionID]
		)
		VALUES 
		(
			@UserID
			, @CurrentModificationOn
			, @ClientHostIPAddress
			, @ClientHostName
			, @SessionID
		);		
		
		SELECT @LogInLogOutID = MAX([Audit].[LogInLogOut].[LogInLogOutID]) FROM [Audit].[LogInLogOut];		
   END TRY
   BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @LogInLogOutID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
