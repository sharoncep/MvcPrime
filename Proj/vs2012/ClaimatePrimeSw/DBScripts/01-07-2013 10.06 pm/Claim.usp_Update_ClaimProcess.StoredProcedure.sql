USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_Update_ClaimProcess]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_Update_ClaimProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the ClaimProcess in the database.
	 
CREATE PROCEDURE [Claim].[usp_Update_ClaimProcess]
	@PatientVisitID BIGINT
	, @ClaimStatusID TINYINT
	, @AssignedTo INT = NULL
	, @StatusStartDate DATETIME
	, @StatusEndDate DATETIME
	, @StartEndMins BIGINT
	, @LogOutLogInMins BIGINT
	, @LockUnLockMins BIGINT
	, @DurationMins BIGINT
	, @Comment NVARCHAR(4000)
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @ClaimProcessID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @ClaimProcessID_PREV BIGINT;
		SELECT @ClaimProcessID_PREV = [Claim].[ufn_IsExists_ClaimProcess] (@PatientVisitID, @ClaimStatusID, @AssignedTo, @StatusStartDate, @StatusEndDate, @StartEndMins, @LogOutLogInMins, @LockUnLockMins, @DurationMins, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Claim].[ClaimProcess].[ClaimProcessID] FROM [Claim].[ClaimProcess] WHERE [Claim].[ClaimProcess].[ClaimProcessID] = @ClaimProcessID AND [Claim].[ClaimProcess].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@ClaimProcessID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Claim].[ClaimProcess].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Claim].[ClaimProcess].[LastModifiedOn]
			FROM 
				[Claim].[ClaimProcess] WITH (NOLOCK)
			WHERE
				[Claim].[ClaimProcess].[ClaimProcessID] = @ClaimProcessID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Claim].[ClaimProcessHistory]
					(
						[ClaimProcessID]
						, [PatientVisitID]
						, [ClaimStatusID]
						, [AssignedTo]
						, [StatusStartDate]
						, [StatusEndDate]
						, [StartEndMins]
						, [LogOutLogInMins]
						, [LockUnLockMins]
						, [DurationMins]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Claim].[ClaimProcess].[ClaimProcessID]
					, [Claim].[ClaimProcess].[PatientVisitID]
					, [Claim].[ClaimProcess].[ClaimStatusID]
					, [Claim].[ClaimProcess].[AssignedTo]
					, [Claim].[ClaimProcess].[StatusStartDate]
					, [Claim].[ClaimProcess].[StatusEndDate]
					, [Claim].[ClaimProcess].[StartEndMins]
					, [Claim].[ClaimProcess].[LogOutLogInMins]
					, [Claim].[ClaimProcess].[LockUnLockMins]
					, [Claim].[ClaimProcess].[DurationMins]
					, [Claim].[ClaimProcess].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Claim].[ClaimProcess].[IsActive]
				FROM 
					[Claim].[ClaimProcess]
				WHERE
					[Claim].[ClaimProcess].[ClaimProcessID] = @ClaimProcessID;
				
				UPDATE 
					[Claim].[ClaimProcess]
				SET
					[Claim].[ClaimProcess].[PatientVisitID] = @PatientVisitID
					, [Claim].[ClaimProcess].[ClaimStatusID] = @ClaimStatusID
					, [Claim].[ClaimProcess].[AssignedTo] = @AssignedTo
					, [Claim].[ClaimProcess].[StatusStartDate] = @StatusStartDate
					, [Claim].[ClaimProcess].[StatusEndDate] = @StatusEndDate
					, [Claim].[ClaimProcess].[StartEndMins] = @StartEndMins
					, [Claim].[ClaimProcess].[LogOutLogInMins] = @LogOutLogInMins
					, [Claim].[ClaimProcess].[LockUnLockMins] = @LockUnLockMins
					, [Claim].[ClaimProcess].[DurationMins] = @DurationMins
					, [Claim].[ClaimProcess].[Comment] = @Comment
					, [Claim].[ClaimProcess].[LastModifiedBy] = @CurrentModificationBy
					, [Claim].[ClaimProcess].[LastModifiedOn] = @CurrentModificationOn
					, [Claim].[ClaimProcess].[IsActive] = @IsActive
				WHERE
					[Claim].[ClaimProcess].[ClaimProcessID] = @ClaimProcessID;				
			END
			ELSE
			BEGIN
				SELECT @ClaimProcessID = -2;
			END
		END
		ELSE IF @ClaimProcessID_PREV <> @ClaimProcessID
		BEGIN			
			SELECT @ClaimProcessID = -1;			
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
			SELECT @ClaimProcessID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
