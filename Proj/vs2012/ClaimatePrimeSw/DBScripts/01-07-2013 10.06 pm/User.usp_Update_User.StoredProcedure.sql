USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_Update_User]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_Update_User]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the User in the database.
	 
CREATE PROCEDURE [User].[usp_Update_User]
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
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @UserID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @UserID_PREV BIGINT;
		SELECT @UserID_PREV = [User].[ufn_IsExists_User] (@UserName, @Password, @Email, @LastName, @MiddleName, @FirstName, @PhoneNumber, @ManagerID, @PhotoRelPath, @AlertChangePassword, @Comment, @IsBlocked, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [User].[User].[UserID] FROM [User].[User] WHERE [User].[User].[UserID] = @UserID AND [User].[User].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@UserID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [User].[User].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [User].[User].[LastModifiedOn]
			FROM 
				[User].[User] WITH (NOLOCK)
			WHERE
				[User].[User].[UserID] = @UserID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[User].[UserHistory]
					(
						[UserID]
						, [UserName]
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
				SELECT
					[User].[User].[UserID]
					, [User].[User].[UserName]
					, [User].[User].[Password]
					, [User].[User].[Email]
					, [User].[User].[LastName]
					, [User].[User].[MiddleName]
					, [User].[User].[FirstName]
					, [User].[User].[PhoneNumber]
					, [User].[User].[ManagerID]
					, [User].[User].[PhotoRelPath]
					, [User].[User].[AlertChangePassword]
					, [User].[User].[Comment]
					, [User].[User].[IsBlocked]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [User].[User].[IsActive]
				FROM 
					[User].[User]
				WHERE
					[User].[User].[UserID] = @UserID;
				
				UPDATE 
					[User].[User]
				SET
					[User].[User].[UserName] = @UserName
					, [User].[User].[Password] = @Password
					, [User].[User].[Email] = @Email
					, [User].[User].[LastName] = @LastName
					, [User].[User].[MiddleName] = @MiddleName
					, [User].[User].[FirstName] = @FirstName
					, [User].[User].[PhoneNumber] = @PhoneNumber
					, [User].[User].[ManagerID] = @ManagerID
					, [User].[User].[PhotoRelPath] = @PhotoRelPath
					, [User].[User].[AlertChangePassword] = @AlertChangePassword
					, [User].[User].[Comment] = @Comment
					, [User].[User].[IsBlocked] = @IsBlocked
					, [User].[User].[LastModifiedBy] = @CurrentModificationBy
					, [User].[User].[LastModifiedOn] = @CurrentModificationOn
					, [User].[User].[IsActive] = @IsActive
				WHERE
					[User].[User].[UserID] = @UserID;				
			END
			ELSE
			BEGIN
				SELECT @UserID = -2;
			END
		END
		ELSE IF @UserID_PREV <> @UserID
		BEGIN			
			SELECT @UserID = -1;			
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
			SELECT @UserID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
