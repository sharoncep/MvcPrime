USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_Update_General]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_Update_General]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the General in the database.
	 
CREATE PROCEDURE [Configuration].[usp_Update_General]
	@UserAccEmailSubject NVARCHAR(100)
	, @SearchRecordPerPage TINYINT
	, @UploadMaxSizeInMB TINYINT
	, @PageLockIdleTimeInMin TINYINT
	, @SessionOutFromPageLockInMin TINYINT
	, @BACompleteFromDOSInDay TINYINT
	, @QACompleteFromDOSInDay TINYINT
	, @EDIFileSentFromDOSInDay TINYINT
	, @ClaimDoneFromDOSInDay TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @GeneralID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @GeneralID_PREV BIGINT;
		SELECT @GeneralID_PREV = [Configuration].[ufn_IsExists_General] (@UserAccEmailSubject, @SearchRecordPerPage, @UploadMaxSizeInMB, @PageLockIdleTimeInMin, @SessionOutFromPageLockInMin, @BACompleteFromDOSInDay, @QACompleteFromDOSInDay, @EDIFileSentFromDOSInDay, @ClaimDoneFromDOSInDay, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Configuration].[General].[GeneralID] FROM [Configuration].[General] WHERE [Configuration].[General].[GeneralID] = @GeneralID AND [Configuration].[General].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@GeneralID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Configuration].[General].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Configuration].[General].[LastModifiedOn]
			FROM 
				[Configuration].[General] WITH (NOLOCK)
			WHERE
				[Configuration].[General].[GeneralID] = @GeneralID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Configuration].[GeneralHistory]
					(
						[GeneralID]
						, [UserAccEmailSubject]
						, [SearchRecordPerPage]
						, [UploadMaxSizeInMB]
						, [PageLockIdleTimeInMin]
						, [SessionOutFromPageLockInMin]
						, [BACompleteFromDOSInDay]
						, [QACompleteFromDOSInDay]
						, [EDIFileSentFromDOSInDay]
						, [ClaimDoneFromDOSInDay]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Configuration].[General].[GeneralID]
					, [Configuration].[General].[UserAccEmailSubject]
					, [Configuration].[General].[SearchRecordPerPage]
					, [Configuration].[General].[UploadMaxSizeInMB]
					, [Configuration].[General].[PageLockIdleTimeInMin]
					, [Configuration].[General].[SessionOutFromPageLockInMin]
					, [Configuration].[General].[BACompleteFromDOSInDay]
					, [Configuration].[General].[QACompleteFromDOSInDay]
					, [Configuration].[General].[EDIFileSentFromDOSInDay]
					, [Configuration].[General].[ClaimDoneFromDOSInDay]
					, [Configuration].[General].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Configuration].[General].[IsActive]
				FROM 
					[Configuration].[General]
				WHERE
					[Configuration].[General].[GeneralID] = @GeneralID;
				
				UPDATE 
					[Configuration].[General]
				SET
					[Configuration].[General].[UserAccEmailSubject] = @UserAccEmailSubject
					, [Configuration].[General].[SearchRecordPerPage] = @SearchRecordPerPage
					, [Configuration].[General].[UploadMaxSizeInMB] = @UploadMaxSizeInMB
					, [Configuration].[General].[PageLockIdleTimeInMin] = @PageLockIdleTimeInMin
					, [Configuration].[General].[SessionOutFromPageLockInMin] = @SessionOutFromPageLockInMin
					, [Configuration].[General].[BACompleteFromDOSInDay] = @BACompleteFromDOSInDay
					, [Configuration].[General].[QACompleteFromDOSInDay] = @QACompleteFromDOSInDay
					, [Configuration].[General].[EDIFileSentFromDOSInDay] = @EDIFileSentFromDOSInDay
					, [Configuration].[General].[ClaimDoneFromDOSInDay] = @ClaimDoneFromDOSInDay
					, [Configuration].[General].[Comment] = @Comment
					, [Configuration].[General].[LastModifiedBy] = @CurrentModificationBy
					, [Configuration].[General].[LastModifiedOn] = @CurrentModificationOn
					, [Configuration].[General].[IsActive] = @IsActive
				WHERE
					[Configuration].[General].[GeneralID] = @GeneralID;				
			END
			ELSE
			BEGIN
				SELECT @GeneralID = -2;
			END
		END
		ELSE IF @GeneralID_PREV <> @GeneralID
		BEGIN			
			SELECT @GeneralID = -1;			
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
			SELECT @GeneralID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
