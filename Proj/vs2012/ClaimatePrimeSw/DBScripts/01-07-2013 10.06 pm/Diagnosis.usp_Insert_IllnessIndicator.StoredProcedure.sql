USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_Insert_IllnessIndicator]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_Insert_IllnessIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Diagnosis].[usp_Insert_IllnessIndicator]
	@IllnessIndicatorCode NVARCHAR(2)
	, @IllnessIndicatorName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @IllnessIndicatorID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @IllnessIndicatorID = [Diagnosis].[ufn_IsExists_IllnessIndicator] (@IllnessIndicatorCode, @IllnessIndicatorName, @Comment, 0);
		
		IF @IllnessIndicatorID = 0
		BEGIN
			INSERT INTO [Diagnosis].[IllnessIndicator]
			(
				[IllnessIndicatorCode]
				, [IllnessIndicatorName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@IllnessIndicatorCode
				, @IllnessIndicatorName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @IllnessIndicatorID = MAX([Diagnosis].[IllnessIndicator].[IllnessIndicatorID]) FROM [Diagnosis].[IllnessIndicator];
		END
		ELSE
		BEGIN			
			SELECT @IllnessIndicatorID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @IllnessIndicatorID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
