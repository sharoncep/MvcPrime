USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_Update_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_Update_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the PatientVisit in the database.
	 
CREATE PROCEDURE [Patient].[usp_Update_PatientVisit]
	@PatientID BIGINT
	, @PatientHospitalizationID BIGINT = NULL
	, @DOS DATE
	, @IllnessIndicatorID TINYINT
	, @IllnessIndicatorDate DATE
	, @FacilityTypeID TINYINT
	, @FacilityDoneID INT = NULL
	, @PrimaryClaimDiagnosisID BIGINT = NULL
	, @DoctorNoteRelPath NVARCHAR(350) = NULL
	, @SuperBillRelPath NVARCHAR(350) = NULL
	, @PatientVisitDesc NVARCHAR(150) = NULL
	, @StatusIDs NVARCHAR(100)
	, @AssignedTo INT = NULL
	, @TargetBAUserID INT = NULL
	, @TargetQAUserID INT = NULL
	, @TargetEAUserID INT = NULL
	, @PatientVisitComplexity TINYINT
	, @Comment NVARCHAR(4000)
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @PatientVisitID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		DECLARE CUR_STS CURSOR LOCAL FAST_FORWARD READ_ONLY FOR SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ',');
		
		DECLARE @ClaimStatusID_STR NVARCHAR(100);
		
		OPEN CUR_STS;
		
		FETCH NEXT FROM CUR_STS INTO @ClaimStatusID_STR;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @ClaimStatusID TINYINT;
			SELECT @ClaimStatusID = CAST(@ClaimStatusID_STR AS TINYINT);
			
			DECLARE @PatientVisitID_PREV BIGINT;
			SELECT @PatientVisitID_PREV = [Patient].[ufn_IsExists_PatientVisit] (@PatientID, @PatientHospitalizationID, @DOS, @IllnessIndicatorID, @IllnessIndicatorDate, @FacilityTypeID, @FacilityDoneID, @PrimaryClaimDiagnosisID, @DoctorNoteRelPath, @SuperBillRelPath, @PatientVisitDesc, @ClaimStatusID, @AssignedTo, @TargetBAUserID, @TargetQAUserID, @TargetEAUserID, @PatientVisitComplexity, @Comment, 1);

			DECLARE @IS_ACTIVE_PREV BIT;
		
			IF EXISTS(SELECT [Patient].[PatientVisit].[PatientVisitID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID AND [Patient].[PatientVisit].[IsActive] = @IsActive)
			BEGIN
				SELECT @IS_ACTIVE_PREV = 1;
			END
			ELSE
			BEGIN
				SELECT @IS_ACTIVE_PREV = 0;
			END		

			IF ((@PatientVisitID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
			BEGIN
				DECLARE @LAST_MODIFIED_BY BIGINT;
				DECLARE @LAST_MODIFIED_ON DATETIME;
			
				SELECT 
					@LAST_MODIFIED_BY = [Patient].[PatientVisit].[LastModifiedBy]
					, @LAST_MODIFIED_ON =  [Patient].[PatientVisit].[LastModifiedOn]
				FROM 
					[Patient].[PatientVisit] WITH (NOLOCK)
				WHERE
					[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID;
				
				IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
				BEGIN
					-- VERIFY @ClaimStatusID STARTS
					
					DECLARE @ClaimStatusID_PREV TINYINT;
					SELECT @ClaimStatusID_PREV = [Patient].[PatientVisit].[ClaimStatusID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID;
					
					IF @ClaimStatusID_PREV <> @ClaimStatusID
					BEGIN
						-- @ClaimStatusID CHANGED. SO CLAIM PROCESS INSERT REQUIRED
						
						DECLARE @ClaimStatusIDClaimProcess TINYINT;
						DECLARE @AssignedToClaimProcess INT = NULL;
						DECLARE @StatusStartDate DATETIME = NULL;
						DECLARE @StatusEndDate DATETIME;
						DECLARE @StartEndMins BIGINT;
						DECLARE @LogOutLogInMins BIGINT;
						DECLARE @LockUnLockMins BIGINT;
							
						IF EXISTS (SELECT [Claim].[ClaimProcess].[ClaimProcessID] FROM [Claim].[ClaimProcess] WHERE [Claim].[ClaimProcess].[PatientVisitID] = @PatientVisitID)
						BEGIN
							SELECT
								@StatusStartDate = MAX([Claim].[ClaimProcess].[StatusEndDate])
							FROM
								[Claim].[ClaimProcess]
							WHERE
								[Claim].[ClaimProcess].[PatientVisitID] = @PatientVisitID;
						END
						
						SELECT
							@ClaimStatusIDClaimProcess = [Patient].[PatientVisit].[ClaimStatusID]
							, @AssignedToClaimProcess = [Patient].[PatientVisit].[AssignedTo]
							, @StatusStartDate = CASE WHEN @StatusStartDate IS NULL THEN [Patient].[PatientVisit].[DOS] ELSE @StatusStartDate END
						FROM
							[Patient].[PatientVisit]
						WHERE
							[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID;
						
						SELECT @StatusEndDate = @CurrentModificationOn;
						
						SELECT @StartEndMins = DATEDIFF(MINUTE, @StatusStartDate, @StatusEndDate);
						
						IF @AssignedToClaimProcess IS NULL
						BEGIN
							SELECT @LogOutLogInMins = 0;
							SELECT @LockUnLockMins = 0;
						END
						ELSE
						BEGIN
							DECLARE @TBL_LOG_IN TABLE
							(
								[LOG_IN_LOG_OUT_ID] [BIGINT] NOT NULL,
								[LOG_IN_ON] [DATETIME] NOT NULL,
								[LOG_OUT_ON] [DATETIME] NOT NULL,
								[USED_DURATION_MINS] [BIGINT] NOT NULL
							);
							
							INSERT INTO
								@TBL_LOG_IN
							SELECT
								[Audit].[LogInLogOut].[LogInLogOutID] AS [LOG_IN_LOG_OUT_ID]
								, [Audit].[LogInLogOut].[LogInOn] AS [LOG_IN_ON]
								, ISNULL([Audit].[LogInLogOut].[LogOutOn], @StatusEndDate) AS [LOG_OUT_ON]
								, '0' AS [USED_DURATION_MINS]
							FROM
								[Audit].[LogInLogOut]
							WHERE
								[Audit].[LogInLogOut].[UserID] = @AssignedToClaimProcess
							AND
							(
								[Audit].[LogInLogOut].[LogInOn] BETWEEN @StatusStartDate AND @StatusEndDate
							OR
								[Audit].[LogInLogOut].[LogOutOn] BETWEEN @StatusStartDate AND @StatusEndDate
							);
							
							DECLARE @DT_MIN DATETIME;
							
							SELECT @DT_MIN = MIN([LOG_IN_ON]) FROM @TBL_LOG_IN;
							IF @DT_MIN IS NULL
							BEGIN
								SELECT @DT_MIN = @StatusStartDate;
							END
							
							IF DATEDIFF(MINUTE, @StatusStartDate, @DT_MIN) > 0
							BEGIN
								INSERT INTO
									@TBL_LOG_IN
								SELECT
									'-1' AS [LOG_IN_LOG_OUT_ID]
									, @StatusStartDate AS [LOG_IN_ON]
									, @StatusStartDate AS [LOG_OUT_ON]
									, '0' AS [USED_DURATION_MINS];
							END
							ELSE
							BEGIN
								UPDATE
									@TBL_LOG_IN
								SET
									[LOG_IN_ON] = @StatusStartDate
								WHERE
									[LOG_IN_LOG_OUT_ID] = 
									(
										SELECT
											MIN([LOG_IN_LOG_OUT_ID])
										FROM
											@TBL_LOG_IN
									);
							END
							
							DECLARE @DT_MAX DATETIME;
							
							SELECT @DT_MAX = MAX([LOG_OUT_ON]) FROM @TBL_LOG_IN;
							IF @DT_MAX IS NULL
							BEGIN
								SELECT @DT_MAX = @StatusEndDate;
							END
							
							IF DATEDIFF(MINUTE, @DT_MAX, @StatusEndDate) > 0
							BEGIN
								INSERT INTO
									@TBL_LOG_IN
								SELECT
									'-1' AS [LOG_IN_LOG_OUT_ID]
									, @StatusEndDate AS [LOG_IN_ON]
									, @StatusEndDate AS [LOG_OUT_ON]
									, '0' AS [USED_DURATION_MINS];
							END
							ELSE
							BEGIN
								UPDATE
									@TBL_LOG_IN
								SET
									[LOG_OUT_ON] = @StatusEndDate
								WHERE
									[LOG_IN_LOG_OUT_ID] = 
									(
										SELECT
											MAX([LOG_IN_LOG_OUT_ID])
										FROM
											@TBL_LOG_IN
									);
							END
							
							UPDATE
								@TBL_LOG_IN
							SET
								[USED_DURATION_MINS] = DATEDIFF(MINUTE, [LOG_IN_ON], [LOG_OUT_ON]);
							
							SELECT @DT_MIN = MIN([LOG_IN_ON]) FROM @TBL_LOG_IN;
							IF @DT_MIN IS NULL
							BEGIN
								SELECT @DT_MIN = @StatusStartDate;
							END
							
							SELECT @DT_MAX = MAX([LOG_OUT_ON]) FROM @TBL_LOG_IN;
							IF @DT_MAX IS NULL
							BEGIN
								SELECT @DT_MAX = @StatusEndDate;
							END
							
							SELECT @LogOutLogInMins = DATEDIFF(MINUTE, @DT_MIN, @DT_MAX) - ISNULL((SELECT SUM([USED_DURATION_MINS]) FROM @TBL_LOG_IN), 0);
							
							-- Begin lock unlock table			
						
							DECLARE @TBL_LOCK TABLE 
							(
								[LOCK_UNLOCK_ID] [BIGINT] NOT NULL,
								[LOCK_ON] [DATETIME] NOT NULL,
								[UN_LOCK_ON] [DATETIME] NOT NULL,
								[UN_USED_DURATION_MINS] [BIGINT] NOT NULL
							);
							
							INSERT INTO
								@TBL_LOCK
							SELECT
								[Audit].[LockUnLock].[LockUnLockID] AS [LOCK_UNLOCK_ID]
								, [Audit].[LockUnLock].[LockOn] AS [LOCK_ON]
								, ISNULL([Audit].[LockUnLock].[UnLockOn], @StatusEndDate) AS [UN_LOCK_ON]
								, '0' AS [UN_USED_DURATION_MINS]
							FROM
								[Audit].[LockUnLock]
							WHERE
								[Audit].[LockUnLock].[UserID] = @AssignedToClaimProcess
							AND
							(
								[Audit].[LockUnLock].[LockOn] BETWEEN @StatusStartDate AND @StatusEndDate
							OR
								[Audit].[LockUnLock].[UnLockOn] BETWEEN @StatusStartDate AND @StatusEndDate
							);				
							
							SELECT @DT_MIN = MIN([LOCK_ON]) FROM @TBL_LOCK;
							IF @DT_MIN IS NULL
							BEGIN
								SELECT @DT_MIN = @StatusStartDate;
							END
							
							IF DATEDIFF(MINUTE, @StatusStartDate, @DT_MIN) > 0
							BEGIN
								INSERT INTO
									@TBL_LOCK
								SELECT
									'-1' AS [LOCK_UNLOCK_ID]
									, @StatusStartDate AS [LOCK_ON]
									, @StatusStartDate AS [UN_LOCK_ON]
									, '0' AS [UN_USED_DURATION_MINS];
							END
							ELSE
							BEGIN
								UPDATE
									@TBL_LOCK
								SET
									[LOCK_ON] = @StatusStartDate
								WHERE
									[LOCK_UNLOCK_ID] = 
									(
										SELECT
											MIN([LOCK_UNLOCK_ID])
										FROM
											@TBL_LOCK
									);
							END
							
							SELECT @DT_MAX = MAX([UN_LOCK_ON]) FROM @TBL_LOCK;
							IF @DT_MAX IS NULL
							BEGIN
								SELECT @DT_MAX = @StatusEndDate;
							END
							
							IF DATEDIFF(MINUTE, @DT_MAX, @StatusEndDate) > 0
							BEGIN
								INSERT INTO
									@TBL_LOCK
								SELECT
									'-1' AS [LOCK_UNLOCK_ID]
									, @StatusEndDate AS [LOCK_ON]
									, @StatusEndDate AS [UN_LOCK_ON]
									, '0' AS [UN_USED_DURATION_MINS];
							END
							ELSE
							BEGIN
								UPDATE
									@TBL_LOCK
								SET
									[LOCK_ON] = @StatusEndDate
								WHERE
									[LOCK_UNLOCK_ID] = 
									(
										SELECT
											MAX([LOCK_UNLOCK_ID])
										FROM
											@TBL_LOCK
									);
							END
							
							UPDATE
								@TBL_LOCK
							SET
								[UN_USED_DURATION_MINS] = DATEDIFF(MINUTE, [LOCK_ON], [UN_LOCK_ON]);
							
							SELECT @DT_MIN = MIN([LOCK_ON]) FROM @TBL_LOCK;
							IF @DT_MIN IS NULL
							BEGIN
								SELECT @DT_MIN = @StatusStartDate;
							END
							
							SELECT @DT_MAX = MAX([UN_LOCK_ON]) FROM @TBL_LOCK;
							IF @DT_MAX IS NULL
							BEGIN
								SELECT @DT_MAX = @StatusEndDate;
							END
							
							SELECT @LockUnlockMins = ISNULL((SELECT SUM([UN_USED_DURATION_MINS]) FROM @TBL_LOCK), 0);
							
							--End Lock Unlock
						END
					
						DECLARE @DurationMins BIGINT;
						SELECT @DurationMins = @StartEndMins - (@LogOutLogInMins + @LockUnLockMins);
						
						DECLARE @CommentClaimProcess NVARCHAR(4000);
						SELECT @CommentClaimProcess = [Patient].[PatientVisit].[Comment] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID
					
						INSERT INTO [Claim].[ClaimProcess]
						(
							[PatientVisitID]
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
						VALUES
						(
							@PatientVisitID
							, @ClaimStatusIDClaimProcess
							, @AssignedToClaimProcess
							, @StatusStartDate
							, @StatusEndDate
							, @StartEndMins
							, @LogOutLogInMins
							, @LockUnLockMins
							, @DurationMins
							, @CommentClaimProcess
							, @CurrentModificationBy
							, @CurrentModificationOn
							, @CurrentModificationBy
							, @CurrentModificationOn
							, 1
						);
					END
					
					-- VERIFY @ClaimStatusID ENDS
				
					INSERT INTO 
						[PatientVisitHistory]
						(
							[PatientVisitID]
							, [PatientID]
							, [PatientHospitalizationID]
							, [DOS]
							, [IllnessIndicatorID]
							, [IllnessIndicatorDate]
							, [FacilityTypeID]
							, [FacilityDoneID]
							, [PrimaryClaimDiagnosisID]
							, [DoctorNoteRelPath]
							, [SuperBillRelPath]
							, [PatientVisitDesc]
							, [ClaimStatusID]
							, [AssignedTo]
							, [TargetBAUserID]
							, [TargetQAUserID]
							, [TargetEAUserID]
							, [PatientVisitComplexity]
							, [Comment]
							, [CreatedBy]
							, [CreatedOn]
							, [LastModifiedBy]
							, [LastModifiedOn]
							, [IsActive]
						)
					SELECT
						[Patient].[PatientVisit].[PatientVisitID]
						, [Patient].[PatientVisit].[PatientID]
						, [Patient].[PatientVisit].[PatientHospitalizationID]
						, [Patient].[PatientVisit].[DOS]
						, [Patient].[PatientVisit].[IllnessIndicatorID]
						, [Patient].[PatientVisit].[IllnessIndicatorDate]
						, [Patient].[PatientVisit].[FacilityTypeID]
						, [Patient].[PatientVisit].[FacilityDoneID]
						, [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
						, [Patient].[PatientVisit].[DoctorNoteRelPath]
						, [Patient].[PatientVisit].[SuperBillRelPath]
						, [Patient].[PatientVisit].[PatientVisitDesc]
						, [Patient].[PatientVisit].[ClaimStatusID]
						, [Patient].[PatientVisit].[AssignedTo]
						, [Patient].[PatientVisit].[TargetBAUserID]
						, [Patient].[PatientVisit].[TargetQAUserID]
						, [Patient].[PatientVisit].[TargetEAUserID]
						, [Patient].[PatientVisit].[PatientVisitComplexity]
						, [Patient].[PatientVisit].[Comment]
						, @CurrentModificationBy
						, @CurrentModificationOn
						, @LastModifiedBy
						, @LastModifiedOn
						, [Patient].[PatientVisit].[IsActive]
					FROM 
						[Patient].[PatientVisit]
					WHERE
						[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID;
					
					UPDATE 
						[Patient].[PatientVisit]
					SET
						[Patient].[PatientVisit].[PatientID] = @PatientID
						, [Patient].[PatientVisit].[PatientHospitalizationID] = @PatientHospitalizationID
						, [Patient].[PatientVisit].[DOS] = @DOS
						, [Patient].[PatientVisit].[IllnessIndicatorID] = @IllnessIndicatorID
						, [Patient].[PatientVisit].[IllnessIndicatorDate] = @IllnessIndicatorDate
						, [Patient].[PatientVisit].[FacilityTypeID] = @FacilityTypeID
						, [Patient].[PatientVisit].[FacilityDoneID] = @FacilityDoneID
						, [Patient].[PatientVisit].[PrimaryClaimDiagnosisID] = @PrimaryClaimDiagnosisID
						, [Patient].[PatientVisit].[DoctorNoteRelPath] = @DoctorNoteRelPath
						, [Patient].[PatientVisit].[SuperBillRelPath] = @SuperBillRelPath
						, [Patient].[PatientVisit].[PatientVisitDesc] = @PatientVisitDesc
						, [Patient].[PatientVisit].[ClaimStatusID] = @ClaimStatusID
						, [Patient].[PatientVisit].[AssignedTo] = @AssignedTo
						, [Patient].[PatientVisit].[TargetBAUserID] = @TargetBAUserID
						, [Patient].[PatientVisit].[TargetQAUserID] = @TargetQAUserID
						, [Patient].[PatientVisit].[TargetEAUserID] = @TargetEAUserID
						, [Patient].[PatientVisit].[PatientVisitComplexity] = @PatientVisitComplexity
						, [Patient].[PatientVisit].[Comment] = @Comment
						, [Patient].[PatientVisit].[LastModifiedBy] = @CurrentModificationBy
						, [Patient].[PatientVisit].[LastModifiedOn] = @CurrentModificationOn
						, [Patient].[PatientVisit].[IsActive] = @IsActive
					WHERE
						[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID;
						
					SELECT @LastModifiedBy = @CurrentModificationBy;
					SELECT @LastModifiedOn = @CurrentModificationOn;
				END
				--ELSE
				--BEGIN
				--	SELECT @PatientVisitID = -2;		-- THIS CAN'T BE RETURED IN THIS SP ONLY
				--END
			END
			--ELSE IF @PatientVisitID_PREV <> @PatientVisitID
			--BEGIN			
			--	SELECT @PatientVisitID = -1;			-- THIS CAN'T BE RETURED IN THIS SP ONLY
			--END
			-- ELSE
			-- BEGIN
			--	 SELECT @CurrentModificationOn = @LastModifiedOn;
			-- END
			
			FETCH NEXT FROM CUR_STS INTO @ClaimStatusID_STR;
		END
		
		CLOSE CUR_STS;
		DEALLOCATE CUR_STS;
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY			
			EXEC [Audit].[usp_Insert_ErrorLog];			
			SELECT @PatientVisitID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
