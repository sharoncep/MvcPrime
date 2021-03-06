USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Configuration].[usp_Update_Password]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Configuration].[usp_Update_Password]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Password in the database.
	 
CREATE PROCEDURE [Configuration].[usp_Update_Password]
	@MinLength TINYINT
	, @MaxLength TINYINT
	, @UpperCaseMinCount TINYINT
	, @NumberMinCount TINYINT
	, @SplCharCount TINYINT
	, @ExpiryDayMaxCount TINYINT
	, @TrialMaxCount TINYINT
	, @HistoryReuseStatus TINYINT
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @PasswordID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @PasswordID_PREV BIGINT;
		SELECT @PasswordID_PREV = [Configuration].[ufn_IsExists_Password] (@MinLength, @MaxLength, @UpperCaseMinCount, @NumberMinCount, @SplCharCount, @ExpiryDayMaxCount, @TrialMaxCount, @HistoryReuseStatus, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Configuration].[Password].[PasswordID] FROM [Configuration].[Password] WHERE [Configuration].[Password].[PasswordID] = @PasswordID AND [Configuration].[Password].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@PasswordID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Configuration].[Password].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Configuration].[Password].[LastModifiedOn]
			FROM 
				[Configuration].[Password] WITH (NOLOCK)
			WHERE
				[Configuration].[Password].[PasswordID] = @PasswordID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Configuration].[PasswordHistory]
					(
						[PasswordID]
						, [MinLength]
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
				SELECT
					[Configuration].[Password].[PasswordID]
					, [Configuration].[Password].[MinLength]
					, [Configuration].[Password].[MaxLength]
					, [Configuration].[Password].[UpperCaseMinCount]
					, [Configuration].[Password].[NumberMinCount]
					, [Configuration].[Password].[SplCharCount]
					, [Configuration].[Password].[ExpiryDayMaxCount]
					, [Configuration].[Password].[TrialMaxCount]
					, [Configuration].[Password].[HistoryReuseStatus]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Configuration].[Password].[IsActive]
				FROM 
					[Configuration].[Password]
				WHERE
					[Configuration].[Password].[PasswordID] = @PasswordID;
				
				UPDATE 
					[Configuration].[Password]
				SET
					[Configuration].[Password].[MinLength] = @MinLength
					, [Configuration].[Password].[MaxLength] = @MaxLength
					, [Configuration].[Password].[UpperCaseMinCount] = @UpperCaseMinCount
					, [Configuration].[Password].[NumberMinCount] = @NumberMinCount
					, [Configuration].[Password].[SplCharCount] = @SplCharCount
					, [Configuration].[Password].[ExpiryDayMaxCount] = @ExpiryDayMaxCount
					, [Configuration].[Password].[TrialMaxCount] = @TrialMaxCount
					, [Configuration].[Password].[HistoryReuseStatus] = @HistoryReuseStatus
					, [Configuration].[Password].[LastModifiedBy] = @CurrentModificationBy
					, [Configuration].[Password].[LastModifiedOn] = @CurrentModificationOn
					, [Configuration].[Password].[IsActive] = @IsActive
				WHERE
					[Configuration].[Password].[PasswordID] = @PasswordID;				
			END
			ELSE
			BEGIN
				SELECT @PasswordID = -2;
			END
		END
		ELSE IF @PasswordID_PREV <> @PasswordID
		BEGIN			
			SELECT @PasswordID = -1;			
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
			SELECT @PasswordID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
