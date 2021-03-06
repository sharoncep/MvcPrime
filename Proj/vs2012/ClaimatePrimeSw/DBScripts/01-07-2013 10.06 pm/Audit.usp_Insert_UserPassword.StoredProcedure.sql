USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_Insert_UserPassword]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_Insert_UserPassword]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to INSERT the UserPassworddetails into the table before rollback.
 
CREATE PROCEDURE [Audit].[usp_Insert_UserPassword]
	@UserID int
	, @Password NVARCHAR(200)
	, @AllCapsPassword NVARCHAR(200)
	, @CreatedBy INT
	, @UserPasswordID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CreatedOn DATETIME;
		SELECT @CreatedOn = GETDATE();
		
		INSERT INTO [Audit].[UserPassword]
		(
			[UserID]
			, [Password]
			, [AllCapsPassword]
			, [CreatedBy]
			, [CreatedOn]
		)
		VALUES
		(
			@UserID
			, @Password
			, @AllCapsPassword
			, @CreatedBy
			, @CreatedOn

		);
			
		SELECT @UserPasswordID = MAX([Audit].[UserPassword].[UserPasswordID]) FROM [Audit].[UserPassword];
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @UserPasswordID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
