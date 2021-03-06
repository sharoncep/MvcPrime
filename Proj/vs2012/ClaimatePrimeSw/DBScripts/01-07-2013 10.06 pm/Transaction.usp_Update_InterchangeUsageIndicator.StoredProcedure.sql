USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Update_InterchangeUsageIndicator]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Update_InterchangeUsageIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the InterchangeUsageIndicator in the database.
	 
CREATE PROCEDURE [Transaction].[usp_Update_InterchangeUsageIndicator]
	@InterchangeUsageIndicatorCode NVARCHAR(1)
	, @InterchangeUsageIndicatorName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @InterchangeUsageIndicatorID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @InterchangeUsageIndicatorID_PREV BIGINT;
		SELECT @InterchangeUsageIndicatorID_PREV = [Transaction].[ufn_IsExists_InterchangeUsageIndicator] (@InterchangeUsageIndicatorCode, @InterchangeUsageIndicatorName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorID] FROM [Transaction].[InterchangeUsageIndicator] WHERE [Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorID] = @InterchangeUsageIndicatorID AND [Transaction].[InterchangeUsageIndicator].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@InterchangeUsageIndicatorID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Transaction].[InterchangeUsageIndicator].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Transaction].[InterchangeUsageIndicator].[LastModifiedOn]
			FROM 
				[Transaction].[InterchangeUsageIndicator] WITH (NOLOCK)
			WHERE
				[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorID] = @InterchangeUsageIndicatorID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Transaction].[InterchangeUsageIndicatorHistory]
					(
						[InterchangeUsageIndicatorID]
						, [InterchangeUsageIndicatorCode]
						, [InterchangeUsageIndicatorName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorID]
					, [Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode]
					, [Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName]
					, [Transaction].[InterchangeUsageIndicator].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Transaction].[InterchangeUsageIndicator].[IsActive]
				FROM 
					[Transaction].[InterchangeUsageIndicator]
				WHERE
					[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorID] = @InterchangeUsageIndicatorID;
				
				UPDATE 
					[Transaction].[InterchangeUsageIndicator]
				SET
					[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] = @InterchangeUsageIndicatorCode
					, [Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] = @InterchangeUsageIndicatorName
					, [Transaction].[InterchangeUsageIndicator].[Comment] = @Comment
					, [Transaction].[InterchangeUsageIndicator].[LastModifiedBy] = @CurrentModificationBy
					, [Transaction].[InterchangeUsageIndicator].[LastModifiedOn] = @CurrentModificationOn
					, [Transaction].[InterchangeUsageIndicator].[IsActive] = @IsActive
				WHERE
					[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorID] = @InterchangeUsageIndicatorID;				
			END
			ELSE
			BEGIN
				SELECT @InterchangeUsageIndicatorID = -2;
			END
		END
		ELSE IF @InterchangeUsageIndicatorID_PREV <> @InterchangeUsageIndicatorID
		BEGIN			
			SELECT @InterchangeUsageIndicatorID = -1;			
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
			SELECT @InterchangeUsageIndicatorID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
