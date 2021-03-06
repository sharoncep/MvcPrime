USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_Update_ClaimDiagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_Update_ClaimDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the ClaimDiagnosis in the database.
	 
CREATE PROCEDURE [Claim].[usp_Update_ClaimDiagnosis]
	@PatientVisitID BIGINT
	, @DiagnosisID INT
	, @ClaimNumber BIGINT
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @ClaimDiagnosisID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @ClaimDiagnosisID_PREV BIGINT;
		SELECT @ClaimDiagnosisID_PREV = [Claim].[ufn_IsExists_ClaimDiagnosis] (@PatientVisitID, @DiagnosisID, @ClaimNumber, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Claim].[ClaimDiagnosis].[ClaimDiagnosisID] FROM [Claim].[ClaimDiagnosis] WHERE [Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = @ClaimDiagnosisID AND [Claim].[ClaimDiagnosis].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@ClaimDiagnosisID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Claim].[ClaimDiagnosis].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Claim].[ClaimDiagnosis].[LastModifiedOn]
			FROM 
				[Claim].[ClaimDiagnosis] WITH (NOLOCK)
			WHERE
				[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = @ClaimDiagnosisID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Claim].[ClaimDiagnosisHistory]
					(
						[ClaimDiagnosisID]
						, [PatientVisitID]
						, [DiagnosisID]
						, [ClaimNumber]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
					, [Claim].[ClaimDiagnosis].[PatientVisitID]
					, [Claim].[ClaimDiagnosis].[DiagnosisID]
					, [Claim].[ClaimDiagnosis].[ClaimNumber]
					, [Claim].[ClaimDiagnosis].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Claim].[ClaimDiagnosis].[IsActive]
				FROM 
					[Claim].[ClaimDiagnosis]
				WHERE
					[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = @ClaimDiagnosisID;
				
				UPDATE 
					[Claim].[ClaimDiagnosis]
				SET
					[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
					, [Claim].[ClaimDiagnosis].[DiagnosisID] = @DiagnosisID
					, [Claim].[ClaimDiagnosis].[ClaimNumber] = @ClaimNumber
					, [Claim].[ClaimDiagnosis].[Comment] = @Comment
					, [Claim].[ClaimDiagnosis].[LastModifiedBy] = @CurrentModificationBy
					, [Claim].[ClaimDiagnosis].[LastModifiedOn] = @CurrentModificationOn
					, [Claim].[ClaimDiagnosis].[IsActive] = @IsActive
				WHERE
					[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = @ClaimDiagnosisID;				
			END
			ELSE
			BEGIN
				SELECT @ClaimDiagnosisID = -2;
			END
		END
		ELSE IF @ClaimDiagnosisID_PREV <> @ClaimDiagnosisID
		BEGIN			
			SELECT @ClaimDiagnosisID = -1;			
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
			SELECT @ClaimDiagnosisID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
