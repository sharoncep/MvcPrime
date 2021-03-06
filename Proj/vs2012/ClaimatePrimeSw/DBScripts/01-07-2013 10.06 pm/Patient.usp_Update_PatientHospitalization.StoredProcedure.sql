USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_Update_PatientHospitalization]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_Update_PatientHospitalization]
GO
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
					ELSE IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = 1)
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
					ELSE IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -14;
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
