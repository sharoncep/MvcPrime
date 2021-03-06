USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_Update_LogInLogOut]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_Update_LogInLogOut]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Audit].[usp_Update_LogInLogOut]
	  @LogInLogOutID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME
		SELECT @CurrentModificationOn = GETDATE();
	
		UPDATE 
			[Audit].[LogInLogOut] 
		SET 
			[Audit].[LogInLogOut].[LogOutOn] = @CurrentModificationOn
		WHERE 
			[Audit].[LogInLogOut].[LogInLogOutID] = @LogInLogOutID;
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
