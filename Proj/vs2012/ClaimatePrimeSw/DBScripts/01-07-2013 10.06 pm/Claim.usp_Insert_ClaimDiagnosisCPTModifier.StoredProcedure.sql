USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_Insert_ClaimDiagnosisCPTModifier]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_Insert_ClaimDiagnosisCPTModifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Claim].[usp_Insert_ClaimDiagnosisCPTModifier]
	@ClaimDiagnosisCPTID BIGINT
	, @ModifierID INT
	, @ModifierLevel TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @ClaimDiagnosisCPTModifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @ClaimDiagnosisCPTModifierID = [Claim].[ufn_IsExists_ClaimDiagnosisCPTModifier] (@ClaimDiagnosisCPTID, @ModifierID, @ModifierLevel, @Comment, 0);
		
		IF @ClaimDiagnosisCPTModifierID = 0
		BEGIN
			INSERT INTO [Claim].[ClaimDiagnosisCPTModifier]
			(
				[ClaimDiagnosisCPTID]
				, [ModifierID]
				, [ModifierLevel]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@ClaimDiagnosisCPTID
				, @ModifierID
				, @ModifierLevel
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @ClaimDiagnosisCPTModifierID = MAX([Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTModifierID]) FROM [Claim].[ClaimDiagnosisCPTModifier];
		END
		ELSE
		BEGIN			
			SELECT @ClaimDiagnosisCPTModifierID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @ClaimDiagnosisCPTModifierID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
