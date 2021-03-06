USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_Insert_ClaimDiagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_Insert_ClaimDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Claim].[usp_Insert_ClaimDiagnosis]
	@PatientVisitID BIGINT
	, @DiagnosisID INT
	, @ClaimNumber BIGINT
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @ClaimDiagnosisID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @ClaimDiagnosisID = [Claim].[ufn_IsExists_ClaimDiagnosis] (@PatientVisitID, @DiagnosisID, @ClaimNumber, @Comment, 0);
		
		IF @ClaimDiagnosisID = 0
		BEGIN
			INSERT INTO [Claim].[ClaimDiagnosis]
			(
				[PatientVisitID]
				, [DiagnosisID]
				, [ClaimNumber]
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
				, @DiagnosisID
				, @ClaimNumber
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @ClaimDiagnosisID = MAX([Claim].[ClaimDiagnosis].[ClaimDiagnosisID]) FROM [Claim].[ClaimDiagnosis];
		END
		ELSE
		BEGIN			
			SELECT @ClaimDiagnosisID = -1;
		END		
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
