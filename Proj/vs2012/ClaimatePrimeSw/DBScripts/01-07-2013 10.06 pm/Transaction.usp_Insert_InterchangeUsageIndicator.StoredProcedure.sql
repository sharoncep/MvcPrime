USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Insert_InterchangeUsageIndicator]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Insert_InterchangeUsageIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Transaction].[usp_Insert_InterchangeUsageIndicator]
	@InterchangeUsageIndicatorCode NVARCHAR(1)
	, @InterchangeUsageIndicatorName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @InterchangeUsageIndicatorID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @InterchangeUsageIndicatorID = [Transaction].[ufn_IsExists_InterchangeUsageIndicator] (@InterchangeUsageIndicatorCode, @InterchangeUsageIndicatorName, @Comment, 0);
		
		IF @InterchangeUsageIndicatorID = 0
		BEGIN
			INSERT INTO [Transaction].[InterchangeUsageIndicator]
			(
				[InterchangeUsageIndicatorCode]
				, [InterchangeUsageIndicatorName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@InterchangeUsageIndicatorCode
				, @InterchangeUsageIndicatorName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @InterchangeUsageIndicatorID = MAX([Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorID]) FROM [Transaction].[InterchangeUsageIndicator];
		END
		ELSE
		BEGIN			
			SELECT @InterchangeUsageIndicatorID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @InterchangeUsageIndicatorID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
