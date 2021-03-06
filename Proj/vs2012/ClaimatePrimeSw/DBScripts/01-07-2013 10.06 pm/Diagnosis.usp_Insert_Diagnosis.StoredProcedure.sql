USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_Insert_Diagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_Insert_Diagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Diagnosis].[usp_Insert_Diagnosis]
	@DiagnosisCode NVARCHAR(9)
	, @ICDFormat TINYINT
	, @DiagnosisGroupID INT = NULL
	, @ShortDesc NVARCHAR(150) = NULL
	, @MediumDesc NVARCHAR(150) = NULL
	, @LongDesc NVARCHAR(255) = NULL
	, @CustomDesc NVARCHAR(150) = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @DiagnosisID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @DiagnosisID = [Diagnosis].[ufn_IsExists_Diagnosis] (@DiagnosisCode, @ICDFormat, @DiagnosisGroupID, @ShortDesc, @MediumDesc, @LongDesc, @CustomDesc, @Comment, 0);
		
		IF @DiagnosisID = 0
		BEGIN
			INSERT INTO [Diagnosis].[Diagnosis]
			(
				[DiagnosisCode]
				, [ICDFormat]
				, [DiagnosisGroupID]
				, [ShortDesc]
				, [MediumDesc]
				, [LongDesc]
				, [CustomDesc]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@DiagnosisCode
				, @ICDFormat
				, @DiagnosisGroupID
				, @ShortDesc
				, @MediumDesc
				, @LongDesc
				, @CustomDesc
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @DiagnosisID = MAX([Diagnosis].[Diagnosis].[DiagnosisID]) FROM [Diagnosis].[Diagnosis];
		END
		ELSE
		BEGIN			
			SELECT @DiagnosisID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @DiagnosisID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
