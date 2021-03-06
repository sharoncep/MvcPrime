USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_Insert_DiagnosisGroup]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_Insert_DiagnosisGroup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Diagnosis].[usp_Insert_DiagnosisGroup]
	@DiagnosisGroupCode NVARCHAR(9)
	, @DiagnosisGroupDescription NVARCHAR(150)
	, @Amount DECIMAL
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @DiagnosisGroupID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @DiagnosisGroupID = [Diagnosis].[ufn_IsExists_DiagnosisGroup] (@DiagnosisGroupCode, @DiagnosisGroupDescription, @Amount, @Comment, 0);
		
		IF @DiagnosisGroupID = 0
		BEGIN
			INSERT INTO [Diagnosis].[DiagnosisGroup]
			(
				[DiagnosisGroupCode]
				, [DiagnosisGroupDescription]
				, [Amount]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@DiagnosisGroupCode
				, @DiagnosisGroupDescription
				, @Amount
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @DiagnosisGroupID = MAX([Diagnosis].[DiagnosisGroup].[DiagnosisGroupID]) FROM [Diagnosis].[DiagnosisGroup];
		END
		ELSE
		BEGIN			
			SELECT @DiagnosisGroupID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @DiagnosisGroupID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
