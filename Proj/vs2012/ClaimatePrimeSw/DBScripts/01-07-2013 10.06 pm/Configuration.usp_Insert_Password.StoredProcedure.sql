USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_Insert_Password]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_Insert_Password]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Configuration].[usp_Insert_Password]
	@MinLength TINYINT
	, @MaxLength TINYINT
	, @UpperCaseMinCount TINYINT
	, @NumberMinCount TINYINT
	, @SplCharCount TINYINT
	, @ExpiryDayMaxCount TINYINT
	, @TrialMaxCount TINYINT
	, @HistoryReuseStatus TINYINT
	, @CurrentModificationBy BIGINT
	, @PasswordID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @PasswordID = [Configuration].[ufn_IsExists_Password] (@MinLength, @MaxLength, @UpperCaseMinCount, @NumberMinCount, @SplCharCount, @ExpiryDayMaxCount, @TrialMaxCount, @HistoryReuseStatus, 0);
		
		IF @PasswordID = 0
		BEGIN
			INSERT INTO [Configuration].[Password]
			(
				[MinLength]
				, [MaxLength]
				, [UpperCaseMinCount]
				, [NumberMinCount]
				, [SplCharCount]
				, [ExpiryDayMaxCount]
				, [TrialMaxCount]
				, [HistoryReuseStatus]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@MinLength
				, @MaxLength
				, @UpperCaseMinCount
				, @NumberMinCount
				, @SplCharCount
				, @ExpiryDayMaxCount
				, @TrialMaxCount
				, @HistoryReuseStatus
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @PasswordID = MAX([Configuration].[Password].[PasswordID]) FROM [Configuration].[Password];
		END
		ELSE
		BEGIN			
			SELECT @PasswordID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @PasswordID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
