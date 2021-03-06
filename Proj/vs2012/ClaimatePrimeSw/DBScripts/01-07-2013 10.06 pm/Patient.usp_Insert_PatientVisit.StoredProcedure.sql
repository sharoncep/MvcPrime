USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_Insert_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_Insert_PatientVisit]
GO
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
		
		SELECT @PatientHospitalizationID = [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND (([Patient].[PatientHospitalization].[AdmittedOn] >= @DOS AND [Patient].[PatientHospitalization].[DischargedOn] IS NULL) OR (@DOS BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn] AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL)) AND [Patient].[PatientHospitalization].[IsActive] = 1;
		
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
