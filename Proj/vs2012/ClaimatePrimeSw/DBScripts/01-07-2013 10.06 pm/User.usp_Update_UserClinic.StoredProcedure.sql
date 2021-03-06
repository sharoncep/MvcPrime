USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [User].[usp_Update_UserClinic]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [User].[usp_Update_UserClinic]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the UserClinic in the database.
	 
CREATE PROCEDURE [User].[usp_Update_UserClinic]
	@UserID INT
	, @ClinicID INT
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @UserClinicID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @UserClinicID_PREV BIGINT;
		SELECT @UserClinicID_PREV = [User].[ufn_IsExists_UserClinic] (@UserID, @ClinicID, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [User].[UserClinic].[UserClinicID] FROM [User].[UserClinic] WHERE [User].[UserClinic].[UserClinicID] = @UserClinicID AND [User].[UserClinic].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@UserClinicID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [User].[UserClinic].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [User].[UserClinic].[LastModifiedOn]
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			WHERE
				[User].[UserClinic].[UserClinicID] = @UserClinicID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[User].[UserClinicHistory]
					(
						[UserClinicID]
						, [UserID]
						, [ClinicID]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[User].[UserClinic].[UserClinicID]
					, [User].[UserClinic].[UserID]
					, [User].[UserClinic].[ClinicID]
					, [User].[UserClinic].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [User].[UserClinic].[IsActive]
				FROM 
					[User].[UserClinic]
				WHERE
					[User].[UserClinic].[UserClinicID] = @UserClinicID;
				
				UPDATE 
					[User].[UserClinic]
				SET
					[User].[UserClinic].[UserID] = @UserID
					, [User].[UserClinic].[ClinicID] = @ClinicID
					, [User].[UserClinic].[Comment] = @Comment
					, [User].[UserClinic].[LastModifiedBy] = @CurrentModificationBy
					, [User].[UserClinic].[LastModifiedOn] = @CurrentModificationOn
					, [User].[UserClinic].[IsActive] = @IsActive
				WHERE
					[User].[UserClinic].[UserClinicID] = @UserClinicID;				
			END
			ELSE
			BEGIN
				SELECT @UserClinicID = -2;
			END
		END
		ELSE IF @UserClinicID_PREV <> @UserClinicID
		BEGIN			
			SELECT @UserClinicID = -1;			
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
			SELECT @UserClinicID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
