USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_Insert_UserClinicSelect]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_Insert_UserClinicSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select all records from the table

CREATE PROCEDURE [Audit].[usp_Insert_UserClinicSelect]
	@UserID INT
	, @ClinicID INT
	, @UserClinicSelectID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		IF @UserClinicSelectID = 0
		BEGIN
			INSERT INTO [Audit].[UserClinicSelect]
			(
				[UserID]
			   , [ClinicID]
			   , [AuditOn]
			)
			VALUES
			(
				@UserID 
				, @ClinicID 
				, @CurrentModificationOn 
			);
			
			SELECT @UserClinicSelectID = MAX([Audit].[UserClinicSelect].[UserClinicSelectID]) FROM [Audit].[UserClinicSelect];
		END
		ELSE
		BEGIN			
			SELECT @UserClinicSelectID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @UserClinicSelectID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
