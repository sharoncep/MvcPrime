



/****** Object:  StoredProcedure [Patient].[usp_Insert_PatientVisit]    Script Date: 07/06/2013 14:13:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_Insert_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_Insert_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_Insert_PatientVisit]    Script Date: 07/06/2013 14:13:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Patient].[usp_Insert_PatientVisit]
	@ClinicID INT
	, @PatientID BIGINT
	, @DOS DATE
	, @Comment NVARCHAR(4000)
	, @CurrentModificationBy BIGINT
	, @PatientVisitID BIGINT OUTPUT
	, @FACILITY_TYPE_OFFICE_ID TINYINT
	, @FACILITY_TYPE_INPATIENT_HOSPITAL_ID TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		DECLARE @PatientHospitalizationID BIGINT;		
		SELECT @PatientHospitalizationID = [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NULL AND [Patient].[PatientHospitalization].[IsActive] = 1;
		
		IF @PatientHospitalizationID IS NOT NULL AND @PatientHospitalizationID > 0
		BEGIN
			IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID AND [Patient].[PatientHospitalization].[AdmittedOn] <= @DOS)
			BEGIN
				SELECT @PatientVisitID = -16;
			END
			ELSE
			BEGIN
				SELECT @PatientHospitalizationID = NULL;
			END
		END
		
		IF @PatientVisitID > -1
		BEGIN
			SELECT @PatientHospitalizationID = [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@DOS BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[IsActive] = 1;
			
			DECLARE @IllnessIndicatorID TINYINT;
			DECLARE @IllnessIndicatorDate DATE;
			DECLARE @FacilityTypeID TINYINT;
			DECLARE @FacilityDoneID INT;
			DECLARE @PrimaryClaimDiagnosisID BIGINT;
			DECLARE @DoctorNoteRelPath NVARCHAR(350);
			DECLARE @SuperBillRelPath NVARCHAR(350);
			DECLARE @PatientVisitDesc NVARCHAR(150);
			DECLARE @ClaimStatusID TINYINT;
			DECLARE @AssignedTo INT;
			DECLARE @TargetBAUserID INT;
			DECLARE @TargetQAUserID INT;
			DECLARE @TargetEAUserID INT;
			DECLARE @PatientVisitComplexity TINYINT;
			
			IF @PatientHospitalizationID IS NOT NULL AND @PatientHospitalizationID > 0
				BEGIN 
					SELECT @FacilityTypeID = @FACILITY_TYPE_INPATIENT_HOSPITAL_ID
				END
			ELSE 
				BEGIN
					SELECT @FacilityTypeID = @FACILITY_TYPE_OFFICE_ID;
				END	
			SELECT TOP 1 @IllnessIndicatorID = [Diagnosis].[IllnessIndicator].[IllnessIndicatorID] FROM [Diagnosis].[IllnessIndicator] WHERE [Diagnosis].[IllnessIndicator].[IsActive] = 1 ORDER BY [IllnessIndicator].[IllnessIndicatorID] ASC;
			SELECT @PatientVisitComplexity = [Billing].[Clinic].[PatientVisitComplexity] FROM [Billing].[Clinic] WHERE [Billing].[Clinic].[ClinicID] = @ClinicID AND [Billing].[Clinic].[IsActive] = 1
			
			-- HARD CODED
			SELECT @IllnessIndicatorDate = @DOS;
			SELECT @FacilityDoneID = NULL;
			SELECT @PrimaryClaimDiagnosisID = NULL;
			SELECT @DoctorNoteRelPath = NULL;
			SELECT @SuperBillRelPath = NULL;
			SELECT @PatientVisitDesc = NULL;
			SELECT @ClaimStatusID = 1;
			SELECT @AssignedTo = NULL;
			SELECT @TargetBAUserID = NULL;
			SELECT @TargetQAUserID = NULL;
			SELECT @TargetEAUserID = NULL;
			
			SELECT @PatientVisitID = [Patient].[ufn_IsExists_PatientVisit] (@PatientID, @PatientHospitalizationID, @DOS, @IllnessIndicatorID, @IllnessIndicatorDate, @FacilityTypeID, @FacilityDoneID, @PrimaryClaimDiagnosisID, @DoctorNoteRelPath, @SuperBillRelPath, @PatientVisitDesc, @ClaimStatusID, @AssignedTo, @TargetBAUserID, @TargetQAUserID, @TargetEAUserID, @PatientVisitComplexity, @Comment, 0);
			
			IF @PatientVisitID = 0
			BEGIN
				INSERT INTO [Patient].[PatientVisit]
				(
					[PatientID]
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
				VALUES
				(
					@PatientID
					, @PatientHospitalizationID
					, @DOS
					, @IllnessIndicatorID
					, @IllnessIndicatorDate
					, @FacilityTypeID
					, @FacilityDoneID
					, @PrimaryClaimDiagnosisID
					, @DoctorNoteRelPath
					, @SuperBillRelPath
					, @PatientVisitDesc
					, @ClaimStatusID
					, @AssignedTo
					, @TargetBAUserID
					, @TargetQAUserID
					, @TargetEAUserID
					, @PatientVisitComplexity
					, @Comment
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @CurrentModificationBy
					, @CurrentModificationOn
					, 1
				);
				
				SELECT @PatientVisitID = MAX([Patient].[PatientVisit].[PatientVisitID]) FROM [Patient].[PatientVisit];
			END
			ELSE
			BEGIN			
				SELECT @PatientVisitID = -1;
			END
		END	
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_Insert_PatientHospitalization]    Script Date: 07/01/2013 21:37:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_Insert_PatientHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_Insert_PatientHospitalization]
GO



/****** Object:  StoredProcedure [Patient].[usp_Insert_PatientHospitalization]    Script Date: 07/01/2013 21:37:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Patient].[usp_Insert_PatientHospitalization]
	@PatientID BIGINT
	, @FacilityDoneHospitalID INT
	, @AdmittedOn DATE
	, @DischargedOn DATE = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @PatientHospitalizationID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @PatientHospitalizationID = [Patient].[ufn_IsExists_PatientHospitalization] (@PatientID, @FacilityDoneHospitalID, @AdmittedOn, @DischargedOn, @Comment, 0);
		
		IF @PatientHospitalizationID = 0
		BEGIN
			IF @DischargedOn IS NULL -- CURRENT NO DISCHARGE
			BEGIN
				IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NULL AND [Patient].[PatientHospitalization].[IsActive] = 1)
				BEGIN
					SELECT @PatientHospitalizationID = -3;
				END
				ELSE IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@AdmittedOn BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[DischargedOn] <> @AdmittedOn AND [Patient].[PatientHospitalization].[IsActive] = 1)
				BEGIN
					SELECT @PatientHospitalizationID = -4;
				END
				ELSE IF EXISTS (SELECT [Patient].[PatientVisit].[PatientVisitID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientID] = @PatientID AND [Patient].[PatientVisit].[DOS] >= @AdmittedOn AND [Patient].[PatientVisit].[IsActive] = 1)
				BEGIN
					SELECT @PatientHospitalizationID = -5;
				END
			END
			ELSE
			BEGIN
				IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@AdmittedOn BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[DischargedOn] <> @AdmittedOn AND [Patient].[PatientHospitalization].[IsActive] = 1)
				BEGIN
					SELECT @PatientHospitalizationID = -6;
				END
				ELSE IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@DischargedOn BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[AdmittedOn] <> @DischargedOn AND [Patient].[PatientHospitalization].[IsActive] = 1)
				BEGIN
					SELECT @PatientHospitalizationID = -7;
				END
				ELSE IF EXISTS (SELECT [Patient].[PatientVisit].[PatientVisitID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientID] = @PatientID AND [Patient].[PatientVisit].[DOS] BETWEEN @AdmittedOn AND @DischargedOn AND [Patient].[PatientVisit].[IsActive] = 1)
				BEGIN
					SELECT @PatientHospitalizationID = -8;
				END
			END
			
			IF @PatientHospitalizationID = 0
			BEGIN
				INSERT INTO [Patient].[PatientHospitalization]
				(
					[PatientID]
					, [FacilityDoneHospitalID]
					, [AdmittedOn]
					, [DischargedOn]
					, [Comment]
					, [CreatedBy]
					, [CreatedOn]
					, [LastModifiedBy]
					, [LastModifiedOn]
					, [IsActive]
				)
				VALUES
				(
					@PatientID
					, @FacilityDoneHospitalID
					, @AdmittedOn
					, @DischargedOn
					, @Comment
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @CurrentModificationBy
					, @CurrentModificationOn
					, 1
				);
				
				SELECT @PatientHospitalizationID = MAX([Patient].[PatientHospitalization].[PatientHospitalizationID]) FROM [Patient].[PatientHospitalization];
			END
		END
		ELSE
		BEGIN			
			SELECT @PatientHospitalizationID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @PatientHospitalizationID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END

GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_Update_WebCulture]    Script Date: 05/02/2013 11:14:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_Update_WebCulture]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_Update_WebCulture]
GO


/****** Object:  StoredProcedure [Audit].[usp_Update_WebCulture]    Script Date: 05/02/2013 11:14:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--Description:This Stored Procedure is used to INSERT the WebCulture details into the table after rollback.
 
CREATE PROCEDURE [Audit].[usp_Update_WebCulture]
	@KeyName NVARCHAR(12)
	, @IsActive BIT
	, @WebCultureID BIGINT OUTPUT	
AS
BEGIN

BEGIN TRY
	SET NOCOUNT ON;
	UPDATE 
		[Audit].[WebCulture] 
	SET 
		[Audit].[WebCulture].[IsActive] = @IsActive 
	WHERE 
		[Audit].[WebCulture].[KeyName] = @KeyName
		
	SELECT @WebCultureID = 1;
	
	END TRY
	
	BEGIN CATCH
	-- ERROR CATCHING - STARTS
	BEGIN TRY			
		EXEC [Audit].[usp_Insert_ErrorLog];			
		SELECT @WebCultureID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
	END TRY
	BEGIN CATCH
		RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
	END CATCH
	-- ERROR CATCHING - ENDS
	END CATCH
			
	END
			

GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_Update_PatientVisit]    Script Date: 07/06/2013 14:13:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_Update_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_Update_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_Update_PatientVisit]    Script Date: 07/06/2013 14:13:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--Description:This Stored Procedure is used to UPDATE the PatientVisit in the database.
	 
CREATE PROCEDURE [Patient].[usp_Update_PatientVisit]
	@PatientID BIGINT
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
		DECLARE @PatientHospitalizationID BIGINT;		
		SELECT @PatientHospitalizationID = [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NULL AND [Patient].[PatientHospitalization].[IsActive] = 1;
		
		IF @PatientHospitalizationID IS NOT NULL AND @PatientHospitalizationID > 0
		BEGIN
			IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID AND [Patient].[PatientHospitalization].[AdmittedOn] <= @DOS)
			BEGIN
				SELECT @PatientVisitID = -16;
			END
			ELSE
			BEGIN
				SELECT @PatientHospitalizationID = NULL;
			END
		END
		
		IF @PatientVisitID > -1
		BEGIN
		
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


----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_Update_PatientHospitalization]    Script Date: 07/05/2013 19:05:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_Update_PatientHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_Update_PatientHospitalization]
GO



/****** Object:  StoredProcedure [Patient].[usp_Update_PatientHospitalization]    Script Date: 07/05/2013 19:05:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--Description:This Stored Procedure is used to UPDATE the PatientHospitalization in the database.
	 
CREATE PROCEDURE [Patient].[usp_Update_PatientHospitalization]
	@PatientID BIGINT
	, @FacilityDoneHospitalID INT
	, @AdmittedOn DATE
	, @DischargedOn DATE = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @PatientHospitalizationID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @PatientHospitalizationID_PREV BIGINT;
		SELECT @PatientHospitalizationID_PREV = [Patient].[ufn_IsExists_PatientHospitalization] (@PatientID, @FacilityDoneHospitalID, @AdmittedOn, @DischargedOn, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@PatientHospitalizationID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Patient].[PatientHospitalization].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Patient].[PatientHospitalization].[LastModifiedOn]
			FROM 
				[Patient].[PatientHospitalization] WITH (NOLOCK)
			WHERE
				[Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				IF @DischargedOn IS NULL -- CURRENT NO DISCHARGE
				BEGIN
					IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NULL AND [Patient].[PatientHospitalization].[PatientHospitalizationID] <> @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -9;
					END
					ELSE IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@AdmittedOn BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[DischargedOn] <> @AdmittedOn AND [Patient].[PatientHospitalization].[PatientHospitalizationID] <> @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -10;
					END
					ELSE IF EXISTS (SELECT [Patient].[PatientVisit].[PatientHospitalizationID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientHospitalizationID] = @PatientHospitalizationID AND [Patient].[PatientVisit].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -11;
					END
				END
				ELSE
				BEGIN
					IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@AdmittedOn BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[DischargedOn] <> @AdmittedOn AND [Patient].[PatientHospitalization].[PatientHospitalizationID] <> @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -12;
					END
					ELSE IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@DischargedOn BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[AdmittedOn] <> @DischargedOn AND [Patient].[PatientHospitalization].[PatientHospitalizationID] <> @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -13;		
					END
					ELSE IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NULL AND [Patient].[PatientHospitalization].[AdmittedOn] < @DischargedOn AND [Patient].[PatientHospitalization].[AdmittedOn] <> @DischargedOn AND [Patient].[PatientHospitalization].[PatientHospitalizationID] <> @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -14;		
					END
					ELSE IF EXISTS (SELECT [Patient].[PatientVisit].[PatientHospitalizationID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientHospitalizationID] = @PatientHospitalizationID AND [Patient].[PatientVisit].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -15;
					END
				END
			
				IF @PatientHospitalizationID > 0
				BEGIN
					INSERT INTO 
						[Patient].[PatientHospitalizationHistory]
						(
							[PatientHospitalizationID]
							, [PatientID]
							, [FacilityDoneHospitalID]
							, [AdmittedOn]
							, [DischargedOn]
							, [Comment]
							, [CreatedBy]
							, [CreatedOn]
							, [LastModifiedBy]
							, [LastModifiedOn]
							, [IsActive]
						)
					SELECT
						[Patient].[PatientHospitalization].[PatientHospitalizationID]
						, [Patient].[PatientHospitalization].[PatientID]
						, [Patient].[PatientHospitalization].[FacilityDoneHospitalID]
						, [Patient].[PatientHospitalization].[AdmittedOn]
						, [Patient].[PatientHospitalization].[DischargedOn]
						, [Patient].[PatientHospitalization].[Comment]
						, @CurrentModificationBy
						, @CurrentModificationOn
						, @LastModifiedBy
						, @LastModifiedOn
						, [Patient].[PatientHospitalization].[IsActive]
					FROM 
						[Patient].[PatientHospitalization]
					WHERE
						[Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID;
					
					UPDATE 
						[Patient].[PatientHospitalization]
					SET
						[Patient].[PatientHospitalization].[PatientID] = @PatientID
						, [Patient].[PatientHospitalization].[FacilityDoneHospitalID] = @FacilityDoneHospitalID
						, [Patient].[PatientHospitalization].[AdmittedOn] = @AdmittedOn
						, [Patient].[PatientHospitalization].[DischargedOn] = @DischargedOn
						, [Patient].[PatientHospitalization].[Comment] = @Comment
						, [Patient].[PatientHospitalization].[LastModifiedBy] = @CurrentModificationBy
						, [Patient].[PatientHospitalization].[LastModifiedOn] = @CurrentModificationOn
						, [Patient].[PatientHospitalization].[IsActive] = @IsActive
					WHERE
						[Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID;
				END				
			END
			ELSE
			BEGIN
				SELECT @PatientHospitalizationID = -2;
			END
		END
		ELSE IF @PatientHospitalizationID_PREV <> @PatientHospitalizationID
		BEGIN			
			SELECT @PatientHospitalizationID = -1;			
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
			SELECT @PatientHospitalizationID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END



GO

------------------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetReportAgent_PatientVisit]    Script Date: 08/07/2013 10:00:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportAgent_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportAgent_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportAgent_PatientVisit]    Script Date: 08/07/2013 10:00:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Patient].[usp_GetReportAgent_PatientVisit]	
     @UserID INT	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @AGENT_TMP  TABLE
	(
	     [PK_ID] INT IDENTITY (1, 1)
		,[VISIT_ID] BIGINT NOT NULL	 
	);
	
	INSERT INTO
		@AGENT_TMP
		(
			[VISIT_ID]
		)
		SELECT DISTINCT [Claim].[ClaimProcess].[PatientVisitID] FROM [Claim].[ClaimProcess]
		WHERE [Claim].[ClaimProcess].[CreatedBy] = @UserID
		AND
		[Claim].[ClaimProcess].[IsActive]=1
	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
		INNER JOIN 
		@AGENT_TMP
		ON
		VISIT_ID = [Patient].[PatientVisit].[PatientVisitID]
	
  WHERE
  
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1;
	
	
	--EXEC [Patient].[usp_GetReportAgent_PatientVisit]	 @UserID = 6
END




GO





-------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportAgentDate_PatientVisit]    Script Date: 07/23/2013 13:46:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportAgentDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportAgentDate_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportAgentDate_PatientVisit]    Script Date: 07/23/2013 13:46:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetReportAgentDate_PatientVisit]	
     @UserID INT	
     ,@DateFrom DATE
     ,@DateTo DATE
     
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @AGENT_TMP  TABLE
	(
	     [PK_ID] INT IDENTITY (1, 1)
		,[VISIT_ID] BIGINT NOT NULL	 
	);
	
	INSERT INTO
		@AGENT_TMP
		(
			[VISIT_ID]
		)
		SELECT [Claim].[ClaimProcess].[PatientVisitID] FROM [Claim].[ClaimProcess]
		WHERE [Claim].[ClaimProcess].[CreatedBy] = @UserID
		AND
		[Claim].[ClaimProcess].[IsActive]=1
	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
    INNER JOIN 
		@AGENT_TMP
    ON
		VISIT_ID = [Patient].[PatientVisit].[PatientVisitID]
    WHERE
       [Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
    AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1;
	
	
	--EXEC [Patient].[usp_GetReportAgentDate_PatientVisit]	 @UserID = 8
END


GO

------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [User].[usp_GetNotificationRole_UserRole]    Script Date: 07/24/2013 09:36:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationRole_UserRole]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationRole_UserRole]
GO


/****** Object:  StoredProcedure [User].[usp_GetNotificationRole_UserRole]    Script Date: 07/24/2013 09:36:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User].[usp_GetNotificationRole_UserRole]
	 @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT 
		DISTINCT [User].[User].[UserID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'Email' AND @OrderByDirection = 'A' THEN [User].[User].[Email] END ASC,
				CASE WHEN @orderByField = 'Email' AND @orderByDirection = 'D' THEN [User].[User].[Email] END DESC,
				
				CASE WHEN @OrderByField = 'LastName' AND @OrderByDirection = 'A' THEN [User].[User].[LastName] END ASC,
				CASE WHEN @orderByField = 'LastName' AND @orderByDirection = 'D' THEN [User].[User].[LastName] END DESC,
				
				CASE WHEN @OrderByField = 'FirstName' AND @OrderByDirection = 'A' THEN [User].[User].[FirstName] END ASC,
				CASE WHEN @orderByField = 'FirstName' AND @orderByDirection = 'D' THEN [User].[User].[FirstName] END DESC,
				
				CASE WHEN @OrderByField = 'MiddleName' AND @OrderByDirection = 'A' THEN [User].[User].[MiddleName] END ASC,
				CASE WHEN @orderByField = 'MiddleName' AND @orderByDirection = 'D' THEN [User].[User].[MiddleName] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [User].[User].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [User].[User].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[User].[User]  WITH (NOLOCK)
	INNER JOIN
		[User].[UserRole]  WITH (NOLOCK)
	ON 
		[User].[User].[UserID] = [User].[UserRole].[UserID]
	WHERE
		[User].[UserRole].[RoleID] NOT IN (SELECT [AccessPrivilege].[Role].[RoleID] FROM [AccessPrivilege].[Role] WHERE [AccessPrivilege].[Role].[IsActive] = 1)
	AND
		[User].[UserRole].[IsActive] = 1
	AND
		[User].[User].[IsActive] = 1;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[User].[User].[Email]
		, [User].[User].[LastName]
		, [User].[User].[FirstName]
		, [User].[User].[MiddleName]
	FROM
		[User].[User] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [User].[User].[UserID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
		
	-- EXEC [User].[usp_GetNotificationRole_UserRole]
END








GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [User].[usp_GetNotificationClinic_UserClinic]    Script Date: 08/01/2013 13:59:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationClinic_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationClinic_UserClinic]
GO



/****** Object:  StoredProcedure [User].[usp_GetNotificationClinic_UserClinic]    Script Date: 08/01/2013 13:59:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [User].[usp_GetNotificationClinic_UserClinic]
	 @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT 
		[User].[User].[UserID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'Email' AND @OrderByDirection = 'A' THEN [User].[User].[Email] END ASC,
				CASE WHEN @orderByField = 'Email' AND @orderByDirection = 'D' THEN [User].[User].[Email] END DESC,
				
				CASE WHEN @OrderByField = 'LastName' AND @OrderByDirection = 'A' THEN [User].[User].[LastName] END ASC,
				CASE WHEN @orderByField = 'LastName' AND @orderByDirection = 'D' THEN [User].[User].[LastName] END DESC,
				
				CASE WHEN @OrderByField = 'FirstName' AND @OrderByDirection = 'A' THEN [User].[User].[FirstName] END ASC,
				CASE WHEN @orderByField = 'FirstName' AND @orderByDirection = 'D' THEN [User].[User].[FirstName] END DESC,
				
				CASE WHEN @OrderByField = 'MiddleName' AND @OrderByDirection = 'A' THEN [User].[User].[MiddleName] END ASC,
				CASE WHEN @orderByField = 'MiddleName' AND @orderByDirection = 'D' THEN [User].[User].[MiddleName] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [User].[User].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [User].[User].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
		FROM
			[User].[User] WITH (NOLOCK)
		WHERE
			[User].[User].[UserID] NOT IN (SELECT  [User].[UserClinic].[UserID] FROM [User].[UserClinic] WITH (NOLOCK) WHERE [User].[UserClinic].[IsActive] = 1)
		AND 
			[User].[User].[IsActive] = 1;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		 [User].[User].[Email]
		, [User].[User].[LastName]
		, [User].[User].[FirstName]
		, [User].[User].[MiddleName]
	FROM
		[User].[User] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [User].[User].[UserID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	
	ORDER BY
		[ID]
	ASC;
		
	-- EXEC [User].[usp_GetNotificationClinic_UserClinic] 
END









GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNotificationAgent_User]    Script Date: 07/31/2013 09:41:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationAgent_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationAgent_User]
GO


/****** Object:  StoredProcedure [User].[usp_GetNotificationAgent_User]    Script Date: 07/31/2013 09:41:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [User].[usp_GetNotificationAgent_User] 
	@RoleID TINYINT
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT 
		[User].[User].[UserID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'Email' AND @OrderByDirection = 'A' THEN [User].[User].[Email] END ASC,
				CASE WHEN @orderByField = 'Email' AND @orderByDirection = 'D' THEN [User].[User].[Email] END DESC,
				
				CASE WHEN @OrderByField = 'LastName' AND @OrderByDirection = 'A' THEN [User].[User].[LastName] END ASC,
				CASE WHEN @orderByField = 'LastName' AND @orderByDirection = 'D' THEN [User].[User].[LastName] END DESC,
				
				CASE WHEN @OrderByField = 'FirstName' AND @OrderByDirection = 'A' THEN [User].[User].[FirstName] END ASC,
				CASE WHEN @orderByField = 'FirstName' AND @orderByDirection = 'D' THEN [User].[User].[FirstName] END DESC,
				
				CASE WHEN @OrderByField = 'MiddleName' AND @OrderByDirection = 'A' THEN [User].[User].[MiddleName] END ASC,
				CASE WHEN @orderByField = 'MiddleName' AND @orderByDirection = 'D' THEN [User].[User].[MiddleName] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [User].[User].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [User].[User].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
 		[User].[User]  WITH (NOLOCK)
 	WHERE
 		[User].[User].[UserID] IN 
 	(
		SELECT 
			[UserID] FROM [User].[UserRole] WHERE [User].[UserRole].[RoleID] = @RoleID  AND [User].[UserRole].[IsActive] = 1
		AND 
			[UserID] NOT IN
			(
				SELECT DISTINCT [User].[User].[ManagerID] FROM [User].[User] WHERE [User].[User].[ManagerID] IS NOT NULL
			UNION	
				SELECT [UserID] FROM [User].[UserRole] WHERE [User].[UserRole].[RoleID] < @RoleID  AND [User].[UserRole].[IsActive] = 1
			)
	)
	AND
		[User].[User].[IsActive] = 1;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[User].[User].[Email]
		, [User].[User].[LastName]
		, [User].[User].[FirstName]
		, [User].[User].[MiddleName]
	FROM
		[User].[User] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [User].[User].[UserID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
			
	-- EXEC [User].[usp_GetNotificationAgent_User] NULL
	-- EXEC [User].[usp_GetNotificationAgent_User] 2
	-- EXEC [User].[usp_GetNotificationAgent_User] 0
END







GO



------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [User].[usp_GetNotificationManager_UserClinic]    Script Date: 08/01/2013 19:23:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationManager_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationManager_UserClinic]
GO

/****** Object:  StoredProcedure [User].[usp_GetNotificationManager_UserClinic]    Script Date: 08/01/2013 19:23:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [User].[usp_GetNotificationManager_UserClinic] 
	@ManagerRoleID TINYINT
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @MNGR_TMP TABLE
	(
		[USER_ID] INT NOT NULL
	);
	
	INSERT INTO
		@MNGR_TMP
	SELECT 
		[User].[UserRole].[UserID]
	FROM 
		[User].[UserRole]
	WHERE
		[User].[UserRole].[RoleID] = @ManagerRoleID
	AND
		[User].[UserRole].[IsActive] = 1;
	
	DELETE FROM
		@MNGR_TMP
	WHERE
		[USER_ID] IN
		(
			SELECT 
				[User].[UserRole].[UserID]
			FROM 
				[User].[UserRole]
			WHERE
				[User].[UserRole].[RoleID] < @ManagerRoleID
			AND
				[User].[UserRole].[IsActive] = 1
		)
	OR
		[USER_ID] IN
		(
			SELECT 
				[User].[User].[UserID]
			FROM 
				[User].[User]
			WHERE
				[User].[User].[ManagerID] IS NOT NULL
			AND
				[User].[User].[IsActive] = 1
		);
	
	DECLARE @CLNC_TMP TABLE
	(
		[CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@CLNC_TMP
	SELECT DISTINCT
		[A].[ClinicID]
	FROM
		[User].[UserClinic] A WITH (NOLOCK)
	INNER JOIN
		@MNGR_TMP B
	ON
		[B].[USER_ID] = [A].[UserID]
	WHERE
		[A].[IsActive] = 1;
	
	DECLARE @CLNC_NO_TMP TABLE
	(
		[CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@CLNC_NO_TMP
	SELECT
		[A].[ClinicID]
	FROM
		[Billing].[Clinic] A WITH (NOLOCK)
	WHERE
		[A].[ClinicID] NOT IN
		(
			SELECT 
				[B].[CLINIC_ID]
			FROM
				@CLNC_TMP B
		)
	AND
		[A].[IsActive] = 1;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT 
		[Billing].[Clinic].[ClinicID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'ClinicName' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[ClinicName] END ASC,
				CASE WHEN @orderByField = 'ClinicName' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[ClinicName] END DESC,
				
				CASE WHEN @OrderByField = 'NPI' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[NPI] END ASC,
				CASE WHEN @orderByField = 'NPI' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[NPI] END DESC,
				
				CASE WHEN @OrderByField = 'ICDFormat' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[ICDFormat] END ASC,
				CASE WHEN @orderByField = 'ICDFormat' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[ICDFormat] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[Clinic].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM 
 		[Billing].[Clinic] WITH (NOLOCK)
 	INNER JOIN
 		@CLNC_NO_TMP B
 	ON
 		[B].[CLINIC_ID] = [Billing].[Clinic].[ClinicID]
	AND
		[Billing].[Clinic].[IsActive] = 1;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Billing].[Clinic].[ClinicID]
		, [Billing].[Clinic].[ClinicName]
		, [Billing].[Clinic].[NPI]
		, [Billing].[Clinic].[ICDFormat]
	FROM
		[Billing].[Clinic] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Billing].[Clinic].[ClinicID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ClinicName]
	ASC;
			
	-- EXEC [User].[usp_GetNotificationManager_UserClinic] NULL
	-- EXEC [User].[usp_GetNotificationManager_UserClinic] @ManagerRoleID=2,@OrderByField = 'ClinicName'
	-- EXEC [User].[usp_GetNotificationManager_UserClinic] 2
END









GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetCount_UserRole]    Script Date: 07/24/2013 10:55:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetCount_UserRole]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetCount_UserRole]
GO
------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [User].[usp_GetNotificationCountRole_UserRole]    Script Date: 07/24/2013 10:57:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationCountRole_UserRole]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationCountRole_UserRole]
GO


/****** Object:  StoredProcedure [User].[usp_GetNotificationCountRole_UserRole]    Script Date: 07/24/2013 10:57:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE [User].[usp_GetNotificationCountRole_UserRole]

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [USER_ROLE_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
	SELECT 
		COUNT (DISTINCT [User].[User].[UserID]) AS [USER_ROLE_COUNT]
	FROM
		[User].[User]  WITH (NOLOCK)
	INNER JOIN
		[User].[UserRole]  WITH (NOLOCK)
	ON 
		[User].[User].[UserID] = [User].[UserRole].[UserID]
	WHERE
		[User].[UserRole].[RoleID] NOT IN (SELECT [AccessPrivilege].[Role].[RoleID] FROM [AccessPrivilege].[Role] WHERE [AccessPrivilege].[Role].[IsActive] = 1)
	AND
		[User].[UserRole].[IsActive] = 1
	AND
		[User].[User].[IsActive] = 1;
		
		
	SELECT * FROM @TBL_ANS;
		
	-- EXEC [User].[usp_GetNotificationCountRole_UserRole] 
	-- EXEC [User].[usp_GetNotificationCountRole_UserRole] @ClinicID = 1, @StatusIDs = '8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25'	-- CREATED
	-- EXEC [User].[usp_GetNotificationCountRole_UserRole] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
	-- EXEC [User].[usp_GetNotificationCountRole_UserRole] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
END








GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetCount_UserClinic]    Script Date: 07/24/2013 10:57:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetCount_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetCount_UserClinic]
GO

------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNotificationCountClinic_UserClinic]    Script Date: 08/01/2013 14:00:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationCountClinic_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationCountClinic_UserClinic]
GO


/****** Object:  StoredProcedure [User].[usp_GetNotificationCountClinic_UserClinic]    Script Date: 08/01/2013 14:00:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [User].[usp_GetNotificationCountClinic_UserClinic]

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [USER_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
		SELECT 
			 COUNT([User].[User].[UserID]) AS [USER_COUNT]
		FROM
			[User].[User] WITH (NOLOCK)
		WHERE
			[User].[User].[UserID] NOT IN (SELECT  [User].[UserClinic].[UserID] FROM [User].[UserClinic] WITH (NOLOCK) WHERE [User].[UserClinic].[IsActive] = 1)
		AND 
			[User].[User].[IsActive] = 1;
		
	SELECT * FROM @TBL_ANS;
		
	-- EXEC [User].[usp_GetNotificationCountClinic_UserClinic] 
	-- EXEC [User].[usp_GetNotificationCountClinic_UserClinic] @ClinicID = 1, @StatusIDs = '8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25'	-- CREATED
	-- EXEC [User].[usp_GetNotificationCountClinic_UserClinic] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
	-- EXEC [User].[usp_GetNotificationCountClinic_UserClinic] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
END









GO



------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [User].[usp_GetCountManager_User]    Script Date: 07/24/2013 11:00:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetCountManager_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetCountManager_User]
GO

------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNotificationCountAgent_User]    Script Date: 08/01/2013 09:28:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationCountAgent_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationCountAgent_User]
GO


/****** Object:  StoredProcedure [User].[usp_GetNotificationCountAgent_User]    Script Date: 08/01/2013 09:28:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [User].[usp_GetNotificationCountAgent_User] 
	@RoleID TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [MANAGER_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
	SELECT 
 		COUNT([User].[User].[UserID]) AS [MANAGER_COUNT]
 	FROM 
 		[User].[User]  WITH (NOLOCK)
 	WHERE
 		[User].[User].[UserID] IN 
 	(
		SELECT 
			[UserID] FROM [User].[UserRole] WITH (NOLOCK) WHERE [User].[UserRole].[RoleID] = @RoleID  AND [User].[UserRole].[IsActive] = 1
		AND 
			[UserID] NOT IN
			(
				SELECT DISTINCT [User].[User].[ManagerID] FROM [User].[User] WITH (NOLOCK) WHERE [User].[User].[ManagerID] IS NOT NULL
			UNION	
				SELECT [UserID] FROM [User].[UserRole] WITH (NOLOCK) WHERE [User].[UserRole].[RoleID] < @RoleID  AND [User].[UserRole].[IsActive] = 1
			)
	)
	AND
		[User].[User].[IsActive] = 1;

	SELECT * FROM @TBL_ANS;
			
	-- EXEC [User].[usp_GetNotificationCountAgent_User] NULL
	-- EXEC [User].[usp_GetNotificationCountAgent_User] 2
	-- EXEC [User].[usp_GetNotificationCountAgent_User] 0
END







GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetCountClinic_UserClinic]    Script Date: 07/24/2013 11:04:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetCountClinic_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetCountClinic_UserClinic]
GO
------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNotificationCountManager_UserClinic]    Script Date: 08/01/2013 19:26:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationCountManager_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationCountManager_UserClinic]
GO



/****** Object:  StoredProcedure [User].[usp_GetNotificationCountManager_UserClinic]    Script Date: 08/01/2013 19:26:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [User].[usp_GetNotificationCountManager_UserClinic] 
	@ManagerRoleID TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MNGR_TMP TABLE
	(
		[USER_ID] INT NOT NULL
	);
	
	INSERT INTO
		@MNGR_TMP
	SELECT 
		[User].[UserRole].[UserID]
	FROM 
		[User].[UserRole]
	WHERE
		[User].[UserRole].[RoleID] = @ManagerRoleID
	AND
		[User].[UserRole].[IsActive] = 1;
	
	DELETE FROM
		@MNGR_TMP
	WHERE
		[USER_ID] IN
		(
			SELECT 
				[User].[UserRole].[UserID]
			FROM 
				[User].[UserRole]
			WHERE
				[User].[UserRole].[RoleID] < @ManagerRoleID
			AND
				[User].[UserRole].[IsActive] = 1
		)
	OR
		[USER_ID] IN
		(
			SELECT 
				[User].[User].[UserID]
			FROM 
				[User].[User]
			WHERE
				[User].[User].[ManagerID] IS NOT NULL
			AND
				[User].[User].[IsActive] = 1
		);
	
	DECLARE @CLNC_TMP TABLE
	(
		[CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@CLNC_TMP
	SELECT DISTINCT
		[A].[ClinicID]
	FROM
		[User].[UserClinic] A WITH (NOLOCK)
	INNER JOIN
		@MNGR_TMP B
	ON
		[B].[USER_ID] = [A].[UserID]
	WHERE
		[A].[IsActive] = 1;
	
	DECLARE @CLNC_NO_TMP TABLE
	(
		[CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@CLNC_NO_TMP
	SELECT
		[A].[ClinicID]
	FROM
		[Billing].[Clinic] A WITH (NOLOCK)
	WHERE
		[A].[ClinicID] NOT IN
		(
			SELECT 
				[B].[CLINIC_ID]
			FROM
				@CLNC_TMP B
		)
	AND
		[A].[IsActive] = 1;
		
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CLINIC_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
	SELECT 
 		COUNT(DISTINCT [Billing].[Clinic].[ClinicID]) AS [CLINIC_COUNT]
 	FROM 
 		[Billing].[Clinic] WITH (NOLOCK)
 	INNER JOIN
 		@CLNC_NO_TMP B
 	ON
 		[B].[CLINIC_ID] = [Billing].[Clinic].[ClinicID]
	AND
		[Billing].[Clinic].[IsActive] = 1;

	SELECT * FROM @TBL_ANS;
			
	-- EXEC [User].[usp_GetNotificationCountManager_UserClinic] NULL
	-- EXEC [User].[usp_GetNotificationCountManager_UserClinic] 2
	-- EXEC [User].[usp_GetNotificationCountManager_UserClinic] 0
END








GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReport_PatientVisit]    Script Date: 07/25/2013 09:20:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReport_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReport_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReport_PatientVisit]    Script Date: 07/25/2013 09:20:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetXmlReport_PatientVisit]	
     @UserID INT	
AS
BEGIN
	SET NOCOUNT ON;
	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [Patient].[PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
		, (
			SELECT 
				 ROW_NUMBER() OVER (ORDER BY [Claim].[ClaimDiagnosis].[ClaimDiagnosisID] ASC) AS [SN]
				, [ClaimDiagnosis].[ClaimDiagnosisID] AS [CLAIMDIAGNOSIS_ID]
				, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [DIAGNOSIS_CODE]
				, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
				, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
				, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
				, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
				, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
				, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
				, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
				, (
					SELECT
						ROW_NUMBER() OVER (ORDER BY [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] ASC) AS [SN]
						, [ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPTID]
						, [Diagnosis].[CPT].[CPTCode] AS [CPT_CODE]
						, [Diagnosis].[CPT].[ShortDesc] AS [SHORT_DESC]
						, [Diagnosis].[CPT].[LongDesc] AS [LONG_DESC]
						, [Diagnosis].[CPT].[MediumDesc] AS [MEDIUM_DESC]
						, [Diagnosis].[CPT].[CustomDesc] AS [CUSTOM_DESC]
						, [Billing].[FacilityType].[FacilityTypeName]  AS [FACILITYTYPE_NAME]
						, [Claim].[ClaimDiagnosisCPT].[Unit]  AS [UNIT]
						, [Diagnosis].[CPT].[ChargePerUnit] AS [CHARGE_PER_UNIT]
						, (
							SELECT
								ROW_NUMBER() OVER (ORDER BY [Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTModifierID] ASC) AS [SN]
								, [Diagnosis].[Modifier].[ModifierCode] AS [MODIFIER_CODE]
								, [Diagnosis].[Modifier].[ModifierName] AS [MODIFIER_NAME]
							FROM
								[Claim].[ClaimDiagnosisCPTModifier] WITH (NOLOCK)
							INNER JOIN
								[Diagnosis].[Modifier] WITH (NOLOCK)
							ON
								[Diagnosis].[Modifier].[ModifierID] = [Claim].[ClaimDiagnosisCPTModifier].[ModifierID]
							WHERE 
								[Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID]
							AND
								[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = 1  
							AND
								[Diagnosis].[Modifier].[IsActive] = 1
							FOR XML AUTO, TYPE
						)
					FROM
						[Claim].[ClaimDiagnosisCPT] WITH (NOLOCK)					
					INNER JOIN
						[Diagnosis].[CPT] WITH (NOLOCK)
					ON
						[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
					INNER JOIN
						[Billing].[FacilityType]
					ON  
						[Billing].[FacilityType].[FacilityTypeID] = [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
					WHERE 
						[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
					AND
						[Claim].[ClaimDiagnosisCPT].[IsActive] = 1					
					AND
						[Diagnosis].[CPT].[IsActive] = 1
					AND
						[Billing].[FacilityType].[IsActive] = 1
					FOR XML AUTO, TYPE
				)
			FROM
				[Claim].[ClaimDiagnosis] WITH (NOLOCK)
			INNER JOIN
				[Diagnosis].[Diagnosis] WITH (NOLOCK)
			ON
				[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			WHERE 
				[Claim].[ClaimDiagnosis].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			FOR XML AUTO, TYPE
		)
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	INNER JOIN 	
		[User].[UserClinic] WITH (NOLOCK) 
	ON 
		[Clinic].[ClinicID]  = [UserClinic].[ClinicID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		 [User].[UserClinic].[UserID] = @UserID
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	FOR XML AUTO, ROOT('GetXmlReports');
	
	
	-- EXEC [Patient].[usp_GetXmlReport_PatientVisit]  @UserID = 1
END




GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetReportCpt_ClaimDiagnosis]    Script Date: 07/25/2013 10:19:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetReportCpt_ClaimDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetReportCpt_ClaimDiagnosis]
GO

/****** Object:  StoredProcedure [Claim].[usp_GetReportCpt_ClaimDiagnosis]    Script Date: 07/25/2013 10:19:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Claim].[usp_GetReportCpt_ClaimDiagnosis]
       @ClaimDiagnosisId BIGINT	
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] ASC) AS [SN]
		, [ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPTID]
		, [Diagnosis].[CPT].[CPTCode] AS [CPT_CODE]
		, [Diagnosis].[CPT].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[CPT].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[CPT].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[CPT].[CustomDesc] AS [CUSTOM_DESC]
		, [Billing].[FacilityType].[FacilityTypeName]  AS [FACILITYTYPE_NAME]
		, [Claim].[ClaimDiagnosisCPT].[Unit]  AS [UNIT]
		, [Diagnosis].[CPT].[ChargePerUnit] AS [CHARGE_PER_UNIT]	
	FROM
	    [Claim].[ClaimDiagnosisCPT] WITH (NOLOCK)
	INNER JOIN
		[Diagnosis].[CPT] WITH (NOLOCK)
	ON
		[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
	INNER JOIN
		[Billing].[FacilityType]
	ON  
	    [Billing].[FacilityType].[FacilityTypeID] = [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
	WHERE 
	    [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID] = @ClaimDiagnosisId
	AND
	    [Claim].[ClaimDiagnosisCPT].[IsActive] = 1
	AND
		[Diagnosis].[CPT].[IsActive] = 1
	AND
        [Billing].[FacilityType].[IsActive]=1;
		
	-- EXEC [Claim].[usp_GetReportCpt_ClaimDiagnosis]	@ClaimDiagnosisId =1
END


GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReport_PatientVisit]    Script Date: 07/25/2013 09:20:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReport_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReport_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReport_PatientVisit]    Script Date: 07/25/2013 09:20:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetReport_PatientVisit]	
     @UserID INT	
AS
BEGIN
	SET NOCOUNT ON;
	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	INNER JOIN 	
		[User].[UserClinic] WITH (NOLOCK) 
	ON 
		[Clinic].[ClinicID]  = [UserClinic].[ClinicID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		[User].[UserClinic].[UserID] = @UserID
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1;	
	
	--EXEC [Patient].[usp_GetReport_PatientVisit]  @UserID = 1
END


GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetReportAZAgent_User]    Script Date: 07/25/2013 13:43:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetReportAZAgent_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetReportAZAgent_User]
GO


/****** Object:  StoredProcedure [User].[usp_GetReportAZAgent_User]    Script Date: 07/25/2013 13:43:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [User].[usp_GetReportAZAgent_User]
	@UserID		INT
AS
BEGIN
	
	SET NOCOUNT ON;
    
    DECLARE @TBL_ALL TABLE
    (
		[Name] [nvarchar](40) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
   
    INSERT INTO
		@TBL_ALL
	SELECT DISTINCT
		(LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], ''))))
	FROM 
		[User].[User]  WITH (NOLOCK)
	INNER JOIN	
		[User].[UserClinic] A WITH (NOLOCK) 
	ON 
		[User].UserID = [A].[UserID]
	INNER JOIN 
		[User].[UserClinic] B 
	ON 
		[B].[ClinicID] = [A].ClinicID
	WHERE
		[B].[UserID] = @UserID
	AND 
		[User].[IsActive] = 1
	AND 
		[A].[IsActive] = 1 
	AND 
		[B].[IsActive] = 1;
		
	DECLARE @AZ_TMP VARCHAR(26);
	SELECT @AZ_TMP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE @AZ_LOOP INT;
	SELECT 	@AZ_LOOP = 1;
	DECLARE @AZ_CNT INT;
	SELECT @AZ_CNT = LEN(@AZ_TMP);
	DECLARE @AZ_CHR VARCHAR(1);
	SELECT @AZ_CHR = '';
	
	WHILE @AZ_LOOP <= @AZ_CNT
	BEGIN
		SELECT @AZ_CHR = SUBSTRING(@AZ_TMP, @AZ_LOOP, 1);
		
		INSERT INTO
			@TBL_AZ
		SELECT
			@AZ_CHR	AS [AZ]
			, COUNT(*) AS [AZ_COUNT]
		FROM
			@TBL_ALL
		WHERE
			[Name] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	-- EXEC [User].[usp_GetReportAZAgent_User] @UserID = 1
END




GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetReportAgent_User]    Script Date: 07/25/2013 13:42:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetReportAgent_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetReportAgent_User]
GO


/****** Object:  StoredProcedure [User].[usp_GetReportAgent_User]    Script Date: 07/25/2013 13:42:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [User].[usp_GetReportAgent_User]
	@UserID		INT
	, @StartBy	NVARCHAR(1) = NULL
AS
BEGIN-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @StartBy IS NULL
	BEGIN
		SET @StartBy = '';
	END
    
	SELECT DISTINCT
		[User].[User].[UserID]
		, (LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) AS [Name]
	FROM 
		[User].[User]  WITH (NOLOCK)
	INNER JOIN	
		[User].[UserClinic] A WITH (NOLOCK) 
	ON 
		[User].UserID = [A].[UserID]
	INNER JOIN 
		[User].[UserClinic] B 
	ON 
		[B].[ClinicID] = [A].ClinicID
	WHERE
		[B].[UserID] = @UserID
	AND
		(LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) LIKE @StartBy + '%'
	AND 
		[User].[IsActive] = 1
	AND 
		[A].[IsActive] = 1 
	AND 
		[B].[IsActive] = 1;		
	
	-- EXEC [User].[usp_GetReportAgent_User] @UserID = 1 
END


GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportPatientDate_PatientVisit]    Script Date: 07/25/2013 10:01:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportPatientDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportPatientDate_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportPatientDate_PatientVisit]    Script Date: 07/25/2013 10:01:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Patient].[usp_GetReportPatientDate_PatientVisit]
	@PatientID BIGINT	
	, @DateFrom DATE
	, @DateTo DATE     
AS
BEGIN
	SET NOCOUNT ON;	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		[Patient].[Patient].[PatientID] = @PatientID		
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1;	
	
	-- EXEC [Patient].[usp_GetReportDatePatientWise_PatientVisit] @PatientID = 1,  @DateFrom='2012-JAN-12',@DateTo='2012-FEB-12'
	-- EXEC [Patient].[usp_GetReportDate_PatientVisit]	
END






GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportProviderDate_PatientVisit]    Script Date: 07/25/2013 09:57:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportProviderDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportProviderDate_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportProviderDate_PatientVisit]    Script Date: 07/25/2013 09:57:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetReportProviderDate_PatientVisit]
	@ProviderID	INT	
	, @DateFrom	DATE
	, @DateTo	DATE     
AS
BEGIN
	SET NOCOUNT ON;
		
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		[Billing].[Provider].[ProviderID] = @ProviderID		
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1;	
	
	--EXEC [Patient].[usp_GetReportDateProviderWise_PatientVisit] @ProviderID = 1,  @DateFrom='2012-JAN-12',@DateTo='2012-FEB-12'
	-- EXEC [Patient].[usp_GetReportDate_PatientVisit]	
END






GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportProvider_PatientVisit]    Script Date: 07/25/2013 09:58:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportProvider_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportProvider_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetReportProvider_PatientVisit]    Script Date: 07/25/2013 09:58:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [Patient].[usp_GetReportProvider_PatientVisit]	
     @ProviderID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		[Billing].[Provider].[ProviderID] = @ProviderID
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1;
	
	
	--EXEC [Patient].[usp_GetReportProvider_PatientVisit]  @UserID = 1
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] 
END









GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportPatient_PatientVisit]    Script Date: 07/25/2013 10:03:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportPatient_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportPatient_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportPatient_PatientVisit]    Script Date: 07/25/2013 10:03:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Patient].[usp_GetReportPatient_PatientVisit]	
     @PatientID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		[Patient].[Patient].[PatientID] = @PatientID
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1;
	
	
	--EXEC [Patient].[usp_GetReportPatient_PatientVisit]  @PatientID = 1
	-- EXEC [Patient].[usp_GetReportPatient_PatientVisit]
END










GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetReportDx_PatientVisit]    Script Date: 07/25/2013 10:03:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDx_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDx_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportDx_PatientVisit]    Script Date: 07/25/2013 10:03:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Patient].[usp_GetReportDx_PatientVisit]	
 @patientvisitid BIGINT
 
AS 
BEGIN

   SET NOCOUNT ON;
   
 SELECT 
         ROW_NUMBER() OVER (ORDER BY [ClaimDiagnosis].[ClaimDiagnosisID] ASC) AS [SN]
		, [ClaimDiagnosis].[ClaimDiagnosisID] AS [CLAIMDIAGNOSIS_ID]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [DIAGNOSIS_CODE]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	INNER JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE 
		[Claim].[ClaimDiagnosis].[PatientVisitID] = @patientvisitid
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1;
		
	-- EXEC [Patient].[usp_GetReportDx_PatientVisit] @patientvisitid=1
END

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportDate_PatientVisit]    Script Date: 07/25/2013 10:16:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDate_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportDate_PatientVisit]    Script Date: 07/25/2013 10:16:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Patient].[usp_GetReportDate_PatientVisit]	
    @UserID INT
    ,@DateFrom DATE
     ,@DateTo DATE
     
     
AS
BEGIN
	SET NOCOUNT ON;
	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1

    WHERE
	    [Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
    AND
	    [Billing].[Clinic].[ClinicID]  IN
    (SELECT 
		 [USER].[UserClinic].[ClinicID] 
	 FROM 
		 [User].[UserClinic] WITH (NOLOCK) 
	 WHERE 
		 [User].[UserClinic].[UserID] = @UserID)
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1;
	
	
	
	
	--EXEC [Patient].[usp_GetReportDateClinicAll_PatientVisit]  @DateFrom='2012-JAN-12',@DateTo='2012-FEB-12'
	-- EXEC [Patient].[usp_GetReportDate_PatientVisit]	
END






GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportClinicDate_PatientVisit]    Script Date: 07/25/2013 10:17:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportClinicDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportClinicDate_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportClinicDate_PatientVisit]    Script Date: 07/25/2013 10:17:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetReportClinicDate_PatientVisit]	
     @ClinicID INT
     ,@DateFrom DATE
     ,@DateTo DATE
     
     
AS
BEGIN
	SET NOCOUNT ON;
	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		[Billing].[Clinic].[ClinicID] = @ClinicID
	AND
	[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
		
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1
	
	ORDER BY DOS ASC;
	
	
	--EXEC [Patient].[usp_GetReportClinicDate_PatientVisit]	  @ClinicID = 1 , @DateFrom='2012-JAN-12',@DateTo='2012-FEB-12'
	-- EXEC [Patient].[usp_GetReportClinicDate_PatientVisit]	
END


GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportClinic_PatientVisit]    Script Date: 07/25/2013 10:18:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportClinic_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportClinic_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportClinic_PatientVisit]    Script Date: 07/25/2013 10:18:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [Patient].[usp_GetReportClinic_PatientVisit]	
     @ClinicID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		[Billing].[Clinic].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1;
	
	
	--EXEC [Patient].[usp_GetReportClinic_PatientVisit]  @UserID = 1
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] 
END









GO



------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [Patient].[usp_GetAgentBAReport_PatientVisit]    Script Date: 07/25/2013 10:22:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAgentBAReport_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAgentBAReport_PatientVisit]
GO
------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [Patient].[usp_GetAgentEAReport_PatientVisit]    Script Date: 07/25/2013 10:23:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAgentEAReport_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAgentEAReport_PatientVisit]
GO
------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [Patient].[usp_GetAgentQAReport_PatientVisit]    Script Date: 07/25/2013 10:24:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAgentQAReport_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAgentQAReport_PatientVisit]
GO
------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportSumClinic_PatientVisit]    Script Date: 07/31/2013 11:41:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumClinic_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumClinic_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportSumClinic_PatientVisit]    Script Date: 07/31/2013 11:41:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Patient].[usp_GetReportSumClinic_PatientVisit]
	@ClinicID INT
	, @NEW_CLAIM TINYINT
	, @QA_PERSONAL_QUEUE_NIT TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EA_PERSONAL_QUEUE_NIT TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @SENT_CLAIM_NIT TINYINT
	, @DONE TINYINT
AS
BEGIN
	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(15) PRIMARY KEY NOT NULL
		, [VISITS] BIGINT NOT NULL
		, [IN_PROGRESS] BIGINT NOT NULL
		, [READY_TO_SEND] BIGINT NOT NULL
		, [SENT] BIGINT NOT NULL
		, [DONE] BIGINT NOT NULL
	);
	
	DECLARE CUR_X CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
		SELECT DISTINCT
			CAST(YEAR([Patient].[PatientVisit].[DOS]) AS NVARCHAR(15))
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[Patient].[ClinicID] = @ClinicID
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1
		ORDER BY
			1
		ASC;
		
	OPEN CUR_X;
	
	DECLARE @X_AXIS_NAME NVARCHAR(15);
	
	FETCH NEXT FROM CUR_X INTO @X_AXIS_NAME;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			@X_AXIS_NAME AS [X_AXIS_NAME]
			, (
				SELECT 
					 COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] > 0
				AND 
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [VISITS]
			
			--CREATED COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @NEW_CLAIM AND @QA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [IN_PROGRESS]
		
			--Ready to send COUNT_BIG 
	        ,( 
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @READY_TO_SEND_CLAIM AND @EA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			)AS [READY_TO_SEND]
	                                       
			--Sent COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @EDI_FILE_CREATED AND @SENT_CLAIM_NIT 			
				AND 
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [SENT]
			
			--Accepted COUNT_BIG
			, (
				SELECT 
					  COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] = @DONE  
				AND 
					[Patient].[Patient].[ClinicID] =@ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [DONE];
		
		  FETCH NEXT FROM CUR_X INTO @X_AXIS_NAME;
	  END
	
	CLOSE CUR_X;
	DEALLOCATE CUR_X;	
	
	SELECT * FROM @TBL_ANS WHERE ([VISITS] > 0 OR [IN_PROGRESS] > 0 OR [READY_TO_SEND] > 0 OR [SENT] > 0 OR [DONE] > 0) ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSumClinic_PatientVisit] 1, 1, 15, 16, 21, 22, 29, 30

GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetByPkId_PatientVisit]    Script Date: 07/25/2013 17:34:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByPkId_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByPkId_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetByPkId_PatientVisit]    Script Date: 07/25/2013 17:34:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Select the particular record

CREATE PROCEDURE [Patient].[usp_GetByPkId_PatientVisit] 
	@PatientVisitID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Patient].[PatientVisit].*
		, (SELECT
				COUNT([Claim].[ClaimDiagnosis].[ClaimDiagnosisID])
			FROM
				[Claim].[ClaimDiagnosis]
			WHERE
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				[Claim].[ClaimDiagnosis].[IsActive] = 1
		) AS [DX_COUNT]
	FROM
		[Patient].[PatientVisit]
	WHERE
		@PatientVisitID = [Patient].[PatientVisit].[PatientVisitID]
	AND
		[Patient].[PatientVisit].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientVisit].[IsActive] ELSE @IsActive END;

	-- EXEC [Patient].[usp_GetByPkId_PatientVisit] 1, NULL
	-- EXEC [Patient].[usp_GetByPkId_PatientVisit] 1, 1
	-- EXEC [Patient].[usp_GetByPkId_PatientVisit] 1, 0
END

GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [User].[usp_GetNotificationCountAgentClinic_UserClinic]    Script Date: 07/26/2013 11:04:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationCountAgentClinic_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationCountAgentClinic_UserClinic]
GO


/****** Object:  StoredProcedure [User].[usp_GetNotificationCountAgentClinic_UserClinic]    Script Date: 07/26/2013 11:04:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User].[usp_GetNotificationCountAgentClinic_UserClinic]
	@UserID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CLINIC_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
	SELECT 
		COUNT ([User].[UserClinic].[ClinicID])
	FROM 
		[User].[UserClinic]  WITH (NOLOCK)
	INNER JOIN
		[Billing].[Clinic]  WITH (NOLOCK)
	ON
		[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
	WHERE 
		[User].[UserClinic].[UserID] = @UserID 
	AND 
		[User].[UserClinic].[IsActive] = 1 
	AND 
		[Billing].[Clinic].[IsActive] = 1;
		
	SELECT * FROM @TBL_ANS;
		
	-- EXEC [User].[usp_GetNotificationCountAgentClinic_UserClinic] 116
	-- EXEC [User].[usp_GetNotificationCountAgentClinic_UserClinic] @ClinicID = 1, @StatusIDs = '8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25'	-- CREATED
	-- EXEC [User].[usp_GetNotificationCountAgentClinic_UserClinic] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
	-- EXEC [User].[usp_GetNotificationCountAgentClinic_UserClinic] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
END









GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNotificationAgentClinic_UserClinic]    Script Date: 07/26/2013 11:35:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationAgentClinic_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationAgentClinic_UserClinic]
GO



/****** Object:  StoredProcedure [User].[usp_GetNotificationAgentClinic_UserClinic]    Script Date: 07/26/2013 11:35:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User].[usp_GetNotificationAgentClinic_UserClinic]
	@UserID INT
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT 
		 [Billing].[Clinic].[ClinicID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'ClinicName' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[ClinicName] END ASC,
				CASE WHEN @orderByField = 'ClinicName' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[ClinicName] END DESC,
				
				CASE WHEN @OrderByField = 'NPI' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[NPI] END ASC,
				CASE WHEN @orderByField = 'NPI' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[NPI] END DESC,
				
				CASE WHEN @OrderByField = 'ICDFormat' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[ICDFormat] END ASC,
				CASE WHEN @orderByField = 'ICDFormat' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[ICDFormat] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[Clinic].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
		FROM 
			[User].[UserClinic]  WITH (NOLOCK)
		INNER JOIN
			[Billing].[Clinic]  WITH (NOLOCK)
		ON
			[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
		WHERE 
			[User].[UserClinic].[UserID] = @UserID 
		AND 
			[User].[UserClinic].[IsActive] = 1 
		AND 
			[Billing].[Clinic].[IsActive] = 1;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Billing].[Clinic].[ClinicName]
		, [Billing].[Clinic].[NPI]
		, [Billing].[Clinic].[ICDFormat]
	FROM
		[Billing].[Clinic] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Billing].[Clinic].[ClinicID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
		
	-- EXEC [User].[usp_GetNotificationAgentClinic_UserClinic] 116
END



GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportSum_PatientVisit]    Script Date: 07/31/2013 11:40:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSum_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSum_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetReportSum_PatientVisit]    Script Date: 07/31/2013 11:40:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetReportSum_PatientVisit]
	@UserID INT
	, @NEW_CLAIM TINYINT
	, @QA_PERSONAL_QUEUE_NIT TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EA_PERSONAL_QUEUE_NIT TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @SENT_CLAIM_NIT TINYINT
	, @DONE TINYINT
AS
BEGIN
	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(15) NOT NULL
		, [VISITS] BIGINT NOT NULL
		, [IN_PROGRESS] BIGINT NOT NULL
		, [READY_TO_SEND] BIGINT NOT NULL
		, [SENT] BIGINT NOT NULL
		, [DONE] BIGINT NOT NULL
	);
	
	DECLARE CUR_X CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
		SELECT DISTINCT
			CAST(YEAR([Patient].[PatientVisit].[DOS]) AS NVARCHAR(15))
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[Patient].[ClinicID] IN 
			(
				SELECT 
					[User].[UserClinic].[ClinicID] 
				FROM 
					[User].[UserClinic]  WITH (NOLOCK)
				INNER JOIN
					[Billing].[Clinic]  WITH (NOLOCK)
				ON
					[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
				WHERE 
					[User].[UserClinic].[UserID] = @UserID 
				AND 
					[User].[UserClinic].[IsActive] = 1 
				AND 
					[Billing].[Clinic].[IsActive] = 1
			)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1
		ORDER BY
			1
		ASC;
		
	OPEN CUR_X;
	
	DECLARE @X_AXIS_NAME NVARCHAR(15);
	
	FETCH NEXT FROM CUR_X INTO @X_AXIS_NAME;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			@X_AXIS_NAME AS [X_AXIS_NAME]
			, (
				SELECT 
					 COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] > 0
				AND 
					[Patient].[Patient].[ClinicID] IN 
					(
						SELECT 
							[User].[UserClinic].[ClinicID] 
						FROM 
							[User].[UserClinic]  WITH (NOLOCK)
						INNER JOIN
							[Billing].[Clinic]  WITH (NOLOCK)
						ON
							[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
						WHERE 
							[User].[UserClinic].[UserID] = @UserID 
						AND 
							[User].[UserClinic].[IsActive] = 1 
						AND 
							[Billing].[Clinic].[IsActive] = 1
					)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [VISITS]			
			
		--CREATED COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @NEW_CLAIM AND @QA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ClinicID] IN 
					(
						SELECT 
							[User].[UserClinic].[ClinicID] 
						FROM 
							[User].[UserClinic]  WITH (NOLOCK)
						INNER JOIN
							[Billing].[Clinic]  WITH (NOLOCK)
						ON
							[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
						WHERE 
							[User].[UserClinic].[UserID] = @UserID 
						AND 
							[User].[UserClinic].[IsActive] = 1 
						AND 
							[Billing].[Clinic].[IsActive] = 1
					)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [IN_PROGRESS]
							
			--Ready to send COUNT_BIG 
	        ,( 
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @READY_TO_SEND_CLAIM AND @EA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			)AS [READY_TO_SEND]
	                                       
			--Sent COUNT_BIG	
			,(
			SELECT 
				COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @EDI_FILE_CREATED AND @SENT_CLAIM_NIT 			
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [SENT]
			
			--Accepted COUNT_BIG
			, (
			SELECT 
		          COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] = @DONE  
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [DONE];
		
		  FETCH NEXT FROM CUR_X INTO @X_AXIS_NAME;
	  END
	
	CLOSE CUR_X;
	DEALLOCATE CUR_X;	
	
	SELECT * FROM @TBL_ANS WHERE ([VISITS] > 0 OR [IN_PROGRESS] > 0 OR [READY_TO_SEND] > 0 OR [SENT] > 0 OR [DONE] > 0) ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSum_PatientVisit] 1, 1, 15, 16, 21, 22, 29, 30


GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_Update_SyncStatus]    Script Date: 07/26/2013 16:14:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_Update_SyncStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_Update_SyncStatus]
GO

/****** Object:  StoredProcedure [Audit].[usp_Update_SyncStatus]    Script Date: 07/26/2013 16:14:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Audit].[usp_Update_SyncStatus] 
AS
BEGIN
	SET NOCOUNT ON;
		
	UPDATE 
		[Audit].[SyncStatus] 
	SET 
		[EndOn] = GETDATE()
		, [IsSuccess] = 1 
	WHERE 
		[EndOn] IS NULL;
			
	-- EXEC [Audit].[usp_Update_SyncStatus] 
END







GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_Insert_SyncStatus]    Script Date: 07/26/2013 16:12:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_Insert_SyncStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_Insert_SyncStatus]
GO


/****** Object:  StoredProcedure [Audit].[usp_Insert_SyncStatus]    Script Date: 07/26/2013 16:12:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Audit].[usp_Insert_SyncStatus] 
	@UserID INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
		
	INSERT INTO 
		[Audit].[SyncStatus] 
		(
			[StartOn]
			, [UserID]
		) 
	VALUES 
	(
		GETDATE()
		, @UserID
	);
			
	-- EXEC [Audit].[usp_Insert_SyncStatus] 
END







GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNameByID_User]    Script Date: 07/26/2013 16:30:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNameByID_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNameByID_User]
GO


/****** Object:  StoredProcedure [User].[usp_GetNameByID_User]    Script Date: 07/26/2013 16:30:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- Select the particular record

CREATE PROCEDURE [User].[usp_GetNameByID_User] 
	@UserID	BIGINT
AS
BEGIN
	SET NOCOUNT ON;	

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [NAME_CODE] NVARCHAR(500) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		((LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL([User].[User].[MiddleName], '')))) + ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
	FROM
		[User].[User] WITH (NOLOCK)
	WHERE
		[User].[User].[UserID] = @UserID
	AND
		[User].[User].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [User].[usp_GetNameByID_User] 1
	
END






GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_Insert_UserReport]    Script Date: 07/26/2013 17:11:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_Insert_UserReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_Insert_UserReport]
GO


/****** Object:  StoredProcedure [Audit].[usp_Insert_UserReport]    Script Date: 07/26/2013 17:11:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Audit].[usp_Insert_UserReport]
	@ReportTypeID TINYINT
	, @ReportObjectID BIGINT = NULL
	, @DateFrom DATETIME = NULL
	, @DateTo DATETIME = NULL
	, @CurrentModificationBy INT
	, @UserReportID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		INSERT INTO [Audit].[UserReport]
		(
			[ReportTypeID]
			, [ReportObjectID]
			, [DateFrom]
			, [DateTo]
			, [CreatedBy]
			, [CreatedOn]
		)
		VALUES
		(
			@ReportTypeID
			, @ReportObjectID
			, @DateFrom
			, @DateTo
			, @CurrentModificationBy
			, @CurrentModificationOn
		);
		
		SELECT @UserReportID = MAX([Audit].[UserReport].[UserReportID]) FROM [Audit].[UserReport];
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @UserReportID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Billing].[usp_GetByManagerID_Clinic]    Script Date: 07/31/2013 11:19:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetByManagerID_Clinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetByManagerID_Clinic]
GO



/****** Object:  StoredProcedure [Billing].[usp_GetByManagerID_Clinic]    Script Date: 07/31/2013 11:19:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Billing].[usp_GetByManagerID_Clinic]
	@ManagerID	int 
   ,@UserID int	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT
       [Billing].[Clinic].[ClinicID]
      ,[Billing].[Clinic].[ClinicName]
      ,(
			SELECT
				[User].[UserClinic].[IsActive]
			FROM
				[User].[UserClinic]
				
			WHERE
				[User].[UserClinic].[UserID] =@UserID
			AND
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
		) AS [IsActive]
		,(
			SELECT
				[User].[UserClinic].[UserClinicID]
			FROM
				[User].[UserClinic]
				
			WHERE
				[User].[UserClinic].[UserID] =@UserID
			AND
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
		) AS [AgentUserClinicID]
	FROM
		 [Billing].[Clinic]
    INNER JOIN
         [User].[UserClinic]		 
    ON
         [Billing].[Clinic].[ClinicID] = [User].[UserClinic].[ClinicID]
	WHERE 
	    [User].[UserClinic].[UserID] = @ManagerID

	
	-- EXEC [Billing].[usp_GetByManagerID_Clinic] @ManagerID = 122 , @UserID = 126
END






GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportSumYrClinic_PatientVisit]    Script Date: 07/31/2013 11:50:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumYrClinic_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumYrClinic_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportSumYrClinic_PatientVisit]    Script Date: 07/31/2013 11:50:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Patient].[usp_GetReportSumYrClinic_PatientVisit]
	@ClinicID INT
	, @YEAR INT
	, @NEW_CLAIM TINYINT
	, @QA_PERSONAL_QUEUE_NIT TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EA_PERSONAL_QUEUE_NIT TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @SENT_CLAIM_NIT TINYINT
	, @DONE TINYINT
AS
BEGIN
	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(15) PRIMARY KEY NOT NULL
		, [VISITS] BIGINT NOT NULL
		, [IN_PROGRESS] BIGINT NOT NULL
		, [READY_TO_SEND] BIGINT NOT NULL
		, [SENT] BIGINT NOT NULL
		, [DONE] BIGINT NOT NULL
	);
	
	DECLARE @LOP_VAL TINYINT;
	SELECT @LOP_VAL = 1;
	
	DECLARE @MAX_VAL TINYINT;
	SELECT @MAX_VAL = 12;
	
	WHILE @LOP_VAL <= @MAX_VAL 
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			@LOP_VAL AS [X_AXIS_NAME]
			, (
				SELECT 
					 COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] > 0
				AND 
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [VISITS]
			
			--CREATED COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @NEW_CLAIM AND @QA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [IN_PROGRESS]
		
			--Ready to send COUNT_BIG 
	        ,( 
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @READY_TO_SEND_CLAIM AND @EA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			)AS [READY_TO_SEND]
	                                       
			--Sent COUNT_BIG	
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @EDI_FILE_CREATED AND @SENT_CLAIM_NIT 			
				AND 
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [SENT]
			
			--Accepted COUNT_BIG
			, (
				SELECT 
					  COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] = @DONE  
				AND 
					[Patient].[Patient].[ClinicID] =@ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [DONE]
		
		  SELECT @LOP_VAL = @LOP_VAL + 1;
	  END	
	
	SELECT * FROM @TBL_ANS WHERE ([VISITS] > 0 OR [IN_PROGRESS] > 0 OR [READY_TO_SEND] > 0 OR [SENT] > 0 OR [DONE] > 0) ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSumYrClinic_PatientVisit] 1, 2011, 1, 15, 16, 21, 22, 29, 30

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportSumMnClinic_PatientVisit]    Script Date: 07/31/2013 11:47:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumMnClinic_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumMnClinic_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetReportSumMnClinic_PatientVisit]    Script Date: 07/31/2013 11:47:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Patient].[usp_GetReportSumMnClinic_PatientVisit]
	@ClinicID INT
	, @YEAR INT
	, @MONTH TINYINT
	, @NEW_CLAIM TINYINT
	, @QA_PERSONAL_QUEUE_NIT TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EA_PERSONAL_QUEUE_NIT TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @SENT_CLAIM_NIT TINYINT
	, @DONE TINYINT
AS
BEGIN
	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(15) PRIMARY KEY NOT NULL
		, [VISITS] BIGINT NOT NULL
		, [IN_PROGRESS] BIGINT NOT NULL
		, [READY_TO_SEND] BIGINT NOT NULL
		, [SENT] BIGINT NOT NULL
		, [DONE] BIGINT NOT NULL
	);
	
	DECLARE @LOP_VAL TINYINT;
	SELECT @LOP_VAL = 1;
	
	DECLARE @MAX_VAL TINYINT;
	SELECT @MAX_VAL = DAY([dbo].[ufn_GetMonthLastDate] (CAST((CAST(@YEAR AS NVARCHAR) + '-' + SUBSTRING(N'JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC ', (@MONTH * 4) - 3, 3) + '-01') AS DATETIME)));
	
	WHILE @LOP_VAL <= @MAX_VAL 
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			@LOP_VAL AS [X_AXIS_NAME]
			, (
				SELECT 
					 COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] > 0
				AND 
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [VISITS]
			
			--CREATED COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @NEW_CLAIM AND @QA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [IN_PROGRESS]
		
			--Ready to send COUNT_BIG 
	        ,( 
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @READY_TO_SEND_CLAIM AND @EA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			)AS [READY_TO_SEND]
	                                       
			--Sent COUNT_BIG	
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @EDI_FILE_CREATED AND @SENT_CLAIM_NIT 			
				AND 
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [SENT]
			
			--Accepted COUNT_BIG
			, (
				SELECT 
					  COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] = @DONE  
				AND 
					[Patient].[Patient].[ClinicID] =@ClinicID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [DONE]
		
		  SELECT @LOP_VAL = @LOP_VAL + 1;
	  END	
	
	SELECT * FROM @TBL_ANS WHERE ([VISITS] > 0 OR [IN_PROGRESS] > 0 OR [READY_TO_SEND] > 0 OR [SENT] > 0 OR [DONE] > 0) ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSumMnClinic_PatientVisit] 1, 2011, 3, 1, 15, 16, 21, 22, 29, 30
-- EXEC [Patient].[usp_GetReportSumMnClinic_PatientVisit] 1, 2011, 2, 1, 15, 16, 21, 22, 29, 30
-- EXEC [Patient].[usp_GetReportSumMnClinic_PatientVisit] 1, 2012, 2, 1, 15, 16, 21, 22, 29, 30


GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetReportSumProvider_PatientVisit]    Script Date: 07/31/2013 11:42:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumProvider_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumProvider_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportSumProvider_PatientVisit]    Script Date: 07/31/2013 11:42:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetReportSumProvider_PatientVisit]
	@ProviderID INT
	, @NEW_CLAIM TINYINT
	, @QA_PERSONAL_QUEUE_NIT TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EA_PERSONAL_QUEUE_NIT TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @SENT_CLAIM_NIT TINYINT
	, @DONE TINYINT
AS
BEGIN
	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(15) PRIMARY KEY NOT NULL
		, [VISITS] BIGINT NOT NULL
		, [IN_PROGRESS] BIGINT NOT NULL
		, [READY_TO_SEND] BIGINT NOT NULL
		, [SENT] BIGINT NOT NULL
		, [DONE] BIGINT NOT NULL
	);
	
	DECLARE CUR_X CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
		SELECT DISTINCT
			CAST(YEAR([Patient].[PatientVisit].[DOS]) AS NVARCHAR(15))
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[Patient].[ProviderID]=@ProviderID
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1
		ORDER BY
			1
		ASC;
		
	OPEN CUR_X;
	
	DECLARE @X_AXIS_NAME NVARCHAR(15);
	
	FETCH NEXT FROM CUR_X INTO @X_AXIS_NAME;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			@X_AXIS_NAME AS [X_AXIS_NAME]
			, (
				SELECT 
					 COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] > 0
				AND 
					[Patient].[Patient].[ProviderID]=@ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [VISITS]
			
			--CREATED COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @NEW_CLAIM AND @QA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ProviderID]=@ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [IN_PROGRESS]
		
			--Ready to send COUNT_BIG 
	        ,( 
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @READY_TO_SEND_CLAIM AND @EA_PERSONAL_QUEUE_NIT 
				AND 
				[Patient].[Patient].[ProviderID]=@ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			)AS [READY_TO_SEND]
	                                       
			--Sent COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @EDI_FILE_CREATED AND @SENT_CLAIM_NIT 			
				AND 
					[Patient].[Patient].[ProviderID]=@ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [SENT]
			
			--Accepted COUNT_BIG
			, (
				SELECT 
					  COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] = @DONE  
				AND 
					[Patient].[Patient] .[ProviderID]=@ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [DONE];
		
		  FETCH NEXT FROM CUR_X INTO @X_AXIS_NAME;
	  END
	
	CLOSE CUR_X;
	DEALLOCATE CUR_X;	
	
	SELECT * FROM @TBL_ANS WHERE ([VISITS] > 0 OR [IN_PROGRESS] > 0 OR [READY_TO_SEND] > 0 OR [SENT] > 0 OR [DONE] > 0) ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSumProvider_PatientVisit] 1, 1, 15, 16, 21, 22, 29, 30

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportSumYr_PatientVisit]    Script Date: 07/31/2013 11:49:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumYr_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumYr_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportSumYr_PatientVisit]    Script Date: 07/31/2013 11:49:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetReportSumYr_PatientVisit]
	@UserID INT
	, @YEAR INT
	, @NEW_CLAIM TINYINT
	, @QA_PERSONAL_QUEUE_NIT TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EA_PERSONAL_QUEUE_NIT TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @SENT_CLAIM_NIT TINYINT
	, @DONE TINYINT
AS
BEGIN
	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(15) NOT NULL
		, [VISITS] BIGINT NOT NULL
		, [IN_PROGRESS] BIGINT NOT NULL
		, [READY_TO_SEND] BIGINT NOT NULL
		, [SENT] BIGINT NOT NULL
		, [DONE] BIGINT NOT NULL
	);
	
	DECLARE @LOP_VAL TINYINT;
	SELECT @LOP_VAL = 1;
	
	DECLARE @MAX_VAL TINYINT;
	SELECT @MAX_VAL = 12;
	
	
		
	WHILE @LOP_VAL <= @MAX_VAL 
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			@LOP_VAL AS [X_AXIS_NAME]
			, (
				SELECT 
					 COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] > 0
				AND 
					[Patient].[Patient].[ClinicID] IN 
					(
						SELECT 
							[User].[UserClinic].[ClinicID] 
						FROM 
							[User].[UserClinic]  WITH (NOLOCK)
						INNER JOIN
							[Billing].[Clinic]  WITH (NOLOCK)
						ON
							[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
						WHERE 
							[User].[UserClinic].[UserID] = @UserID 
						AND 
							[User].[UserClinic].[IsActive] = 1 
						AND 
							[Billing].[Clinic].[IsActive] = 1
					)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [VISITS]			
			
		--CREATED COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @NEW_CLAIM AND @QA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ClinicID] IN 
					(
						SELECT 
							[User].[UserClinic].[ClinicID] 
						FROM 
							[User].[UserClinic]  WITH (NOLOCK)
						INNER JOIN
							[Billing].[Clinic]  WITH (NOLOCK)
						ON
							[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
						WHERE 
							[User].[UserClinic].[UserID] = @UserID 
						AND 
							[User].[UserClinic].[IsActive] = 1 
						AND 
							[Billing].[Clinic].[IsActive] = 1
					)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [IN_PROGRESS]
							
			--Ready to send COUNT_BIG 
	        ,( 
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @READY_TO_SEND_CLAIM AND @EA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			)AS [READY_TO_SEND]
	                                       
			--Sent COUNT_BIG	
			,(
			SELECT 
				COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @EDI_FILE_CREATED AND @SENT_CLAIM_NIT 			
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [SENT]
			
			--Accepted COUNT_BIG
			, (
			SELECT 
		          COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] = @DONE  
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [DONE];
		
		 SELECT @LOP_VAL = @LOP_VAL + 1;
	  END	
	
	SELECT * FROM @TBL_ANS WHERE ([VISITS] > 0 OR [IN_PROGRESS] > 0 OR [READY_TO_SEND] > 0 OR [SENT] > 0 OR [DONE] > 0) ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSumYr_PatientVisit]1, 1, 15, 16, 21, 22, 29, 30


GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetReportSumYrProvider_PatientVisit]    Script Date: 07/31/2013 11:56:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumYrProvider_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumYrProvider_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportSumYrProvider_PatientVisit]    Script Date: 07/31/2013 11:56:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Patient].[usp_GetReportSumYrProvider_PatientVisit]
	@ProviderID INT
	, @YEAR INT
	, @NEW_CLAIM TINYINT
	, @QA_PERSONAL_QUEUE_NIT TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EA_PERSONAL_QUEUE_NIT TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @SENT_CLAIM_NIT TINYINT
	, @DONE TINYINT
AS
BEGIN
	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(15) PRIMARY KEY NOT NULL
		, [VISITS] BIGINT NOT NULL
		, [IN_PROGRESS] BIGINT NOT NULL
		, [READY_TO_SEND] BIGINT NOT NULL
		, [SENT] BIGINT NOT NULL
		, [DONE] BIGINT NOT NULL
	);
	
	DECLARE @LOP_VAL TINYINT;
	SELECT @LOP_VAL = 1;
	
	DECLARE @MAX_VAL TINYINT;
	SELECT @MAX_VAL = 12;
	
	WHILE @LOP_VAL <= @MAX_VAL 
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			@LOP_VAL AS [X_AXIS_NAME]
			, (
				SELECT 
					 COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] > 0
				AND 
					[Patient].[Patient].[ProviderID] = @ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [VISITS]
			
			--CREATED COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @NEW_CLAIM AND @QA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ProviderID] = @ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [IN_PROGRESS]
		
			--Ready to send COUNT_BIG 
	        ,( 
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @READY_TO_SEND_CLAIM AND @EA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ProviderID] = @ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			)AS [READY_TO_SEND]
	                                       
			--Sent COUNT_BIG	
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @EDI_FILE_CREATED AND @SENT_CLAIM_NIT 			
				AND 
					[Patient].[Patient].[ProviderID] = @ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [SENT]
			
			--Accepted COUNT_BIG
			, (
				SELECT 
					  COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] = @DONE  
				AND 
					[Patient].[Patient].[ProviderID] =@ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [DONE]
		
		  SELECT @LOP_VAL = @LOP_VAL + 1;
	  END	
	
	SELECT * FROM @TBL_ANS WHERE ([VISITS] > 0 OR [IN_PROGRESS] > 0 OR [READY_TO_SEND] > 0 OR [SENT] > 0 OR [DONE] > 0) ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSumYrClinic_PatientVisit] 1, 2011, 1, 15, 16, 21, 22, 29, 30

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportSumMn_PatientVisit]    Script Date: 07/31/2013 11:45:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumMn_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumMn_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportSumMn_PatientVisit]    Script Date: 07/31/2013 11:45:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetReportSumMn_PatientVisit]
	@UserID INT
	, @YEAR INT
	, @MONTH TINYINT
	, @NEW_CLAIM TINYINT
	, @QA_PERSONAL_QUEUE_NIT TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EA_PERSONAL_QUEUE_NIT TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @SENT_CLAIM_NIT TINYINT
	, @DONE TINYINT
AS
BEGIN
	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(15) NOT NULL
		, [VISITS] BIGINT NOT NULL
		, [IN_PROGRESS] BIGINT NOT NULL
		, [READY_TO_SEND] BIGINT NOT NULL
		, [SENT] BIGINT NOT NULL
		, [DONE] BIGINT NOT NULL
	);
	
	DECLARE @LOP_VAL TINYINT;
	SELECT @LOP_VAL = 1;
	
	DECLARE @MAX_VAL TINYINT;
	SELECT @MAX_VAL = DAY([dbo].[ufn_GetMonthLastDate] (CAST((CAST(@YEAR AS NVARCHAR) + '-' + SUBSTRING(N'JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC ', (@MONTH * 4) - 3, 3) + '-01') AS DATETIME)));
	
	WHILE @LOP_VAL <= @MAX_VAL 
	
	
	
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			@LOP_VAL AS [X_AXIS_NAME]
			, (
				SELECT 
					 COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] > 0
				AND 
					[Patient].[Patient].[ClinicID] IN 
					(
						SELECT 
							[User].[UserClinic].[ClinicID] 
						FROM 
							[User].[UserClinic]  WITH (NOLOCK)
						INNER JOIN
							[Billing].[Clinic]  WITH (NOLOCK)
						ON
							[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
						WHERE 
							[User].[UserClinic].[UserID] = @UserID 
						AND 
							[User].[UserClinic].[IsActive] = 1 
						AND 
							[Billing].[Clinic].[IsActive] = 1
					)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [VISITS]			
			
		--CREATED COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @NEW_CLAIM AND @QA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ClinicID] IN 
					(
						SELECT 
							[User].[UserClinic].[ClinicID] 
						FROM 
							[User].[UserClinic]  WITH (NOLOCK)
						INNER JOIN
							[Billing].[Clinic]  WITH (NOLOCK)
						ON
							[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
						WHERE 
							[User].[UserClinic].[UserID] = @UserID 
						AND 
							[User].[UserClinic].[IsActive] = 1 
						AND 
							[Billing].[Clinic].[IsActive] = 1
					)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [IN_PROGRESS]
							
			--Ready to send COUNT_BIG 
	        ,( 
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @READY_TO_SEND_CLAIM AND @EA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			)AS [READY_TO_SEND]
	                                       
			--Sent COUNT_BIG	
			,(
			SELECT 
				COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @EDI_FILE_CREATED AND @SENT_CLAIM_NIT 			
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [SENT]
			
			--Accepted COUNT_BIG
			, (
			SELECT 
		          COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] = @DONE  
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [DONE];
		
		   SELECT @LOP_VAL = @LOP_VAL + 1;
	  END	
	
	SELECT * FROM @TBL_ANS WHERE ([VISITS] > 0 OR [IN_PROGRESS] > 0 OR [READY_TO_SEND] > 0 OR [SENT] > 0 OR [DONE] > 0) ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSumMn_PatientVisit] 1, 1, 15, 16, 21, 22, 29, 30


GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetReportSumMnProvider_PatientVisit]    Script Date: 07/31/2013 11:48:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumMnProvider_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumMnProvider_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportSumMnProvider_PatientVisit]    Script Date: 07/31/2013 11:48:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetReportSumMnProvider_PatientVisit]
	@ProviderID INT
	, @YEAR INT
	, @MONTH TINYINT
	, @NEW_CLAIM TINYINT
	, @QA_PERSONAL_QUEUE_NIT TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EA_PERSONAL_QUEUE_NIT TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @SENT_CLAIM_NIT TINYINT
	, @DONE TINYINT
AS
BEGIN
	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(15) PRIMARY KEY NOT NULL
		, [VISITS] BIGINT NOT NULL
		, [IN_PROGRESS] BIGINT NOT NULL
		, [READY_TO_SEND] BIGINT NOT NULL
		, [SENT] BIGINT NOT NULL
		, [DONE] BIGINT NOT NULL
	);
	
	DECLARE @LOP_VAL TINYINT;
	SELECT @LOP_VAL = 1;
	
	DECLARE @MAX_VAL TINYINT;
	SELECT @MAX_VAL = DAY([dbo].[ufn_GetMonthLastDate] (CAST((CAST(@YEAR AS NVARCHAR) + '-' + SUBSTRING(N'JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC ', (@MONTH * 4) - 3, 3) + '-01') AS DATETIME)));
	
	WHILE @LOP_VAL <= @MAX_VAL 
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			@LOP_VAL AS [X_AXIS_NAME]
			, (
				SELECT 
					 COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] > 0
				AND 
					[Patient].[Patient].[ProviderID]=@ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [VISITS]
			
			--CREATED COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @NEW_CLAIM AND @QA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ProviderID]=@ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [IN_PROGRESS]
		
			--Ready to send COUNT_BIG 
	        ,( 
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @READY_TO_SEND_CLAIM AND @EA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[ProviderID]=@ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			)AS [READY_TO_SEND]
	                                       
			--Sent COUNT_BIG	
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @EDI_FILE_CREATED AND @SENT_CLAIM_NIT 			
				AND 
					[Patient].[Patient].[ProviderID]=@ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [SENT]
			
			--Accepted COUNT_BIG
			, (
				SELECT 
					  COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] = @DONE  
				AND 
					[Patient].[Patient].[ProviderID]=@ProviderID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [DONE]
		
		  SELECT @LOP_VAL = @LOP_VAL + 1;
	  END	
	
	SELECT * FROM @TBL_ANS WHERE ([VISITS] > 0 OR [IN_PROGRESS] > 0 OR [READY_TO_SEND] > 0 OR [SENT] > 0 OR [DONE] > 0) ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSumMnProvider_PatientVisit] 1, 2011, 3, 1, 15, 16, 21, 22, 29, 30
-- EXEC [Patient].[usp_GetReportSumMnProvider_PatientVisit] 1, 2011, 2, 1, 15, 16, 21, 22, 29, 30
-- EXEC [Patient].[usp_GetReportSumMnProvider_PatientVisit] 1, 2012, 2, 1, 15, 16, 21, 22, 29, 30


GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportSumPatient_PatientVisit]    Script Date: 07/31/2013 11:44:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumPatient_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumPatient_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportSumPatient_PatientVisit]    Script Date: 07/31/2013 11:44:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetReportSumPatient_PatientVisit]
	@PatientID BIGINT
	, @NEW_CLAIM TINYINT
	, @QA_PERSONAL_QUEUE_NIT TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EA_PERSONAL_QUEUE_NIT TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @SENT_CLAIM_NIT TINYINT
	, @DONE TINYINT
AS
BEGIN
	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(15) PRIMARY KEY NOT NULL
		, [VISITS] BIGINT NOT NULL
		, [IN_PROGRESS] BIGINT NOT NULL
		, [READY_TO_SEND] BIGINT NOT NULL
		, [SENT] BIGINT NOT NULL
		, [DONE] BIGINT NOT NULL
	);
	
	DECLARE CUR_X CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
		SELECT DISTINCT
			CAST(YEAR([Patient].[PatientVisit].[DOS]) AS NVARCHAR(15))
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[Patient].[PatientID]=@PatientID 
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1
		ORDER BY
			1
		ASC;
		
	OPEN CUR_X;
	
	DECLARE @X_AXIS_NAME NVARCHAR(15);
	
	FETCH NEXT FROM CUR_X INTO @X_AXIS_NAME;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			@X_AXIS_NAME AS [X_AXIS_NAME]
			, (
				SELECT 
					 COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] > 0
				AND 
					[Patient].[Patient].[PatientID]=@PatientID 
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [VISITS]
			
			--CREATED COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @NEW_CLAIM AND @QA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[PatientID]=@PatientID 
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [IN_PROGRESS]
		
			--Ready to send COUNT_BIG 
	        ,( 
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @READY_TO_SEND_CLAIM AND @EA_PERSONAL_QUEUE_NIT 
				AND 
				[Patient].[Patient].[PatientID]=@PatientID 
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			)AS [READY_TO_SEND]
	                                       
			--Sent COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @EDI_FILE_CREATED AND @SENT_CLAIM_NIT 			
				AND 
					[Patient].[Patient].[PatientID]=@PatientID 
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [SENT]
			
			--Accepted COUNT_BIG
			, (
				SELECT 
					  COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] = @DONE  
				AND 
					[Patient].[Patient].[PatientID]=@PatientID 
				AND
					YEAR([Patient].[PatientVisit].[DOS]) =@X_AXIS_NAME
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [DONE];
		
		  FETCH NEXT FROM CUR_X INTO @X_AXIS_NAME;
	  END
	
	CLOSE CUR_X;
	DEALLOCATE CUR_X;	
	
	SELECT * FROM @TBL_ANS WHERE ([VISITS] > 0 OR [IN_PROGRESS] > 0 OR [READY_TO_SEND] > 0 OR [SENT] > 0 OR [DONE] > 0) ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSumPatient_PatientVisit] 1, 1, 15, 16, 21, 22, 29, 30

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportSumMnPatient_PatientVisit]    Script Date: 07/31/2013 11:48:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumMnPatient_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumMnPatient_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportSumMnPatient_PatientVisit]    Script Date: 07/31/2013 11:48:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetReportSumMnPatient_PatientVisit]
	@PatientID BIGINT
	, @YEAR INT
	, @MONTH TINYINT
	, @NEW_CLAIM TINYINT
	, @QA_PERSONAL_QUEUE_NIT TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EA_PERSONAL_QUEUE_NIT TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @SENT_CLAIM_NIT TINYINT
	, @DONE TINYINT
AS
BEGIN
	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(15) PRIMARY KEY NOT NULL
		, [VISITS] BIGINT NOT NULL
		, [IN_PROGRESS] BIGINT NOT NULL
		, [READY_TO_SEND] BIGINT NOT NULL
		, [SENT] BIGINT NOT NULL
		, [DONE] BIGINT NOT NULL
	);
	
	DECLARE @LOP_VAL TINYINT;
	SELECT @LOP_VAL = 1;
	
	DECLARE @MAX_VAL TINYINT;
	SELECT @MAX_VAL = DAY([dbo].[ufn_GetMonthLastDate] (CAST((CAST(@YEAR AS NVARCHAR) + '-' + SUBSTRING(N'JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC ', (@MONTH * 4) - 3, 3) + '-01') AS DATETIME)));
	
	WHILE @LOP_VAL <= @MAX_VAL 
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			@LOP_VAL AS [X_AXIS_NAME]
			, (
				SELECT 
					 COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] > 0
				AND 
					[Patient].[Patient].[PatientID]=@PatientID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [VISITS]
			
			--CREATED COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @NEW_CLAIM AND @QA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[PatientID]=@PatientID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [IN_PROGRESS]
		
			--Ready to send COUNT_BIG 
	        ,( 
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @READY_TO_SEND_CLAIM AND @EA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[PatientID]=@PatientID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			)AS [READY_TO_SEND]
	                                       
			--Sent COUNT_BIG	
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @EDI_FILE_CREATED AND @SENT_CLAIM_NIT 			
				AND 
					[Patient].[Patient].[PatientID]=@PatientID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [SENT]
			
			--Accepted COUNT_BIG
			, (
				SELECT 
					  COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] = @DONE  
				AND 
					[Patient].[Patient].[PatientID]=@PatientID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @MONTH
				AND
					DAY([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [DONE]
		
		  SELECT @LOP_VAL = @LOP_VAL + 1;
	  END	
	
	SELECT * FROM @TBL_ANS WHERE ([VISITS] > 0 OR [IN_PROGRESS] > 0 OR [READY_TO_SEND] > 0 OR [SENT] > 0 OR [DONE] > 0) ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSumMnPatient_PatientVisit] 1, 2011, 3, 1, 15, 16, 21, 22, 29, 30
-- EXEC [Patient].[usp_GetReportSumMnPatient_PatientVisit] 1, 2011, 2, 1, 15, 16, 21, 22, 29, 30
-- EXEC [Patient].[usp_GetReportSumMnPatient_PatientVisit] 1, 2012, 2, 1, 15, 16, 21, 22, 29, 30


GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportSumYrPatient_PatientVisit]    Script Date: 07/31/2013 11:51:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumYrPatient_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumYrPatient_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportSumYrPatient_PatientVisit]    Script Date: 07/31/2013 11:51:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Patient].[usp_GetReportSumYrPatient_PatientVisit]
	@PatientID BIGINT
	, @YEAR INT
	, @NEW_CLAIM TINYINT
	, @QA_PERSONAL_QUEUE_NIT TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EA_PERSONAL_QUEUE_NIT TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @SENT_CLAIM_NIT TINYINT
	, @DONE TINYINT
AS
BEGIN
	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(15) PRIMARY KEY NOT NULL
		, [VISITS] BIGINT NOT NULL
		, [IN_PROGRESS] BIGINT NOT NULL
		, [READY_TO_SEND] BIGINT NOT NULL
		, [SENT] BIGINT NOT NULL
		, [DONE] BIGINT NOT NULL
	);
	
	DECLARE @LOP_VAL TINYINT;
	SELECT @LOP_VAL = 1;
	
	DECLARE @MAX_VAL TINYINT;
	SELECT @MAX_VAL = 12;
	
	WHILE @LOP_VAL <= @MAX_VAL 
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			@LOP_VAL AS [X_AXIS_NAME]
			, (
				SELECT 
					 COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] > 0
				AND 
					[Patient].[Patient].[PatientID] = @PatientID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [VISITS]
			
			--CREATED COUNT_BIG
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @NEW_CLAIM AND @QA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[PatientID] = @PatientID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [IN_PROGRESS]
		
			--Ready to send COUNT_BIG 
	        ,( 
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @READY_TO_SEND_CLAIM AND @EA_PERSONAL_QUEUE_NIT 
				AND 
					[Patient].[Patient].[PatientID] = @PatientID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			)AS [READY_TO_SEND]
	                                       
			--Sent COUNT_BIG	
			,(
				SELECT 
					COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] BETWEEN @EDI_FILE_CREATED AND @SENT_CLAIM_NIT 			
				AND 
					[Patient].[Patient].[PatientID] = @PatientID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [SENT]
			
			--Accepted COUNT_BIG
			, (
				SELECT 
					  COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
				FROM
					[Patient].[PatientVisit] WITH (NOLOCK)
				INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				ON
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				WHERE
					[Patient].[PatientVisit].[ClaimStatusID] = @DONE  
				AND 
					[Patient].[Patient].[PatientID] =@PatientID
				AND
					YEAR([Patient].[PatientVisit].[DOS]) = @YEAR
				AND
					MONTH([Patient].[PatientVisit].[DOS]) = @LOP_VAL
				AND
					[Patient].[PatientVisit].[IsActive] = 1
				AND
					[Patient].[Patient].[IsActive] = 1
			) AS [DONE]
		
		  SELECT @LOP_VAL = @LOP_VAL + 1;
	  END	
	
	SELECT * FROM @TBL_ANS WHERE ([VISITS] > 0 OR [IN_PROGRESS] > 0 OR [READY_TO_SEND] > 0 OR [SENT] > 0 OR [DONE] > 0) ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSumYrPatient_PatientVisit] 1, 2011, 1, 15, 16, 21, 22, 29, 30

GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboardAgent_PatientVisit]    Script Date: 07/29/2013 17:34:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDashboardAgent_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDashboardAgent_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboardAgent_PatientVisit]    Script Date: 07/29/2013 17:34:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Patient].[usp_GetReportDashboardAgent_PatientVisit]
	@UserID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DECLARE @StatusIDs NVARCHAR(150);
	DECLARE @FromDiff INT;
	DECLARE @ToDiff INT;
	DECLARE @StatusID INT;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[PatientVisitID] BIGINT
	);
	
	IF @Desc = 'Visits'
	BEGIN
		SELECT @StatusIDS = '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Created'
	BEGIN
		SELECT @StatusIDS = '10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Hold'
	BEGIN
		SELECT @StatusIDS = '6, 7';
	END
	
	IF @Desc = 'Ready To Send'
	BEGIN
		SELECT @StatusIDS = '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Sent'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Accepted'
	BEGIN
		SELECT @StatusIDS = '29, 30';
	END
	
	IF @Desc = 'Rejected'
	BEGIN
		SELECT @StatusIDS = '26, 27';
		SELECT @StatusID = 12;
	END
	
	IF @Desc = 'Re-Submitted'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
		SELECT @StatusID = 22;
	END
	
	IF @DayCount = 'SEVEN'
	BEGIN
		SELECT @FromDiff = 1;
		SELECT @ToDiff = 7;
	END
	
	IF @DayCount = 'THIRTY'
	BEGIN
		SELECT @FromDiff = 8;
		SELECT @ToDiff = 30;
	END
		
	IF (@Desc = 'Re-Submitted' OR @Desc = 'Rejected')
	BEGIN
		 IF @DayCount = 'ONE'
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > @StatusID
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
			
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
		
		ELSE IF @DayCount = 'THIRTYPLUS'
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]						
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > @StatusID
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
		
		
		ELSE IF @DayCount = 'TOTAL'
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > @StatusID
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		
		ELSE 
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > @StatusID
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
	END
---------
	ELSE
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
			
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	-------
	ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	------
		ELSE IF @DayCount <> 'ALL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
--------------
	IF @Desc = 'Visits' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] > 0
		AND 
			[Patient].[Patient].[ClinicID] IN 
			(
				SELECT 
					[User].[UserClinic].[ClinicID] 
				FROM 
					[User].[UserClinic]  WITH (NOLOCK)
				INNER JOIN
					[Billing].[Clinic]  WITH (NOLOCK)
				ON
					[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
				WHERE 
					[User].[UserClinic].[UserID] = @UserID 
				AND 
					[User].[UserClinic].[IsActive] = 1 
				AND 
					[Billing].[Clinic].[IsActive] = 1
			)
		AND
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Accepted' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
		AND 
			[Patient].[Patient].[ClinicID] IN 
			(
				SELECT 
					[User].[UserClinic].[ClinicID] 
				FROM 
					[User].[UserClinic]  WITH (NOLOCK)
				INNER JOIN
					[Billing].[Clinic] WITH (NOLOCK) 
				ON
					[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
				WHERE 
					[User].[UserClinic].[UserID] = @UserID 
				AND 
					[User].[UserClinic].[IsActive] = 1 
				AND 
					[Billing].[Clinic].[IsActive] = 1
			)
		AND
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Blocked' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[Patient].[ClinicID] IN 
			(
				SELECT 
					[User].[UserClinic].[ClinicID] 
				FROM 
					[User].[UserClinic]  WITH (NOLOCK)
				INNER JOIN
					[Billing].[Clinic]  WITH (NOLOCK)
				ON
					[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
				WHERE 
					[User].[UserClinic].[UserID] = @UserID 
				AND 
					[User].[UserClinic].[IsActive] = 1 
				AND 
					[Billing].[Clinic].[IsActive] = 1
			)
		AND
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
		(
			[Patient].[PatientVisit].[IsActive] = 0
		OR
			[Patient].[Patient].[IsActive] = 0
		);
	END
	
	ELSE IF @Desc = 'NIT' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (3, 5, 8, 12, 14, 18, 20, 24, 27)
		AND
			[Patient].[Patient].[ClinicID] IN 
			(
				SELECT 
					[User].[UserClinic].[ClinicID] 
				FROM 
					[User].[UserClinic]  WITH (NOLOCK)
				INNER JOIN
					[Billing].[Clinic]  WITH (NOLOCK)
				ON
					[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
				WHERE 
					[User].[UserClinic].[UserID] = @UserID 
				AND 
					[User].[UserClinic].[IsActive] = 1 
				AND 
					[Billing].[Clinic].[IsActive] = 1
			)
		AND
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
END
	
		
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		[Patient].[PatientVisit].[PatientVisitID]  IN
		(SELECT [PatientVisitID] FROM @SEARCH_TMP)
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1;
	
	
	-- EXEC [Patient].[usp_GetReportDashboardAgent_PatientVisit]  @UserID=116 , @Desc = 'Visits', @DayCount = 'THIRTYPLUS'
	-- EXEC [Patient].[usp_GetReportDashboardAgent_PatientVisit]  @UserID=116 , @Desc = 'Visits', @DayCount = 'ONE'
	-- EXEC [Patient].[usp_GetReportDashboardAgent_PatientVisit]  @UserID=116 , @Desc = 'Rejected', @DayCount = 'TOTAL'
	-- EXEC [Patient].[usp_GetReportDashboardAgent_PatientVisit]  @UserID = '116', @Desc = 'Visits', @DayCount = 'THIRTYPLUS', @SearchName  = 'a'
END










GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseSummary_PatientVisit]    Script Date: 07/31/2013 13:26:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAgentWiseSummary_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAgentWiseSummary_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseSummary_PatientVisit]    Script Date: 07/31/2013 13:26:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [Patient].[usp_GetAgentWiseSummary_PatientVisit]
	@UserID BIGINT
	, @NEW_CLAIM TINYINT
	, @BA_HOLDED TINYINT
	, @CREATED_CLAIM TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @REJECTED_CLAIM TINYINT
	, @REJECTED_CLAIM_NIT TINYINT
	, @ACCEPTED_CLAIM TINYINT
AS
BEGIN
	-- SET NOCOUNT_BIG ON added to prevent extra result sets from
	-- BIGINTerfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY (1, 1) NOT NULL
		, [DESC] NVARCHAR(15) NOT NULL
		, [COUNT1] BIGINT NOT NULL
		, [COUNT7] BIGINT NOT NULL
		, [COUNT30] BIGINT NOT NULL
		, [COUNT31PLUS] BIGINT NOT NULL
		, [COUNTTOTAL] BIGINT NOT NULL
	);
	
	DECLARE @Data1 BIGINT;
	DECLARE @Data7 BIGINT;
	DECLARE @Data30 BIGINT;
	DECLARE @Data31Plus BIGINT;
	DECLARE @DataTotal BIGINT;	
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[CreatedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[CreatedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT [User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[CreatedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[CreatedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;	
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Visits'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	--Created COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;	

	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Created'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
--Hold COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK) 
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Hold'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	
--Ready to send COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Ready To Send'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);

--Sent COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Sent'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	--Accepted COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Accepted'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);


	--Rejected COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK) 
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK) 
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Rejected'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);

--Resubmitted COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
	AND
		[Claim].[ClaimProcess].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
		)
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
	AND
		[Claim].[ClaimProcess].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] WITH (NOLOCK) 
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
		)
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
	AND
		[Claim].[ClaimProcess].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] WITH (NOLOCK) 
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
		)
	AND
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
	AND
		[Claim].[ClaimProcess].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess]  WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
		)
	AND
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Re-Submitted'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	SELECT * FROM @TBL_ANS ORDER BY [ID] ASC;		
	
	-- EXEC [Patient].[usp_GetAgentWiseSummary_PatientVisit]  @UserID = 116, 1,6,10,16,22,26,27,29
END











GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportSumAgentWise_PatientVisit]    Script Date: 08/02/2013 09:26:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumAgentWise_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumAgentWise_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportSumAgentWise_PatientVisit]    Script Date: 08/02/2013 09:26:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [Patient].[usp_GetReportSumAgentWise_PatientVisit]
	@UserID INT
	 ,@DateFrom DATE
     ,@DateTo DATE
     
AS
BEGIN
	 
	SET NOCOUNT ON;
		DECLARE @TBL_ANS TABLE 
	(
		[ID] INT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] DATE NOT NULL
		, [VISITS] BIGINT NOT NULL
		);
	
	DECLARE @LOP_VAL Date;
	SELECT @LOP_VAL =@DateFrom;
	
	DECLARE @MAX_VAL Date;
	SELECT @MAX_VAL =@DateTo;
	 
	WHILE @LOP_VAL <= @MAX_VAL 
	
	        BEGIN
	        INSERT INTO
			       @TBL_ANS
		    SELECT
			 @LOP_VAL AS [X_AXIS_NAME]
			, (
				 SELECT 
					 COUNT_BIG(DISTINCT [Claim].[ClaimProcess].[PatientVisitID] ) 
				 FROM 
					 [Claim].[ClaimProcess]  WITH (NOLOCK)
			     INNER JOIN
		             [Patient].[PatientVisit]  WITH (NOLOCK) 
		         ON
		           [Patient].[PatientVisit].[PatientVisitID]  = [Claim].[ClaimProcess].[PatientVisitID]
		         INNER JOIN
					[Patient].[Patient] WITH (NOLOCK)
				 ON 
					[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
				 INNER JOIN
					[User].[UserClinic]
				 ON 
		            [User].[UserClinic].[ClinicID]=[Patient].[Patient].[ClinicID]
				 WHERE 
				
		          [User].[UserClinic].[ClinicID] IN
	                             (
									SELECT 
										[B] .[ClinicID] 
									FROM 
										[User].[UserClinic] [B]  WITH (NOLOCK)
									INNER JOIN
										[Billing].[Clinic]  WITH (NOLOCK)
									ON
										[B] .[ClinicID] = [Billing].[Clinic].[ClinicID]
									WHERE 
										[B] .[UserID] = @UserID
									AND 
										[B] .[IsActive] = 1 
									AND 
										[Billing].[Clinic].[IsActive] = 1
								 )
				AND
				     [Claim].[ClaimProcess].[CreatedBy] = @UserID 
				AND 
					 [Patient].[PatientVisit].[DOS] = @LOP_VAL
					) AS [VISITS]	
					
					 SELECT @LOP_VAL = DATEADD(DAY,1,@LOP_VAL )
					 
					 END
					 SELECT * FROM @TBL_ANS WHERE [VISITS] > 0 ORDER BY 1 ASC;
	
END
	
-- EXEC [Patient].[usp_GetReportSumAgentWise_PatientVisit] 6,'2006-JUL-05','2013-JUL-31'


GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Excel].[usp_GetByPkId_ReportType]    Script Date: 07/31/2013 15:39:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Excel].[usp_GetByPkId_ReportType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Excel].[usp_GetByPkId_ReportType]
GO


/****** Object:  StoredProcedure [Excel].[usp_GetByPkId_ReportType]    Script Date: 07/31/2013 15:39:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Select the particular record

CREATE PROCEDURE [Excel].[usp_GetByPkId_ReportType] 
	@ReportTypeID	TINYINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Excel].[ReportType].*
	FROM
		[Excel].[ReportType]
	WHERE
		[Excel].[ReportType].[ReportTypeID] = @ReportTypeID
	AND
		[Excel].[ReportType].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Excel].[ReportType].[IsActive] ELSE @IsActive END;

	-- EXEC [Excel].[usp_GetByPkId_ReportType] 1, NULL
	-- EXEC [Excel].[usp_GetByPkId_ReportType] 1, 1
	-- EXEC [Excel].[usp_GetByPkId_ReportType] 1, 0
END

GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Excel].[usp_Insert_ReportType]    Script Date: 07/31/2013 15:40:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Excel].[usp_Insert_ReportType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Excel].[usp_Insert_ReportType]
GO


/****** Object:  StoredProcedure [Excel].[usp_Insert_ReportType]    Script Date: 07/31/2013 15:40:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Excel].[usp_Insert_ReportType]
	@ReportTypeCode NVARCHAR(2)
	, @ReportTypeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @ReportTypeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @ReportTypeID = [Excel].[ufn_IsExists_ReportType] (@ReportTypeCode, @ReportTypeName, @Comment, 0);
		
		IF @ReportTypeID = 0
		BEGIN
			INSERT INTO [Excel].[ReportType]
			(
				[ReportTypeCode]
				, [ReportTypeName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@ReportTypeCode
				, @ReportTypeName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @ReportTypeID = MAX([Excel].[ReportType].[ReportTypeID]) FROM [Excel].[ReportType];
		END
		ELSE
		BEGIN			
			SELECT @ReportTypeID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @ReportTypeID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Excel].[usp_IsExists_ReportType]    Script Date: 07/31/2013 15:41:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Excel].[usp_IsExists_ReportType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Excel].[usp_IsExists_ReportType]
GO


/****** Object:  StoredProcedure [Excel].[usp_IsExists_ReportType]    Script Date: 07/31/2013 15:41:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Output 0, if the record not exists, otherwise output that primary key id value

CREATE PROCEDURE [Excel].[usp_IsExists_ReportType]
	@ReportTypeCode NVARCHAR(2)
	, @ReportTypeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @ReportTypeID	TINYINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @ReportTypeID = [Excel].[ufn_IsExists_ReportType] (@ReportTypeCode, @ReportTypeName, @Comment, 0);
END

GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Excel].[usp_Update_ReportType]    Script Date: 07/31/2013 15:42:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Excel].[usp_Update_ReportType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Excel].[usp_Update_ReportType]
GO



/****** Object:  StoredProcedure [Excel].[usp_Update_ReportType]    Script Date: 07/31/2013 15:42:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Description:This Stored Procedure is used to UPDATE the ReportType in the database.
	 
CREATE PROCEDURE [Excel].[usp_Update_ReportType]
	@ReportTypeCode NVARCHAR(2)
	, @ReportTypeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @ReportTypeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @ReportTypeID_PREV BIGINT;
		SELECT @ReportTypeID_PREV = [Excel].[ufn_IsExists_ReportType] (@ReportTypeCode, @ReportTypeName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Excel].[ReportType].[ReportTypeID] FROM [Excel].[ReportType] WHERE [Excel].[ReportType].[ReportTypeID] = @ReportTypeID AND [Excel].[ReportType].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@ReportTypeID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Excel].[ReportType].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Excel].[ReportType].[LastModifiedOn]
			FROM 
				[Excel].[ReportType] WITH (NOLOCK)
			WHERE
				[Excel].[ReportType].[ReportTypeID] = @ReportTypeID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Excel].[ReportTypeHistory]
					(
						[ReportTypeID]
						, [ReportTypeCode]
						, [ReportTypeName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Excel].[ReportType].[ReportTypeID]
					, [Excel].[ReportType].[ReportTypeCode]
					, [Excel].[ReportType].[ReportTypeName]
					, [Excel].[ReportType].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Excel].[ReportType].[IsActive]
				FROM 
					[Excel].[ReportType]
				WHERE
					[Excel].[ReportType].[ReportTypeID] = @ReportTypeID;
				
				UPDATE 
					[Excel].[ReportType]
				SET
					[Excel].[ReportType].[ReportTypeCode] = @ReportTypeCode
					, [Excel].[ReportType].[ReportTypeName] = @ReportTypeName
					, [Excel].[ReportType].[Comment] = @Comment
					, [Excel].[ReportType].[LastModifiedBy] = @CurrentModificationBy
					, [Excel].[ReportType].[LastModifiedOn] = @CurrentModificationOn
					, [Excel].[ReportType].[IsActive] = @IsActive
				WHERE
					[Excel].[ReportType].[ReportTypeID] = @ReportTypeID;				
			END
			ELSE
			BEGIN
				SELECT @ReportTypeID = -2;
			END
		END
		ELSE IF @ReportTypeID_PREV <> @ReportTypeID
		BEGIN			
			SELECT @ReportTypeID = -1;			
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
			SELECT @ReportTypeID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [EDI].[usp_GetCount835_EDIFile]    Script Date: 08/05/2013 17:55:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetCount835_EDIFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetCount835_EDIFile]
GO



/****** Object:  StoredProcedure [EDI].[usp_GetCount835_EDIFile]    Script Date: 08/05/2013 17:55:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [EDI].[usp_GetCount835_EDIFile]
	@ClinicID int
	, @StatusIDs NVARCHAR(100)
	, @UserID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_SID TABLE
	(
		[CLAIM_STATUS_ID] TINYINT PRIMARY KEY NOT NULL
	);
	
	INSERT INTO
		@TBL_SID
	SELECT DISTINCT
		[Data] 
	FROM 
		[dbo].[ufn_StringSplit] (@StatusIDs, ',');
	
	DECLARE @TBL_EID TABLE
	(
		[EDI_FILE_ID] INT PRIMARY KEY NOT NULL
	);
	
	INSERT INTO
		@TBL_EID
	SELECT DISTINCT
		[B].[EDIFileID]
	FROM
		[Claim].[ClaimProcessEDIFile] B WITH (NOLOCK)
	INNER JOIN
		[Claim].[ClaimProcess] C WITH (NOLOCK)
	ON
		[C].[ClaimProcessID] = [B].[ClaimProcessID]
	INNER JOIN
		[Patient].[PatientVisit] D WITH (NOLOCK)
	ON
		[D].[PatientVisitID] = [C].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] E WITH (NOLOCK)
	ON
		[E].[PatientID] = [D].[PatientID]
	INNER JOIN
		@TBL_SID F
	ON
		[F].[CLAIM_STATUS_ID] = [D].[ClaimStatusID]
	WHERE
		[E].[ClinicID] = @ClinicID
	AND
		[D].[AssignedTo] = @UserID
	AND
		[D].[IsActive] = 1	
	AND
		[E].[IsActive] = 1
	AND
		[C].[IsActive] = 1	
	AND
		[B].[IsActive] = 1;
	
	SELECT
		CAST(1 AS TINYINT) AS [ID]
		, COUNT ([A].[EDIFileID]) AS [CLAIM_COUNT]
	FROM
		[EDI].[EDIFile] A WITH (NOLOCK)
	INNER JOIN
		@TBL_EID G
	ON
		[G].[EDI_FILE_ID] = [A].EDIFileID
	WHERE
		[A].[IsActive] = 1;
		
	-- EXEC [EDI].[usp_GetCount835_EDIFile] @ClinicID=1, @StatusIDs = '23,24', @UserID=13
	-- EXEC [EDI].[usp_GetCount835_EDIFile] @ClinicID = 20, @StatusIDs = '23,24', @UserID = 13
END










GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837Visit_ClaimProcess]    Script Date: 07/31/2013 17:31:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetAnsi837Visit_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetAnsi837Visit_ClaimProcess]
GO



/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837Visit_ClaimProcess]    Script Date: 07/31/2013 17:31:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [Claim].[usp_GetAnsi837Visit_ClaimProcess]
	@ClinicID INT
	, @EDIReceiverID INT
	, @StatusIDs NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		, [Patient].[PatientVisit].[PatientID]
		, [Patient].[PatientVisit].[PatientHospitalizationID]
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[IllnessIndicatorID]
		, [Patient].[PatientVisit].[IllnessIndicatorDate]
		, [Patient].[PatientVisit].[FacilityTypeID]
		, [Billing].[FacilityType].[FacilityTypeCode]
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
		, [Patient].[PatientVisit].[IsActive]
		, [Patient].[PatientVisit].[LastModifiedBy]
		, [Patient].[PatientVisit].[LastModifiedOn]
		--
		, [Patient].[Patient].[GroupNumber]
		, [Patient].[Patient].[LastName] AS [PATIENT_LAST_NAME]
		, [Patient].[Patient].[MiddleName] AS [PATIENT_MIDDLE_NAME]
		, [Patient].[Patient].[FirstName] AS [PATIENT_FIRST_NAME]
		, [Patient].[Patient].[StreetName] AS [PATIENT_STREET_NAME]
		, [Patient].[Patient].[Suite] AS [PATIENT_SUITE]
		, [Patient].[Patient].[DOB]
		, [Patient].[Patient].[Sex]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[Patient].[PolicyNumber]
		, [Patient].[Patient].[CityID] AS [PATIENT_CITY_ID]
		, [PATIENT_CITY].[CityName] AS [PATIENT_CITY_NAME]
		, [PATIENT_CITY].[ZipCode] AS [PATIENT_CITY_ZIP_CODE]
		, [Patient].[Patient].[StateID] AS [PATIENT_STATE_ID]
		, [PATIENT_STATE].[StateCode] AS [PATIENT_STATE_CODE]
		, [Patient].[Patient].[CountryID] AS [PATIENT_COUNTRY_ID]
		, [PATIENT_COUNTRY].[CountryCode] AS [PATIENT_COUNTRY_CODE]
		, [Patient].[Patient].[MedicareID]
		--
		, [EDI].[PrintPin].[PrintPinCode]
		--
		, [Billing].[Provider].[LastName] AS [PROVIDER_LAST_NAME]
		, [Billing].[Provider].[MiddleName] AS [PROVIDER_MIDDLE_NAME]
		, [Billing].[Provider].[FirstName] AS [PROVIDER_FIRST_NAME]
		, ((LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], ''))))) AS [PROVIDER_NAME]
		, (CASE WHEN 
				[Billing].[Provider].[IsTaxIDPrimaryOption] = 1 THEN 
				(ISNULL([Billing].[Provider].[TaxID], (ISNULL([Billing].[Provider].[NPI], 'NO_TAX_NPI')))) ELSE 
				(ISNULL([Billing].[Provider].[NPI], (ISNULL([Billing].[Provider].[TaxID], 'NO_NPI_TAX')))) END) 
			AS [PROVIDER_TAX_NPI]
		--
		, [Billing].[Credential].[CredentialCode] AS [PROVIDER_CREDENTIAL_CODE]
		--
		, [Billing].[Specialty].[SpecialtyCode]		
		--
		, [Insurance].[Insurance].[InsuranceName]
		, [Insurance].[Insurance].[PayerID]
		, [Insurance].[Insurance].[CityID] AS [INSURANCE_CITY_ID]
		, [INSURANCE_CITY].[CityName] AS [INSURANCE_CITY_NAME]
		, [INSURANCE_CITY].[ZipCode] AS [INSURANCE_CITY_ZIP_CODE]
		, [Insurance].[Insurance].[StateID] AS [INSURANCE_STATE_ID]
		, [INSURANCE_STATE].[StateCode] AS [INSURANCE_STATE_CODE]
		, [Insurance].[Insurance].[CountryID] AS [INSURANCE_COUNTRY_ID]
		, [INSURANCE_COUNTRY].[CountryCode] AS [INSURANCE_COUNTRY_CODE]
		, [Insurance].[Insurance].[PatientPrintSignID]
		, [Insurance].[Insurance].[StreetName] AS [INSURANCE_STREET_NAME]
		, [Insurance].[Insurance].[Suite] AS [INSURANCE_SUITE]
		--
		, [Insurance].[Relationship].[RelationshipCode]
		--
		, [Insurance].[InsuranceType].[InsuranceTypeCode]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		[Diagnosis].[IllnessIndicator] WITH (NOLOCK)
	ON
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorID] = [Patient].[PatientVisit].[IllnessIndicatorID]
	INNER JOIN
		[Billing].[FacilityType] WITH (NOLOCK)
	ON
		[Billing].[FacilityType].[FacilityTypeID] = [Patient].[PatientVisit].[FacilityTypeID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[Insurance].[Insurance] WITH (NOLOCK)
	ON
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	INNER JOIN
		[Insurance].[Relationship] WITH (NOLOCK)
	ON
		[Insurance].[Relationship].[RelationshipID] = [Patient].[Patient].[RelationshipID]
	INNER JOIN
		[Billing].[Credential] WITH (NOLOCK)
	ON
		[Billing].[Credential].[CredentialID] = [Billing].[Provider].[CredentialID]
	INNER JOIN
		[Billing].[Specialty] WITH (NOLOCK)
	ON
		[Billing].[Specialty].[SpecialtyID] = [Billing].[Provider].[SpecialtyID]
	INNER JOIN
		[Insurance].[InsuranceType] WITH (NOLOCK)
	ON
		[Insurance].[InsuranceType].[InsuranceTypeID] = [Insurance].[Insurance].[InsuranceTypeID]
	INNER JOIN
		[EDI].[PrintPin] WITH (NOLOCK)
	ON
		[EDI].[PrintPin].[PrintPinID] = [Insurance].[Insurance].[PrintPinID]
	INNER JOIN
		[MasterData].[City] PATIENT_CITY WITH (NOLOCK)
	ON
		[PATIENT_CITY].[CityID] = [Patient].[Patient].[CityID]
	INNER JOIN
		[MasterData].[State] PATIENT_STATE WITH (NOLOCK)
	ON
		[PATIENT_STATE].[StateID] = [Patient].[Patient].[StateID]
	INNER JOIN
		[MasterData].[Country] PATIENT_COUNTRY WITH (NOLOCK)
	ON
		[PATIENT_COUNTRY].[CountryID] = [Patient].[Patient].[CountryID]
	INNER JOIN
		[MasterData].[City] INSURANCE_CITY WITH (NOLOCK)
	ON
		[INSURANCE_CITY].[CityID] = [Insurance].[Insurance].[CityID]
	INNER JOIN
		[MasterData].[State] INSURANCE_STATE WITH (NOLOCK)
	ON
		[INSURANCE_STATE].[StateID] = [Insurance].[Insurance].[StateID]
	INNER JOIN
		[MasterData].[Country] INSURANCE_COUNTRY WITH (NOLOCK)
	ON
		[INSURANCE_COUNTRY].[CountryID] = [Insurance].[Insurance].[CountryID]
	WHERE
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Insurance].[Insurance].[EDIReceiverID] = @EDIReceiverID
	AND
		[Patient].[PatientVisit].[ClaimStatusID] IN
		(
			SELECT 
				[Data] 
			FROM 
				[dbo].[ufn_StringSplit] (@StatusIDs, ',')
		)
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Diagnosis].[IllnessIndicator].[IsActive] = 1
	AND
		[Billing].[FacilityType].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1
	AND
		[Insurance].[Relationship].[IsActive] = 1
	AND
		[Billing].[Credential].[IsActive] = 1
	AND
		[Billing].[Specialty].[IsActive] = 1
	AND
		[Insurance].[InsuranceType].[IsActive] = 1
	AND
		[EDI].[PrintPin].[IsActive] = 1
	AND
		[PATIENT_CITY].[IsActive] = 1
	AND
		[PATIENT_STATE].[IsActive] = 1
	AND
		[PATIENT_COUNTRY].[IsActive] = 1
	AND
		[INSURANCE_CITY].[IsActive] = 1
	AND
		[INSURANCE_STATE].[IsActive] = 1
	AND
		[INSURANCE_COUNTRY].[IsActive] = 1
	ORDER BY
		[Insurance].[Insurance].[InsuranceName]
	ASC,
		[PROVIDER_NAME]
	ASC,
		[Patient].[PatientVisit].[PatientVisitID]
	ASC;
    
    -- EXEC [Claim].[usp_GetAnsi837Visit_ClaimProcess] @ClinicID = 1, @EDIReceiverID = 1, @StatusIDs = '16, 17, 18, 19, 20'
END









GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseVisit_PatientVisit]    Script Date: 07/31/2013 18:05:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAgentWiseVisit_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAgentWiseVisit_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseVisit_PatientVisit]    Script Date: 07/31/2013 18:05:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetAgentWiseVisit_PatientVisit]
	@UserID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
	, @NEW_CLAIM TINYINT
	, @BA_HOLDED TINYINT
	, @CREATED_CLAIM TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @REJECTED_CLAIM TINYINT
	, @REJECTED_CLAIM_NIT TINYINT
	, @ACCEPTED_CLAIM TINYINT
	, @NIT_StatusIDs NVARCHAR(150)
	, @SearchName NVARCHAR(150) = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DECLARE @StatusIDs NVARCHAR(150);
	DECLARE @FromDiff INT;
	DECLARE @ToDiff INT;
	DECLARE @StatusID INT;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	IF @Desc = 'Visits'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT [User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;	
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;	
		END
	END

	ELSE IF @Desc = 'Created'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Hold'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Ready To Send'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Sent'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Accepted'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
				FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Rejected'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Re-Submitted'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] WITH (NOLOCK) 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] WITH (NOLOCK) 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PK_ID]
					, [ROW_NUM]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, ROW_NUMBER() OVER (
					ORDER BY
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Blocked' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PK_ID]
				, [ROW_NUM]
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
			, ROW_NUMBER() OVER (
				ORDER BY
				
					CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
					CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
								
					CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
					CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
									
					CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
					CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
					
				) AS ROW_NUM
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[Patient].[ClinicID] IN 
			(
				SELECT 
					[User].[UserClinic].[ClinicID] 
				FROM 
					[User].[UserClinic]  WITH (NOLOCK)
				INNER JOIN
					[Billing].[Clinic]  WITH (NOLOCK)
				ON
					[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
				WHERE 
					[User].[UserClinic].[UserID] = @UserID 
				AND 
					[User].[UserClinic].[IsActive] = 1 
				AND 
					[Billing].[Clinic].[IsActive] = 1
			)
		AND
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID OR [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
		(
			[Patient].[PatientVisit].[IsActive] = 0
		OR
			[Patient].[Patient].[IsActive] = 0
		);
	END
	
	ELSE IF @Desc = 'NIT' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PK_ID]
				, [ROW_NUM]
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
			, ROW_NUMBER() OVER (
				ORDER BY
				
					CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
					CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
								
					CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
					CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
									
					CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
					CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
					
				) AS ROW_NUM
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
		AND
			[Patient].[Patient].[ClinicID] IN 
			(
				SELECT 
					[User].[UserClinic].[ClinicID] 
				FROM 
					[User].[UserClinic]  WITH (NOLOCK)
				INNER JOIN
					[Billing].[Clinic]  WITH (NOLOCK)
				ON
					[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
				WHERE 
					[User].[UserClinic].[UserID] = @UserID 
				AND 
					[User].[UserClinic].[IsActive] = 1 
				AND 
					[Billing].[Clinic].[IsActive] = 1
			)
		AND
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
END
	
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[ID] AS [Sl_No]
		, [Patient].[PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
	FROM
		@SEARCH_TMP
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON 
		[PK_ID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	
	-- EXEC [Patient].[-]  @UserID=116 , @Desc = 'Visits', @DayCount = 'THIRTYPLUS'
	-- EXEC [Patient].[usp_GetAgentWiseVisit_PatientVisit]  @UserID=116 , @Desc = 'Visits', @DayCount = 'ONE'
	-- EXEC [Patient].[usp_GetAgentWiseVisit_PatientVisit]  @UserID=116 , @Desc = 'Rejected', @DayCount = 'TOTAL'
	-- EXEC [Patient].[usp_GetAgentWiseVisit_PatientVisit]  @UserID = '116', @Desc = 'Visits', @DayCount = 'THIRTYPLUS', @SearchName  = 'a'
END










GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportSumAgent_PatientVisit]    Script Date: 08/01/2013 09:04:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumAgent_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumAgent_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportSumAgent_PatientVisit]    Script Date: 08/01/2013 09:04:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Patient].[usp_GetReportSumAgent_PatientVisit]
	@UserID INT
	 , @DateFrom DATE
     , @DateTo DATE     
AS
BEGIN	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_CLINIC TABLE
	(
		[CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@TBL_CLINIC
	SELECT 
		[B].[ClinicID] 
	FROM 
		[User].[UserClinic] B  WITH (NOLOCK)
	INNER JOIN
		[Billing].[Clinic] C WITH (NOLOCK)
	ON
		[B].[ClinicID] = [C].[ClinicID]
	WHERE 
		[B].[UserID] = @UserID
	AND 
		[B].[IsActive] = 1 
	AND 
		[C].[IsActive] = 1;
		
	DECLARE @TBL_VISIT TABLE
	(
		[VISIT_ID] BIGINT NOT NULL
	);
	
	INSERT INTO
		@TBL_VISIT
	SELECT
		[A].[PatientVisitID]
	FROM
		[Patient].[PatientVisit] A WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] B WITH (NOLOCK)
	ON 
		[B].[PatientID] = [A].[PatientID]
	INNER JOIN
		@TBL_CLINIC C
	ON 
		[C].[CLINIC_ID] = [B].[ClinicID]
	WHERE
		[A].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		[A].[IsActive] = 1
	AND
		[B].[IsActive] = 1;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [X_AXIS_NAME] NVARCHAR(400) NOT NULL
		, [CLAIMS] BIGINT NOT NULL
	);
	
	DECLARE CUR_X CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
		SELECT DISTINCT
			[A].[UserID]
		FROM
			[User].[UserClinic] A  WITH (NOLOCK)
		INNER JOIN
			@TBL_CLINIC B
		ON
			[B].[CLINIC_ID] = [A].[ClinicID]
		WHERE
			[A].[IsActive] = 1;
	
	OPEN CUR_X;
	
	DECLARE @USER_ID INT;
	
	FETCH NEXT FROM CUR_X INTO @USER_ID;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @X_AXIS_NAME NVARCHAR(400);
		DECLARE @CLAIMS BIGINT;
		
		SELECT
			@X_AXIS_NAME = LTRIM(RTRIM([A].[LastName] + ' ' + [A].[FirstName] + ' ' + ISNULL([A].[MiddleName], '')))
		FROM
			[User].[User] A WITH (NOLOCK)
		WHERE
			[A].[UserID] = @USER_ID;
			
		SELECT
			@CLAIMS = COUNT_BIG(DISTINCT [A].[PatientVisitID] )
		FROM 
			[Claim].[ClaimProcess] A WITH (NOLOCK)
		INNER JOIN
			@TBL_VISIT B
		ON
			[B].[VISIT_ID] = [A].[PatientVisitID]
		WHERE
			[A].[CreatedBy] = @USER_ID
		AND
			[A].[IsActive] = 1;
			
		INSERT INTO
			@TBL_ANS
		SELECT
			@X_AXIS_NAME
			, @CLAIMS;
			
		FETCH NEXT FROM CUR_X INTO @USER_ID;;
	  END
	
	CLOSE CUR_X;
	DEALLOCATE CUR_X;	
	
	SELECT * FROM @TBL_ANS WHERE [CLAIMS] > 0 ORDER BY 2 ASC;	
END
	
-- EXEC [Patient].[usp_GetReportSumAgent_PatientVisit] 1,'2011-JAN-01','2011-JAN-15'

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportSumAgentComp_PatientVisit]    Script Date: 08/01/2013 17:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportSumAgentComp_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportSumAgentComp_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportSumAgentComp_PatientVisit]    Script Date: 08/01/2013 17:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetReportSumAgentComp_PatientVisit]
	@UserID INT
	 , @DateFrom DATE
     , @DateTo DATE     
AS
BEGIN	 
	SET NOCOUNT ON;
	
	DECLARE @TBL_CLINIC TABLE
	(
		[CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@TBL_CLINIC
	SELECT 
		[B].[ClinicID] 
	FROM 
		[User].[UserClinic] B  WITH (NOLOCK)
	INNER JOIN
		[Billing].[Clinic] C WITH (NOLOCK)
	ON
		[B].[ClinicID] = [C].[ClinicID]
	WHERE 
		[B].[UserID] = @UserID
	AND 
		[B].[IsActive] = 1 
	AND 
		[C].[IsActive] = 1;
		
	DECLARE @TBL_VISIT TABLE
	(
		[VISIT_ID] BIGINT NOT NULL
	);
	
	INSERT INTO
		@TBL_VISIT
	SELECT
		[A].[PatientVisitID]
	FROM
		[Patient].[PatientVisit] A WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] B WITH (NOLOCK)
	ON 
		[B].[PatientID] = [A].[PatientID]
	INNER JOIN
		@TBL_CLINIC C
	ON 
		[C].[CLINIC_ID] = [B].[ClinicID]
	WHERE
		[A].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		[A].[IsActive] = 1
	AND
		[B].[IsActive] = 1;
	
	DECLARE @TBL_ALL TABLE 
	(
		[USER_ID] INT NOT NULL
		, [X_AXIS_NAME] NVARCHAR(400) NOT NULL
		, [CLAIMS] BIGINT NOT NULL
	);
	
	DECLARE CUR_X CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
		SELECT DISTINCT
			[A].[UserID]
		FROM
			[User].[UserClinic] A  WITH (NOLOCK)
		INNER JOIN
			@TBL_CLINIC B
		ON
			[B].[CLINIC_ID] = [A].[ClinicID]
		WHERE
			[A].[IsActive] = 1;
	
	OPEN CUR_X;
	
	DECLARE @USER_ID INT;
	
	FETCH NEXT FROM CUR_X INTO @USER_ID;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @X_AXIS_NAME NVARCHAR(400);
		DECLARE @CLAIMS BIGINT;
		
		SELECT
			@X_AXIS_NAME = LTRIM(RTRIM([A].[LastName] + ' ' + [A].[FirstName] + ' ' + ISNULL([A].[MiddleName], '')))
		FROM
			[User].[User] A WITH (NOLOCK)
		WHERE
			[A].[UserID] = @USER_ID;
			
		SELECT
			@CLAIMS = COUNT_BIG(DISTINCT [A].[PatientVisitID])
		FROM 
			[Claim].[ClaimProcess] A WITH (NOLOCK)
		INNER JOIN
			@TBL_VISIT B
		ON
			[B].[VISIT_ID] = [A].[PatientVisitID]
		WHERE
			[A].[CreatedBy] = @USER_ID
		AND
			[A].[IsActive] = 1;
			
		INSERT INTO
			@TBL_ALL
		SELECT
			@USER_ID
			, @X_AXIS_NAME
			, @CLAIMS;
			
		FETCH NEXT FROM CUR_X INTO @USER_ID;;
	  END
	
	CLOSE CUR_X;
	DEALLOCATE CUR_X;
	
	DELETE FROM @TBL_ALL WHERE [CLAIMS] = 0;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY(1, 1) NOT NULL
		, [USER_ID] INT NOT NULL
		, [X_AXIS_NAME] NVARCHAR(400) NOT NULL
		, [CLAIMS] BIGINT NOT NULL
	);
	
	INSERT INTO
		@TBL_ANS
	SELECT TOP 5 * FROM @TBL_ALL ORDER BY [CLAIMS] DESC, [X_AXIS_NAME] ASC, [USER_ID] ASC;
	
	INSERT INTO
		@TBL_ANS
	SELECT TOP 5 [A].* FROM @TBL_ALL A WHERE [A].[USER_ID] NOT IN (SELECT [B].[USER_ID] FROM @TBL_ANS B) ORDER BY [A].[CLAIMS] ASC, [A].[X_AXIS_NAME] ASC, [A].[USER_ID] ASC;
	
	DECLARE @TBL_ANS_RECS INT;
	SELECT @TBL_ANS_RECS = COUNT([ID]) FROM @TBL_ANS;
	WHILE @TBL_ANS_RECS < 10
	BEGIN
		INSERT INTO
			@TBL_ANS
		VALUES
			(
				0
				, 'DUMMY'
				, 0
			);
	
		SELECT @TBL_ANS_RECS = COUNT([ID]) FROM @TBL_ANS;
	END

	SELECT * FROM @TBL_ANS ORDER BY [ID] ASC;
END
	
-- EXEC [Patient].[usp_GetReportSumAgentComp_PatientVisit] 114,'2011-JAN-01','2011-JAN-15'

-- EXEC [Patient].[usp_GetReportSumAgentComp_PatientVisit] 114,'2011-AUG-01','2011-AUG-02'

-- EXEC [Patient].[usp_GetReportSumAgentComp_PatientVisit] 114,'2013-AUG-01','2013-AUG-02'

GO



------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [AccessPrivilege].[usp_GetBySearch_Role]    Script Date: 08/01/2013 16:43:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AccessPrivilege].[usp_GetBySearch_Role]') AND type in (N'P', N'PC'))
DROP PROCEDURE [AccessPrivilege].[usp_GetBySearch_Role]
GO


/****** Object:  StoredProcedure [AccessPrivilege].[usp_GetBySearch_Role]    Script Date: 08/01/2013 16:43:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [AccessPrivilege].[usp_GetBySearch_Role]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[AccessPrivilege].[Role].*
	FROM
		[AccessPrivilege].[Role]
	ORDER BY
		[AccessPrivilege].[Role].[RoleID]
	ASC;
	
	
	-- EXEC [AccessPrivilege].[usp_GetBySearch_Role]
END








GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [AccessPrivilege].[usp_GetAgent_Role]    Script Date: 08/01/2013 17:49:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AccessPrivilege].[usp_GetAgent_Role]') AND type in (N'P', N'PC'))
DROP PROCEDURE [AccessPrivilege].[usp_GetAgent_Role]
GO


/****** Object:  StoredProcedure [AccessPrivilege].[usp_GetAgent_Role]    Script Date: 08/01/2013 17:49:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Select the particular record
--Created by sai for user and role
CREATE PROCEDURE [AccessPrivilege].[usp_GetAgent_Role] 
	@WebAdminRoleID TINYINT
	, @ManagerRoleID TINYINT
	,@UserID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[AccessPrivilege].[Role].[RoleName]
		,[AccessPrivilege].[Role].[RoleID]
		,(SELECT [User].[UserRole].[IsActive] from [User].[UserRole] where [User].[UserRole].[UserID] = @UserID
		and [User].[UserRole].[RoleID] = [AccessPrivilege].[Role].[RoleID]) as IsActive
		,(SELECT [User].[UserRole].[UserRoleID] from [User].[UserRole] where [User].[UserRole].[UserID] = @UserID
		and [User].[UserRole].[RoleID] = [AccessPrivilege].[Role].[RoleID]) as AgentUserRoleID
	FROM
		[AccessPrivilege].[Role] WITH (NOLOCK)
	WHERE
		[AccessPrivilege].[Role].[RoleID] NOT IN (@WebAdminRoleID, @ManagerRoleID)
	ORDER BY
		[AccessPrivilege].[Role].[RoleID]
	ASC;

	-- EXEC [AccessPrivilege].[usp_GetAgent_Role] @WebAdminRoleID = 1, @ManagerRoleID = 2,@UserID = 1
	
END

GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [User].[usp_GetNotificationRolePdf_UserRole]    Script Date: 08/01/2013 19:47:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationRolePdf_UserRole]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationRolePdf_UserRole]
GO


/****** Object:  StoredProcedure [User].[usp_GetNotificationRolePdf_UserRole]    Script Date: 08/01/2013 19:47:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [User].[usp_GetNotificationRolePdf_UserRole]

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[User].[User].[Email]
		, [User].[User].[LastName]
		, [User].[User].[FirstName]
		, [User].[User].[MiddleName]
	FROM
		[User].[User]  WITH (NOLOCK)
	INNER JOIN
		[User].[UserRole]  WITH (NOLOCK)
	ON 
		[User].[User].[UserID] = [User].[UserRole].[UserID]
	WHERE
		[User].[UserRole].[RoleID] NOT IN (SELECT [AccessPrivilege].[Role].[RoleID] FROM [AccessPrivilege].[Role] WHERE [AccessPrivilege].[Role].[IsActive] = 1)
	AND
		[User].[UserRole].[IsActive] = 1
	AND
		[User].[User].[IsActive] = 1;
		
	-- EXEC [User].[usp_GetNotificationRolePdf_UserRole]
END

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNotificationClinicPdf_UserClinic]    Script Date: 08/01/2013 19:48:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationClinicPdf_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationClinicPdf_UserClinic]
GO


/****** Object:  StoredProcedure [User].[usp_GetNotificationClinicPdf_UserClinic]    Script Date: 08/01/2013 19:48:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User].[usp_GetNotificationClinicPdf_UserClinic]

AS
BEGIN
	SET NOCOUNT ON;
	
		SELECT
			 [User].[User].[Email]
			, [User].[User].[LastName]
			, [User].[User].[FirstName]
			, [User].[User].[MiddleName]
		FROM
			[User].[User] WITH (NOLOCK)
		WHERE
			[User].[User].[UserID] NOT IN (SELECT  [User].[UserClinic].[UserID] FROM [User].[UserClinic] WITH (NOLOCK) WHERE [User].[UserClinic].[IsActive] = 1)
		AND 
			[User].[User].[IsActive] = 1;
		
	-- EXEC [User].[usp_GetNotificationClinicPdf_UserClinic] 
END

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNotificationAgentPdf_User]    Script Date: 08/01/2013 19:50:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationAgentPdf_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationAgentPdf_User]
GO



/****** Object:  StoredProcedure [User].[usp_GetNotificationAgentPdf_User]    Script Date: 08/01/2013 19:50:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User].[usp_GetNotificationAgentPdf_User] 
	@RoleID TINYINT

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[User].[User].[Email]
		, [User].[User].[LastName]
		, [User].[User].[FirstName]
		, [User].[User].[MiddleName]
	FROM
 		[User].[User]  WITH (NOLOCK)
 	WHERE
 		[User].[User].[UserID] IN 
 	(
		SELECT 
			[UserID] FROM [User].[UserRole] WHERE [User].[UserRole].[RoleID] = @RoleID  AND [User].[UserRole].[IsActive] = 1
		AND 
			[UserID] NOT IN
			(
				SELECT DISTINCT [User].[User].[ManagerID] FROM [User].[User] WHERE [User].[User].[ManagerID] IS NOT NULL
			UNION	
				SELECT [UserID] FROM [User].[UserRole] WHERE [User].[UserRole].[RoleID] < @RoleID  AND [User].[UserRole].[IsActive] = 1
			)
	)
	AND
		[User].[User].[IsActive] = 1;
			
	-- EXEC [User].[usp_GetNotificationAgentPdf_User] 2
END

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNotificationAgentClinicPdf_UserClinic]    Script Date: 08/01/2013 19:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationAgentClinicPdf_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationAgentClinicPdf_UserClinic]
GO



/****** Object:  StoredProcedure [User].[usp_GetNotificationAgentClinicPdf_UserClinic]    Script Date: 08/01/2013 19:51:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [User].[usp_GetNotificationAgentClinicPdf_UserClinic]
	@UserID INT

AS
BEGIN
	SET NOCOUNT ON;
		
		SELECT
			[Billing].[Clinic].[ClinicName]
			, [Billing].[Clinic].[NPI]
			, [Billing].[Clinic].[ICDFormat]
		FROM 
			[User].[UserClinic]  WITH (NOLOCK)
		INNER JOIN
			[Billing].[Clinic]  WITH (NOLOCK)
		ON
			[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
		WHERE 
			[User].[UserClinic].[UserID] = @UserID 
		AND 
			[User].[UserClinic].[IsActive] = 1 
		AND 
			[Billing].[Clinic].[IsActive] = 1;
		
	-- EXEC [User].[usp_GetNotificationAgentClinicPdf_UserClinic] 116
END

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNotificationManagerPdf_UserClinic]    Script Date: 08/01/2013 19:54:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationManagerPdf_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationManagerPdf_UserClinic]
GO



/****** Object:  StoredProcedure [User].[usp_GetNotificationManagerPdf_UserClinic]    Script Date: 08/01/2013 19:54:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User].[usp_GetNotificationManagerPdf_UserClinic] 
	@ManagerRoleID TINYINT

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @MNGR_TMP TABLE
	(
		[USER_ID] INT NOT NULL
	);
	
	INSERT INTO
		@MNGR_TMP
	SELECT 
		[User].[UserRole].[UserID]
	FROM 
		[User].[UserRole]
	WHERE
		[User].[UserRole].[RoleID] = @ManagerRoleID
	AND
		[User].[UserRole].[IsActive] = 1;
	
	DELETE FROM
		@MNGR_TMP
	WHERE
		[USER_ID] IN
		(
			SELECT 
				[User].[UserRole].[UserID]
			FROM 
				[User].[UserRole]
			WHERE
				[User].[UserRole].[RoleID] < @ManagerRoleID
			AND
				[User].[UserRole].[IsActive] = 1
		)
	OR
		[USER_ID] IN
		(
			SELECT 
				[User].[User].[UserID]
			FROM 
				[User].[User]
			WHERE
				[User].[User].[ManagerID] IS NOT NULL
			AND
				[User].[User].[IsActive] = 1
		);
	
	DECLARE @CLNC_TMP TABLE
	(
		[CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@CLNC_TMP
	SELECT DISTINCT
		[A].[ClinicID]
	FROM
		[User].[UserClinic] A WITH (NOLOCK)
	INNER JOIN
		@MNGR_TMP B
	ON
		[B].[USER_ID] = [A].[UserID]
	WHERE
		[A].[IsActive] = 1;
	
	DECLARE @CLNC_NO_TMP TABLE
	(
		[CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@CLNC_NO_TMP
	SELECT
		[A].[ClinicID]
	FROM
		[Billing].[Clinic] A WITH (NOLOCK)
	WHERE
		[A].[ClinicID] NOT IN
		(
			SELECT 
				[B].[CLINIC_ID]
			FROM
				@CLNC_TMP B
		)
	AND
		[A].[IsActive] = 1;
		
	SELECT
		DISTINCT [Billing].[Clinic].[ClinicName]
		, [Billing].[Clinic].[NPI]
		, [Billing].[Clinic].[ICDFormat]
	FROM 
 		[Billing].[Clinic] WITH (NOLOCK)
 	INNER JOIN
 		@CLNC_NO_TMP B
 	ON
 		[B].[CLINIC_ID] = [Billing].[Clinic].[ClinicID]
	AND
		[Billing].[Clinic].[IsActive] = 1;
		
	-- EXEC [User].[usp_GetNotificationManagerPdf_UserClinic] 2
END

GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetSetStatus1EOB_ClaimProcess]    Script Date: 08/02/2013 09:38:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetSetStatus1EOB_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetSetStatus1EOB_ClaimProcess]
GO


/****** Object:  StoredProcedure [Claim].[usp_GetSetStatus1EOB_ClaimProcess]    Script Date: 08/02/2013 09:38:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE PROCEDURE [Claim].[usp_GetSetStatus1EOB_ClaimProcess]
	
AS
BEGIN
		SET NOCOUNT ON;
		
		DECLARE @CLAIM_DONE TINYINT;
		
		DECLARE @PATIENT_VISIT_ID BIGINT;
		DECLARE @DOS DATE;
		
		SELECT @CLAIM_DONE = [Configuration].[General].[ClaimDoneFromDOSInDay] FROM [Configuration].[General];
		
		DECLARE CUR_DIAG CURSOR LOCAL FAST_FORWARD READ_ONLY FOR 
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID], [Patient].[PatientVisit].[DOS]
			FROM
				[Patient].[PatientVisit]
			WHERE 
				[Patient].[PatientVisit].[ClaimStatusID] NOT IN (30, 29, 27, 24, 20, 18, 14, 12, 8, 5, 3)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) >= @CLAIM_DONE
			ORDER BY
				[Patient].[PatientVisit].[DOS]
			ASC;
		
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		DECLARE @CurrentModificationBy BIGINT
		SELECT @CurrentModificationBy = 1;
		
		
		OPEN CUR_DIAG;
		
		FETCH NEXT FROM CUR_DIAG INTO @PATIENT_VISIT_ID, @DOS;
		
		WHILE @@FETCH_STATUS = 0
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
			 ,[Comment] = 'Sys Gen : Status changed by automated job services on ' + CONVERT(NVARCHAR, GETDATE(), 13) + '. Reason : Claim not completed within ' + CAST(@CLAIM_DONE AS NVARCHAR(3)) + ' days.'
			 ,[LastModifiedBy] = @CurrentModificationBy
			 ,[LastModifiedOn] = @CurrentModificationOn			      
		WHERE [Patient].[PatientVisit].[PatientVisitid] = @PATIENT_VISIT_ID;
		 
		--UPDATE CLAIM STATUS IN PATIENT VISIT END		
		FETCH NEXT FROM CUR_DIAG INTO @PATIENT_VISIT_ID, @DOS;		
	END
	
	CLOSE CUR_DIAG;
	DEALLOCATE CUR_DIAG;
	
	-- EXEC [Claim].[usp_GetSetStatus1EOB_ClaimProcess] 
END









GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetSetStatus2EDI_ClaimProcess]    Script Date: 08/02/2013 09:38:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetSetStatus2EDI_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetSetStatus2EDI_ClaimProcess]
GO



/****** Object:  StoredProcedure [Claim].[usp_GetSetStatus2EDI_ClaimProcess]    Script Date: 08/02/2013 09:38:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Claim].[usp_GetSetStatus2EDI_ClaimProcess]
	
AS
BEGIN
		SET NOCOUNT ON;
		
		DECLARE @EDI_FILE_SENT TINYINT;
		
		DECLARE @PATIENT_VISIT_ID BIGINT;
		DECLARE @DOS DATE;
		
		SELECT @EDI_FILE_SENT = [Configuration].[General].[EDIFileSentFromDOSInDay] FROM [Configuration].[General];
		
		DECLARE CUR_DIAG CURSOR LOCAL FAST_FORWARD READ_ONLY FOR 
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID], [Patient].[PatientVisit].[DOS]
			FROM
				[Patient].[PatientVisit]
			WHERE 
				[Patient].[PatientVisit].[ClaimStatusID] NOT IN (30, 29, 28, 27, 26, 25, 24, 23, 22, 20, 18, 14, 12, 8, 5, 3)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) >= @EDI_FILE_SENT
			ORDER BY
				[Patient].[PatientVisit].[DOS]
			ASC;
		
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		DECLARE @CurrentModificationBy BIGINT
		SELECT @CurrentModificationBy = 1;
		
		
		OPEN CUR_DIAG;
		
		FETCH NEXT FROM CUR_DIAG INTO @PATIENT_VISIT_ID, @DOS;
		
		WHILE @@FETCH_STATUS = 0
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
			 ,[Comment] = 'Sys Gen : Status changed by automated job services on ' + CONVERT(NVARCHAR, GETDATE(), 13) + '. Reason : Claim not sent within ' + CAST(@EDI_FILE_SENT AS NVARCHAR(3)) + ' days.'
			 ,[LastModifiedBy] = @CurrentModificationBy
			 ,[LastModifiedOn] = @CurrentModificationOn			      
		WHERE [Patient].[PatientVisit].[PatientVisitid] = @PATIENT_VISIT_ID;
		 
		--UPDATE CLAIM STATUS IN PATIENT VISIT END		
		FETCH NEXT FROM CUR_DIAG INTO @PATIENT_VISIT_ID, @DOS;		
	END
	
	CLOSE CUR_DIAG;
	DEALLOCATE CUR_DIAG;
	
	-- EXEC [Claim].[usp_GetSetStatus2EDI_ClaimProcess] 
END









GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetSetStatus3QA_ClaimProcess]    Script Date: 08/02/2013 09:39:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetSetStatus3QA_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetSetStatus3QA_ClaimProcess]
GO


/****** Object:  StoredProcedure [Claim].[usp_GetSetStatus3QA_ClaimProcess]    Script Date: 08/02/2013 09:39:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Claim].[usp_GetSetStatus3QA_ClaimProcess]
	
AS
BEGIN
		SET NOCOUNT ON;
		
		DECLARE @QA_COMPLETE TINYINT;
		
		DECLARE @PATIENT_VISIT_ID BIGINT;
		DECLARE @DOS DATE;
		
		SELECT @QA_COMPLETE = [Configuration].[General].[QACompleteFromDOSInDay] FROM [Configuration].[General];
		
		DECLARE CUR_DIAG CURSOR LOCAL FAST_FORWARD READ_ONLY FOR 
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID], [Patient].[PatientVisit].[DOS]
			FROM
				[Patient].[PatientVisit]
			WHERE 
				[Patient].[PatientVisit].[ClaimStatusID] NOT IN (30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 14, 12, 8, 5, 3)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) >= @QA_COMPLETE
			ORDER BY
				[Patient].[PatientVisit].[DOS]
			ASC;
		
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		DECLARE @CurrentModificationBy BIGINT
		SELECT @CurrentModificationBy = 1;
		
		
		OPEN CUR_DIAG;
		
		FETCH NEXT FROM CUR_DIAG INTO @PATIENT_VISIT_ID, @DOS;
		
		WHILE @@FETCH_STATUS = 0
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
			 ,[Comment] = 'Sys Gen : Status changed by automated job services on ' + CONVERT(NVARCHAR, GETDATE(), 13) + '. Reason : Claim not verified within ' + CAST(@QA_COMPLETE AS NVARCHAR(3)) + ' days.'
			 ,[LastModifiedBy] = @CurrentModificationBy
			 ,[LastModifiedOn] = @CurrentModificationOn			      
		WHERE [Patient].[PatientVisit].[PatientVisitid] = @PATIENT_VISIT_ID;
		 
		--UPDATE CLAIM STATUS IN PATIENT VISIT END		
		FETCH NEXT FROM CUR_DIAG INTO @PATIENT_VISIT_ID, @DOS;		
	END
	
	CLOSE CUR_DIAG;
	DEALLOCATE CUR_DIAG;
	
	-- EXEC [Claim].[usp_GetSetStatus3QA_ClaimProcess] 
END









GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetSetStatus4BA_ClaimProcess]    Script Date: 08/02/2013 09:39:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetSetStatus4BA_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetSetStatus4BA_ClaimProcess]
GO

/****** Object:  StoredProcedure [Claim].[usp_GetSetStatus4BA_ClaimProcess]    Script Date: 08/02/2013 09:39:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Claim].[usp_GetSetStatus4BA_ClaimProcess]
	
AS
BEGIN
		SET NOCOUNT ON;
		
		DECLARE @BA_COMPLETE TINYINT;
		
		DECLARE @PATIENT_VISIT_ID BIGINT;
		DECLARE @DOS DATE;
		
		SELECT @BA_COMPLETE = [Configuration].[General].[BACompleteFromDOSInDay] FROM [Configuration].[General];
		
		DECLARE CUR_DIAG CURSOR LOCAL FAST_FORWARD READ_ONLY FOR 
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID], [Patient].[PatientVisit].[DOS]
			FROM
				[Patient].[PatientVisit]
			WHERE 
				[Patient].[PatientVisit].[ClaimStatusID] NOT IN (30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 8, 5, 3)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) >= @BA_COMPLETE
			ORDER BY
				[Patient].[PatientVisit].[DOS]
			ASC;
		
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		DECLARE @CurrentModificationBy BIGINT
		SELECT @CurrentModificationBy = 1;
		
		
		OPEN CUR_DIAG;
		
		FETCH NEXT FROM CUR_DIAG INTO @PATIENT_VISIT_ID, @DOS;
		
		WHILE @@FETCH_STATUS = 0
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
			 ,[Comment] = 'Sys Gen : Status changed by automated job services on ' + CONVERT(NVARCHAR, GETDATE(), 13) + '. Reason : Claim not created within ' + CAST(@BA_COMPLETE AS NVARCHAR(3)) + ' days.'
			 ,[LastModifiedBy] = @CurrentModificationBy
			 ,[LastModifiedOn] = @CurrentModificationOn			      
		WHERE [Patient].[PatientVisit].[PatientVisitid] = @PATIENT_VISIT_ID;
		 
		--UPDATE CLAIM STATUS IN PATIENT VISIT END		
		FETCH NEXT FROM CUR_DIAG INTO @PATIENT_VISIT_ID, @DOS;		
	END
	
	CLOSE CUR_DIAG;
	DEALLOCATE CUR_DIAG;
	
	-- EXEC [Claim].[usp_GetSetStatus4BA_ClaimProcess] 
END









GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetCommentByID_ClaimProcess]    Script Date: 08/05/2013 12:07:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetCommentByID_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetCommentByID_ClaimProcess]
GO


/****** Object:  StoredProcedure [Claim].[usp_GetCommentByID_ClaimProcess]    Script Date: 08/05/2013 12:07:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







-- Select the particular record

CREATE PROCEDURE [Claim].[usp_GetCommentByID_ClaimProcess] 
	@PatientVisitID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[A].[USER_COMMENTS]
		, ((LTRIM(RTRIM([D].[LastName] + ' ' + [D].[FirstName] + ' ' + ISNULL([D].[MiddleName], '')))) + ' [' +[D].[UserName] + ']') AS [USER_NAME_CODE] 
	FROM
	(
		SELECT
			[C].[LastModifiedBy] AS [USER_ID] 
			, [C].[Comment] AS [USER_COMMENTS]
		FROM
			[Claim].[ClaimProcess] C WITH (NOLOCK)
		WHERE
			[C].[PatientVisitID] = 23895
		AND
			[C].[Comment] NOT LIKE 'Sys Gen : %'
		AND
			[C].[IsActive] = 1
		UNION ALL
		SELECT
			[B].[LastModifiedBy] AS [USER_ID] 
			, [B].[Comment] AS [USER_COMMENTS]
		FROM
			[Patient].[PatientVisit] B WITH (NOLOCK)
		WHERE
			[B].[PatientVisitID] = @PatientVisitID
		AND
			[B].[Comment] NOT LIKE 'Sys Gen : %'
		AND
			[B].[IsActive] = 1
	) AS A ([USER_ID], [USER_COMMENTS])
	INNER JOIN 
		[User].[User] D
	ON
		[D].[UserID] = [A].[USER_ID]
	AND
		[D].[IsActive] = 1;
	
	-- EXEC [Claim].[usp_GetCommentByID_ClaimProcess] 23895
	-- EXEC [Claim].[usp_GetCommentByID_ClaimProcess] 1, 1
	-- EXEC [Claim].[usp_GetCommentByID_ClaimProcess] 1, 0
END




GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_EDIFile]    Script Date: 08/02/2013 16:32:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetBySearch_EDIFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetBySearch_EDIFile]
GO


/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_EDIFile]    Script Date: 08/02/2013 16:32:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [EDI].[usp_GetBySearch_EDIFile]
	@ClinicID	INT
	, @SearchName NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @DOSFrom DATE = NULL
	, @DOSTo DATE = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SELECT @SearchName = '';
	END
	
	DECLARE @PatientVisitID BIGINT;
	BEGIN TRY
		SELECT @PatientVisitID = CAST (@SearchName AS BIGINT);
	END TRY
	BEGIN CATCH
		SELECT @PatientVisitID = 0;
	END CATCH
	
	IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = CAST(MIN([EDI].[EDIFile].[CreatedOn]) AS DATE) FROM [EDI].[EDIFile] WITH (NOLOCK);
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = CAST(MAX([EDI].[EDIFile].[CreatedOn]) AS DATE) FROM [EDI].[EDIFile] WITH (NOLOCK);
	END	
	IF @DOSFrom IS NULL
	BEGIN
		SELECT @DOSFrom = MIN([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit] WITH (NOLOCK);
	END
	
	IF @DOSTo IS NULL
	BEGIN
		SELECT @DOSTo = MAX([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit] WITH (NOLOCK);
	END
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT TOP (@CurrPageNumber * @RecordsPerPage)
		[EDI].[EDIFile].[EDIFileID]
		, ROW_NUMBER() OVER (
			ORDER BY			
				CASE WHEN @OrderByField = 'EDIFileID' AND @OrderByDirection = 'A' THEN [EDI].[EDIFile].[EDIFileID] END ASC,
				CASE WHEN @orderByField = 'EDIFileID' AND @orderByDirection = 'D' THEN [EDI].[EDIFile].[EDIFileID] END DESC,

				CASE WHEN @OrderByField = 'CreatedOn' AND @OrderByDirection = 'A' THEN [EDI].[EDIFile].[CreatedOn] END ASC,
				CASE WHEN @OrderByField = 'CreatedOn' AND @OrderByDirection = 'D' THEN [EDI].[EDIFile].[CreatedOn] END DESC,		

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [EDI].[EDIFile].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [EDI].[EDIFile].[LastModifiedOn] END DESC
			) AS ROW_NUM
	FROM
		[EDI].[EDIFile]	 WITH (NOLOCK)
	WHERE
		DATEDIFF(DAY, [EDI].[EDIFile].[CreatedOn], @DateFrom) <= 0 AND DATEDIFF(DAY, [EDI].[EDIFile].[CreatedOn], @DateTo) >= 0
	AND
		[EDI].[EDIFile].[EDIFileID] IN
		(
			SELECT
				[Claim].[ClaimProcessEDIFile].[EDIFileID]
			FROM
				[Claim].[ClaimProcessEDIFile] WITH (NOLOCK)
			INNER JOIN
				[Claim].[ClaimProcess] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[ClaimProcessID] = [Claim].[ClaimProcessEDIFile].[ClaimProcessID]
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Patient].[PatientVisit].[PatientVisitID] = [Claim].[ClaimProcess].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[Patient].[ClinicID] = @ClinicID
			AND
				[Patient].[PatientVisit].[DOS] BETWEEN @DOSFrom AND @DOSTo	
			AND
				(
					[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
				OR
					((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))) LIKE '%' + @SearchName + '%' 
				OR
					[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
				)
			AND
				[Patient].[PatientVisit].[IsActive] = 1	
			AND
				[Patient].[Patient].[IsActive] = 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1	
			AND
				[Claim].[ClaimProcessEDIFile].[IsActive] = 1
		)
	AND
		[EDI].[EDIFile].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[EDIFile].[IsActive] ELSE @IsActive END;
	
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;	
	
	SELECT		
		[EDIFile].[EDIFileID]
		,[EDIFile].[X12FileRelPath]
		,[EDIFile].[RefFileRelPath]
		,[EDIFile].[CreatedOn]		
	FROM
		[EDIFile] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [EDI].[EDIFile].[EDIFileID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;	
	
	-- EXEC [EDI].[usp_GetBySearch_EDIFile] @DateFrom 
	-- EXEC [EDI].[usp_GetBySearch_EDIFile] @ClinicID = 17,@SearchName = '',@IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 10, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END









GO



------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetSenthilSR_ClaimProcess]    Script Date: 08/02/2013 17:01:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetSenthilSR_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetSenthilSR_ClaimProcess]
GO



/****** Object:  StoredProcedure [Claim].[usp_GetSenthilSR_ClaimProcess]    Script Date: 08/02/2013 17:01:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Claim].[usp_GetSenthilSR_ClaimProcess]
	@XMLdata XML	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		t.value('(FirstName/text())[1]','nvarchar(120)')AS FirstName ,
		t.value('(LastName/text())[1]','nvarchar(120)')AS LastName,
		t.value('(UserName/text())[1]','nvarchar(120)')AS UserName,
		t.value('(Job/text())[1]','nvarchar(120)')AS Job
	FROM
	@XMLdata.nodes('/users/user')AS TempTable(t);
	
	-- EXEC [Claim].[usp_GetSenthilSR_ClaimProcess] @XMLdata = '<users><user><FirstName>Suresh</FirstName><LastName>Dasari</LastName><UserName>SureshDasari</UserName><Job>Team Leader</Job></user><user><FirstName>Mahesh</FirstName><LastName>Dasari</LastName><UserName>MaheshDasari</UserName><Job>Software Developer</Job></user><user><FirstName>Madhav</FirstName><LastName>Yemineni</LastName><UserName>MadhavYemineni</UserName><Job>Business Analyst</Job></user></users>'
END

GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetBySearchCase_PatientVisit]    Script Date: 08/08/2013 11:43:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetBySearchCase_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetBySearchCase_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetBySearchCase_PatientVisit]    Script Date: 08/08/2013 11:43:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- By Sai Manager Role-Case : For viewing all the cases irrespective of their status


CREATE PROCEDURE [Patient].[usp_GetBySearchCase_PatientVisit]
	 @SearchName NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SELECT @SearchName = '';
	END
	
	DECLARE @PatientVisitID BIGINT;
	BEGIN TRY
		SELECT @PatientVisitID = CAST (@SearchName AS BIGINT);
	END TRY
	BEGIN CATCH
		SELECT @PatientVisitID = 0;
	END CATCH
	
	IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = MIN([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit];
	END
	
	IF @StartBy IS NULL
	BEGIN
		SET @StartBy = '';
	END
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT TOP (@CurrPageNumber * @RecordsPerPage)
		[Patient].[PatientVisit].[PatientVisitID]
		, ROW_NUMBER() OVER (
			ORDER BY
			
				CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
							
				CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
								
				CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
				CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
		AND
			(
				[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
			OR
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE '%' + @SearchName + '%' 
			OR
				[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
			)
		AND
			[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;	
		    
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	DECLARE @TBL_ANS TABLE
	(
		 [PatientVisitID] BIGINT NOT NULL
		, [PatName] NVARCHAR(500) NOT NULL
		, [PatChartNumber] NVARCHAR(20) NOT NULL
		, [DOS] DATE NOT NULL
		, [PatientVisitComplexity] TINYINT NOT NULL
		, [AssignToMe] BIT NOT NULL
	);
	
	INSERT INTO
		@TBL_ANS
	SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PatName]
		, [Patient].[Patient].[ChartNumber] AS [PatChartNumber] 
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
		, CAST('1' AS BIT) AS [AssignToMe]
	FROM
		@SEARCH_TMP
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON 
		[PK_ID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Patient].[usp_GetBySearchCase_PatientVisit] @UserID = 48, @StartBy = 'A', @RecordsPerPage = 3000
	-- EXEC [Patient].[usp_GetBySearchCase_PatientVisit] @UserID = 1, @SearchName= '20573'
	-- EXEC [Patient].[usp_GetBySearchCase_PatientVisit] @UserID = 1
END






GO






------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetByAZCase_PatientVisit]    Script Date: 08/08/2013 11:50:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByAZCase_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByAZCase_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetByAZCase_PatientVisit]    Script Date: 08/08/2013 11:50:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--By Sai Manager Role-Case : For viewing all the cases irrespective of their status

CREATE PROCEDURE [Patient].[usp_GetByAZCase_PatientVisit] 
	 @SearchName NVARCHAR(350) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SELECT @SearchName = '';
	END
	
	DECLARE @PatientVisitID BIGINT;
	BEGIN TRY
		SELECT @PatientVisitID = CAST (@SearchName AS BIGINT);
	END TRY
	BEGIN CATCH
		SELECT @PatientVisitID = 0;
	END CATCH
	
	IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = MIN([DOS]) FROM [Patient].[PatientVisit];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([DOS]) FROM [Patient].[PatientVisit];
	END
    
    DECLARE @TBL_ALL TABLE
    (
		[ChartNumber] [nvarchar](350) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
    
    INSERT INTO
		@TBL_ALL
	
	SELECT
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientID]=[PatientVisit].[PatientID]
	WHERE
			[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
		 AND
			(
				[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
			OR
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE '%' + @SearchName + '%' 
			OR
				[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
			)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;	
		
	DECLARE @AZ_TMP VARCHAR(26);
	SELECT @AZ_TMP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE @AZ_LOOP INT;
	SELECT 	@AZ_LOOP = 1;
	DECLARE @AZ_CNT INT;
	SELECT @AZ_CNT = LEN(@AZ_TMP);
	DECLARE @AZ_CHR VARCHAR(1);
	SELECT @AZ_CHR = '';
	
	WHILE @AZ_LOOP <= @AZ_CNT
	BEGIN
		SELECT @AZ_CHR = SUBSTRING(@AZ_TMP, @AZ_LOOP, 1);
		
		INSERT INTO
			@TBL_AZ
		SELECT
			@AZ_CHR	AS [AZ]
			, COUNT(*) AS [AZ_COUNT]
		FROM
			@TBL_ALL
		WHERE
			[ChartNumber] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	--EXEC [Patient].[usp_GetByAZCase_PatientVisit]  @UserID = 48
END





GO






------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [EDI].[usp_GetSentFile_EDIFile]    Script Date: 08/06/2013 11:02:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetSentFile_EDIFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetSentFile_EDIFile]
GO


/****** Object:  StoredProcedure [EDI].[usp_GetSentFile_EDIFile]    Script Date: 08/06/2013 11:02:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [EDI].[usp_GetSentFile_EDIFile] 
	@ClinicID	INT
	, @StatusIDs NVARCHAR(100)
	, @UserID INT
	, @SearchName NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @DOSFrom DATE = NULL
	, @DOSTo DATE = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_SID TABLE
	(
		[CLAIM_STATUS_ID] TINYINT PRIMARY KEY NOT NULL
	);
	
	INSERT INTO
		@TBL_SID
	SELECT DISTINCT
		[Data] 
	FROM 
		[dbo].[ufn_StringSplit] (@StatusIDs, ',');
	
	IF @SearchName IS NULL
	BEGIN
		SELECT @SearchName = '';
	END
	
	DECLARE @PatientVisitID BIGINT;
	BEGIN TRY
		SELECT @PatientVisitID = CAST (@SearchName AS BIGINT);
	END TRY
	BEGIN CATCH
		SELECT @PatientVisitID = 0;
	END CATCH
	
	IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = MIN([EDI].[EDIFile].[CreatedOn]) FROM [EDI].[EDIFile] WITH (NOLOCK);
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([EDI].[EDIFile].[CreatedOn]) FROM [EDI].[EDIFile] WITH (NOLOCK);
	END	
	
	IF @DOSFrom IS NULL
	BEGIN
		SELECT @DOSFrom = MIN([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit] WITH (NOLOCK);
	END
	
	IF @DOSTo IS NULL
	BEGIN
		SELECT @DOSTo = MAX([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit] WITH (NOLOCK);
	END	
	
	DECLARE @TBL_EID TABLE
	(
		[EDI_FILE_ID] INT PRIMARY KEY NOT NULL
	);
	
	INSERT INTO
		@TBL_EID
	SELECT DISTINCT
		[B].[EDIFileID]
	FROM
		[Claim].[ClaimProcessEDIFile] B WITH (NOLOCK)
	INNER JOIN
		[Claim].[ClaimProcess] C WITH (NOLOCK)
	ON
		[C].[ClaimProcessID] = [B].[ClaimProcessID]
	INNER JOIN
		[Patient].[PatientVisit] D WITH (NOLOCK)
	ON
		[D].[PatientVisitID] = [C].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] E WITH (NOLOCK)
	ON
		[E].[PatientID] = [D].[PatientID]
	INNER JOIN
		@TBL_SID F
	ON
		[F].[CLAIM_STATUS_ID] = [D].[ClaimStatusID]
	WHERE
		[E].[ClinicID] = @ClinicID
	AND
		[D].[AssignedTo] = @UserID
	AND
		[D].[DOS] BETWEEN @DOSFrom AND @DOSTo
	AND
		(
			[E].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([E].[LastName] + ' ' + [E].[FirstName] + ' ' + ISNULL ([E].[MiddleName], ''))))) LIKE '%' + @SearchName + '%' 
		OR
			[D].[PatientVisitID] =  @PatientVisitID
		)
	AND
		[D].[IsActive] = 1	
	AND
		[E].[IsActive] = 1
	AND
		[C].[IsActive] = 1	
	AND
		[B].[IsActive] = 1;
		
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
		
	SELECT TOP (@CurrPageNumber * @RecordsPerPage)
		[A].[EDIFileID]	
		, ROW_NUMBER() OVER (
			ORDER BY

				CASE WHEN @OrderByField = 'CreatedOn' AND @OrderByDirection = 'A' THEN [A].[CreatedOn] END ASC,
				CASE WHEN @OrderByField = 'CreatedOn' AND @OrderByDirection = 'D' THEN [A].[CreatedOn] END DESC,		

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [A].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [A].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[EDI].[EDIFile] A	WITH (NOLOCK)
	INNER JOIN
		@TBL_EID G
	ON
		[G].[EDI_FILE_ID] = [A].EDIFileID
	WHERE
		DATEDIFF(DAY, [A].[CreatedOn], @DateFrom) <= 0 AND DATEDIFF(DAY, [A].[CreatedOn], @DateTo) >= 0
	AND
		[A].[IsActive] = 1;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;	
	
	SELECT
		[Z].[EDIFileID]	
		,[Z].[X12FileRelPath]
		,[Z].[RefFileRelPath]
		,[Z].[CreatedOn]	
	FROM
		[EDI].[EDIFile] Z WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Z].[EDIFileID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;		
			
	-- EXEC [EDI].[usp_GetSentFile_EDIFile] @ClinicID=20, @StatusIDs = '22,23,24', @UserID = 13, @SearchName = '' ,@DateFrom ='1900-01-01',@DateTo='2013-07-11'

END


GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [EDI].[usp_GetCountEDIHistory_EDIFile]    Script Date: 08/06/2013 11:32:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetCountEDIHistory_EDIFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetCountEDIHistory_EDIFile]
GO



/****** Object:  StoredProcedure [EDI].[usp_GetCountEDIHistory_EDIFile]    Script Date: 08/06/2013 11:32:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [EDI].[usp_GetCountEDIHistory_EDIFile]
	@ClinicID int
	, @StatusIDs NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_SID TABLE
	(
		[CLAIM_STATUS_ID] TINYINT PRIMARY KEY NOT NULL
	);
	
	INSERT INTO
		@TBL_SID
	SELECT DISTINCT
		[Data] 
	FROM 
		[dbo].[ufn_StringSplit] (@StatusIDs, ',');
	
	DECLARE @TBL_EID TABLE
	(
		[EDI_FILE_ID] INT PRIMARY KEY NOT NULL
	);
	
	INSERT INTO
		@TBL_EID
	SELECT DISTINCT
		[B].[EDIFileID]
	FROM
		[Claim].[ClaimProcessEDIFile] B WITH (NOLOCK)
	INNER JOIN
		[Claim].[ClaimProcess] C WITH (NOLOCK)
	ON
		[C].[ClaimProcessID] = [B].[ClaimProcessID]
	INNER JOIN
		[Patient].[PatientVisit] D WITH (NOLOCK)
	ON
		[D].[PatientVisitID] = [C].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] E WITH (NOLOCK)
	ON
		[E].[PatientID] = [D].[PatientID]
	INNER JOIN
		@TBL_SID F
	ON
		[F].[CLAIM_STATUS_ID] = [D].[ClaimStatusID]
	WHERE
		[E].[ClinicID] = @ClinicID
	AND
		[D].[IsActive] = 1	
	AND
		[E].[IsActive] = 1
	AND
		[C].[IsActive] = 1	
	AND
		[B].[IsActive] = 1;
	
	SELECT
		CAST(1 AS TINYINT) AS [ID]
		, COUNT ([A].[EDIFileID]) AS [CLAIM_COUNT]
	FROM
		[EDI].[EDIFile] A WITH (NOLOCK)
	INNER JOIN
		@TBL_EID G
	ON
		[G].[EDI_FILE_ID] = [A].EDIFileID
	WHERE
		[A].[IsActive] = 1;
		
	-- EXEC [EDI].[usp_GetCountEDIHistory_EDIFile] @ClinicID=17, @StatusIDs = '23, 24, 25, 26, 27, 28, 29, 30'
	-- EXEC [EDI].[usp_GetCountEDIHistory_EDIFile] @ClinicID = 20, @StatusIDs = '23, 24, 25, 26, 27, 28, 29, 30'
END










GO



------------------------------------------------------------------------------------------


/****** Object:  StoredProcedure [User].[usp_GetNameBySync_User]    Script Date: 08/07/2013 10:50:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNameBySync_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNameBySync_User]
GO



/****** Object:  StoredProcedure [User].[usp_GetNameBySync_User]    Script Date: 08/07/2013 10:50:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- Select the particular record

CREATE PROCEDURE [User].[usp_GetNameBySync_User] 
	@UserID	BIGINT
AS
BEGIN
	SET NOCOUNT ON;	

	SELECT
		LTRIM(RTRIM([A].[LastName] + ' ' + [A].[FirstName] + ' ' + ISNULL([A].[MiddleName], ''))) AS [NAME]
		, [A].[UserName] AS [CODE]
		, [A].[Email] AS [EMAIL]
	FROM
		[User].[User] A WITH (NOLOCK)
	WHERE
		[A].[UserID] = @UserID
	AND
		[A].[IsActive] = 1;

	-- EXEC [User].[usp_GetNameBySync_User] 1
	
END








GO



------------------------------------------------------------------------------------------
