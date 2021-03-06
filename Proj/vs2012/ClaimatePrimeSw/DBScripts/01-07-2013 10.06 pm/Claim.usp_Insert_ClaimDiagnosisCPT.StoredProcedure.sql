USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_Insert_ClaimDiagnosisCPT]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_Insert_ClaimDiagnosisCPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Claim].[usp_Insert_ClaimDiagnosisCPT]
	@ClaimDiagnosisID BIGINT
	, @CPTID INT
	, @FacilityTypeID TINYINT
	, @Unit INT
	, @ChargePerUnit DECIMAL
	, @CPTDOS DATE
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @ClaimDiagnosisCPTID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @ClaimDiagnosisCPTID = [Claim].[ufn_IsExists_ClaimDiagnosisCPT] (@ClaimDiagnosisID, @CPTID, @FacilityTypeID, @Unit, @ChargePerUnit, @CPTDOS, @Comment, 0);
		
		IF @ClaimDiagnosisCPTID = 0
		BEGIN
			INSERT INTO [Claim].[ClaimDiagnosisCPT]
			(
				[ClaimDiagnosisID]
				, [CPTID]
				, [FacilityTypeID]
				, [Unit]
				, [ChargePerUnit]
				, [CPTDOS]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@ClaimDiagnosisID
				, @CPTID
				, @FacilityTypeID
				, @Unit
				, @ChargePerUnit
				, @CPTDOS
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @ClaimDiagnosisCPTID = MAX([Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID]) FROM [Claim].[ClaimDiagnosisCPT];
		END
		ELSE
		BEGIN			
			SELECT @ClaimDiagnosisCPTID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @ClaimDiagnosisCPTID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
