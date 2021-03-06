USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_Insert_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_Insert_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [User].[usp_Insert_User]
	@UserName NVARCHAR(15)
	, @Password NVARCHAR(200)
	, @Email NVARCHAR(256)
	, @LastName NVARCHAR(150)
	, @MiddleName NVARCHAR(50) = NULL
	, @FirstName NVARCHAR(150)
	, @PhoneNumber NVARCHAR(13)
	, @ManagerID INT = NULL
	, @PhotoRelPath NVARCHAR(350) = NULL
	, @AlertChangePassword BIT
	, @Comment NVARCHAR(4000) = NULL
	, @IsBlocked BIT
	, @CurrentModificationBy BIGINT
	, @UserID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @UserID = [User].[ufn_IsExists_User] (@UserName, @Password, @Email, @LastName, @MiddleName, @FirstName, @PhoneNumber, @ManagerID, @PhotoRelPath, @AlertChangePassword, @Comment, @IsBlocked, 0);
		
		IF @UserID = 0
		BEGIN
			INSERT INTO [User].[User]
			(
				[UserName]
				, [Password]
				, [Email]
				, [LastName]
				, [MiddleName]
				, [FirstName]
				, [PhoneNumber]
				, [ManagerID]
				, [PhotoRelPath]
				, [AlertChangePassword]
				, [Comment]
				, [IsBlocked]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@UserName
				, @Password
				, @Email
				, @LastName
				, @MiddleName
				, @FirstName
				, @PhoneNumber
				, @ManagerID
				, @PhotoRelPath
				, @AlertChangePassword
				, @Comment
				, @IsBlocked
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @UserID = MAX([User].[User].[UserID]) FROM [User].[User];
		END
		ELSE
		BEGIN			
			SELECT @UserID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @UserID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
