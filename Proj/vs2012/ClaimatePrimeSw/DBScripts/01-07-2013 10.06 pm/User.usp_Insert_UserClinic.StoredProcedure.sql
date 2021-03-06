USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_Insert_UserClinic]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_Insert_UserClinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [User].[usp_Insert_UserClinic]
	@UserID INT
	, @ClinicID INT
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @UserClinicID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @UserClinicID = [User].[ufn_IsExists_UserClinic] (@UserID, @ClinicID, @Comment, 0);
		
		IF @UserClinicID = 0
		BEGIN
			INSERT INTO [User].[UserClinic]
			(
				[UserID]
				, [ClinicID]
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
				, @ClinicID
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @UserClinicID = MAX([User].[UserClinic].[UserClinicID]) FROM [User].[UserClinic];
		END
		ELSE
		BEGIN			
			SELECT @UserClinicID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @UserClinicID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
