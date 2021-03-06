USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_Insert_LockUnLock]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_Insert_LockUnLock]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Audit].[usp_Insert_LockUnLock]
	@UserID INT
	, @LockUnLockID BIGINT OUTPUT
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

		INSERT INTO [Audit].[LockUnLock] 
		(
			  [UserID]
			, [LockOn]
		)
		VALUES 
		(
			@UserID
			, @CurrentModificationOn
		);		
		
		SELECT @LockUnLockID = MAX([Audit].[LockUnLock].[LockUnLockID]) FROM [Audit].[LockUnLock];		
   END TRY
   BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @LockUnLockID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
