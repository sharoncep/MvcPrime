USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_Insert_PatientHospitalization]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_Insert_PatientHospitalization]
GO
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
