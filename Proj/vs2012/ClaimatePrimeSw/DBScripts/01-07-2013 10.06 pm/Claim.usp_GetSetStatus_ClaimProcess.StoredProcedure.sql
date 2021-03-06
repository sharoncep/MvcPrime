USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetSetStatus_ClaimProcess]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_GetSetStatus_ClaimProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetSetStatus_ClaimProcess]
	
AS
BEGIN
		SET NOCOUNT ON;
		
		DECLARE @BA_COMPLETE TINYINT;
		DECLARE @QA_COMPLETE TINYINT;
		DECLARE @EDI_FILE_SENT TINYINT;	
		DECLARE @CLAIM_DONE TINYINT;
		
		DECLARE @PATIENT_VISIT_ID BIGINT;
		DECLARE @DOS DATE;
		
		SELECT @BA_COMPLETE = [Configuration].[General].[BACompleteFromDOSInDay] FROM [Configuration].[General]
		SELECT @QA_COMPLETE = [Configuration].[General].[QACompleteFromDOSInDay] FROM [Configuration].[General]
		SELECT @EDI_FILE_SENT = [Configuration].[General].[EDIFileSentFromDOSInDay] FROM [Configuration].[General]
		SELECT @CLAIM_DONE = [Configuration].[General].[ClaimDoneFromDOSInDay] FROM [Configuration].[General]
		
		DECLARE CUR_DIAG CURSOR LOCAL FAST_FORWARD READ_ONLY FOR 
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID], [Patient].[PatientVisit].[DOS]
			FROM
				[Patient].[PatientVisit]
			WHERE 
				[Patient].[PatientVisit].[ClaimStatusID] NOT IN (30, 29, 27, 24, 20, 18, 14, 12, 8, 5, 3)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) >= @BA_COMPLETE
			ORDER BY
				[Patient].[PatientVisit].[DOS]
			ASC;
		
		DECLARE @CLAIM_DATE_DIFF BIGINT;
		DECLARE @CLAIM_STAT TINYINT;
		
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		DECLARE @CurrentModificationBy BIGINT
		SELECT @CurrentModificationBy = 1;
		
		
		OPEN CUR_DIAG;
		
		FETCH NEXT FROM CUR_DIAG INTO @PATIENT_VISIT_ID, @DOS;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @AUTO_COMMENT  NVARCHAR(4000);

			SELECT @AUTO_COMMENT = '';
			
			SELECT @CLAIM_DATE_DIFF = DATEDIFF(DAY, @DOS, GETDATE());
			SELECT @CLAIM_STAT = [Patient].[PatientVisit].[ClaimStatusID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientVisitID] = @PATIENT_VISIT_ID
			
			IF @CLAIM_DATE_DIFF >= @CLAIM_DONE
			BEGIN
				SELECT @AUTO_COMMENT = 'Status changed by automated job services on ' + CONVERT(NVARCHAR(10), GETDATE(), 101) + '. Reason : Claim not completed within ' + CAST(@CLAIM_DONE AS NVARCHAR(3)) + ' days.'
			END
			ELSE IF @CLAIM_DATE_DIFF >= @EDI_FILE_SENT
			BEGIN
				IF @CLAIM_STAT < 18
				BEGIN
					SELECT @AUTO_COMMENT = 'Status changed by automated job services on ' + CONVERT(NVARCHAR(10), GETDATE(), 101) + '. Reason : Claim not sent within ' + CAST(@EDI_FILE_SENT AS NVARCHAR(3)) + ' days.'
				END
			END
			ELSE IF @CLAIM_DATE_DIFF >= @QA_COMPLETE
			BEGIN
				IF @CLAIM_STAT < 13
				BEGIN
					SELECT @AUTO_COMMENT = 'Status changed by automated job services on ' + CONVERT(NVARCHAR(10), GETDATE(), 101) + '. Reason : Claim not verified within ' + CAST(@QA_COMPLETE AS NVARCHAR(3)) + ' days.'
				END
			END
			ELSE
			BEGIN
				SELECT @AUTO_COMMENT = 'Status changed by automated job services on ' + CONVERT(NVARCHAR(10), GETDATE(), 101) + '. Reason : Claim not created within ' + CAST(@BA_COMPLETE AS NVARCHAR(3)) + ' days.'
			END
		
			IF LEN (@AUTO_COMMENT) > 0
			BEGIN
				--INSERT CLAIM PROCESS START

				-- SHOULD CALL THIS SP BEFORE PATIENT VISIT UPDATE
				
				DECLARE @ClaimStatusID TINYINT;
				DECLARE @AssignedTo INT = NULL;
				DECLARE @StatusStartDate DATETIME = NULL;
				DECLARE @StatusEndDate DATETIME;
				DECLARE @StartEndMins BIGINT;
				DECLARE @LogOutLogInMins BIGINT;
				DECLARE @LockUnLockMins BIGINT;
				
				IF EXISTS (SELECT [Claim].[ClaimProcess].[ClaimProcessID] FROM [Claim].[ClaimProcess] WHERE [Claim].[ClaimProcess].[PatientVisitID] = @PATIENT_VISIT_ID)
				BEGIN
					SELECT
						@StatusStartDate = MAX([Claim].[ClaimProcess].[StatusEndDate])
					FROM
						[Claim].[ClaimProcess]
					WHERE
						[Claim].[ClaimProcess].[PatientVisitID] = @PATIENT_VISIT_ID;
				END
				
				SELECT
					@ClaimStatusID = [Patient].[PatientVisit].[ClaimStatusID]
					, @AssignedTo = [Patient].[PatientVisit].[AssignedTo]
					, @StatusStartDate = CASE WHEN @StatusStartDate IS NULL THEN [Patient].[PatientVisit].[DOS] ELSE @StatusStartDate END
				FROM
					[Patient].[PatientVisit]
				WHERE
					[Patient].[PatientVisit].[PatientVisitID] = @PATIENT_VISIT_ID;
				
				SELECT @StatusEndDate = @CurrentModificationOn;
				
				SELECT @StartEndMins = DATEDIFF(MINUTE, @StatusStartDate, @StatusEndDate);
				
				IF @AssignedTo IS NULL
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
						[Audit].[LogInLogOut].[UserID] = @AssignedTo
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
						[Audit].[LockUnLock].[UserID] = @AssignedTo
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
				
				DECLARE @Comment NVARCHAR(4000);
				SELECT @Comment = [Patient].[PatientVisit].[Comment] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientVisitID] = @PATIENT_VISIT_ID

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
					@PATIENT_VISIT_ID
					, @ClaimStatusID
					, @AssignedTo
					, @StatusStartDate
					, @StatusEndDate
					, @StartEndMins
					, @LogOutLogInMins
					, @LockUnLockMins
					, @DurationMins
					, @Comment
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @CurrentModificationBy
					, @CurrentModificationOn
					, 1
				);				
			
			--INSERT CLAIM PROCESS END

			--UPDATE CLAIM STATUS IN PATIENT VISIT START
			INSERT INTO 
				[Patient].[PatientVisitHistory]
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
				, @CurrentModificationBy
				, @CurrentModificationOn
				, [Patient].[PatientVisit].[IsActive]
			FROM 
				[Patient].[PatientVisit]
			WHERE
				[Patient].[PatientVisit].[PatientVisitID] = @PATIENT_VISIT_ID;
							
			UPDATE 
				[Patient].[PatientVisit]
			SET 
				 [ClaimStatusID] = [ClaimStatusID] + 1
				 ,[Comment] = @AUTO_COMMENT
				 ,[LastModifiedBy] = @CurrentModificationBy
				 ,[LastModifiedOn] = @CurrentModificationOn
				      
			WHERE [Patient].[PatientVisit].[PatientVisitid] = @PATIENT_VISIT_ID;
		END
		 
		--UPDATE CLAIM STATUS IN PATIENT VISIT END		
		FETCH NEXT FROM CUR_DIAG INTO @PATIENT_VISIT_ID, @DOS;		
	END
	
	CLOSE CUR_DIAG;
	DEALLOCATE CUR_DIAG;
	
	-- EXEC [Claim].[usp_GetSetStatus_ClaimProcess] 
END
GO
