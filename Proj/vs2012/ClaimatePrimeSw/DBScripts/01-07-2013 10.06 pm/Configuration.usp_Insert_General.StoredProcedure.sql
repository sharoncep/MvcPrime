USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_Insert_General]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_Insert_General]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Configuration].[usp_Insert_General]
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
	, @CurrentModificationBy BIGINT
	, @GeneralID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @GeneralID = [Configuration].[ufn_IsExists_General] (@UserAccEmailSubject, @SearchRecordPerPage, @UploadMaxSizeInMB, @PageLockIdleTimeInMin, @SessionOutFromPageLockInMin, @BACompleteFromDOSInDay, @QACompleteFromDOSInDay, @EDIFileSentFromDOSInDay, @ClaimDoneFromDOSInDay, @Comment, 0);
		
		IF @GeneralID = 0
		BEGIN
			INSERT INTO [Configuration].[General]
			(
				[UserAccEmailSubject]
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
			VALUES
			(
				@UserAccEmailSubject
				, @SearchRecordPerPage
				, @UploadMaxSizeInMB
				, @PageLockIdleTimeInMin
				, @SessionOutFromPageLockInMin
				, @BACompleteFromDOSInDay
				, @QACompleteFromDOSInDay
				, @EDIFileSentFromDOSInDay
				, @ClaimDoneFromDOSInDay
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @GeneralID = MAX([Configuration].[General].[GeneralID]) FROM [Configuration].[General];
		END
		ELSE
		BEGIN			
			SELECT @GeneralID = -1;
		END		
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
