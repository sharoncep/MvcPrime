USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_Update_IllnessIndicator]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_Update_IllnessIndicator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the IllnessIndicator in the database.
	 
CREATE PROCEDURE [Diagnosis].[usp_Update_IllnessIndicator]
	@IllnessIndicatorCode NVARCHAR(2)
	, @IllnessIndicatorName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @IllnessIndicatorID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @IllnessIndicatorID_PREV BIGINT;
		SELECT @IllnessIndicatorID_PREV = [Diagnosis].[ufn_IsExists_IllnessIndicator] (@IllnessIndicatorCode, @IllnessIndicatorName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Diagnosis].[IllnessIndicator].[IllnessIndicatorID] FROM [Diagnosis].[IllnessIndicator] WHERE [Diagnosis].[IllnessIndicator].[IllnessIndicatorID] = @IllnessIndicatorID AND [Diagnosis].[IllnessIndicator].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@IllnessIndicatorID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Diagnosis].[IllnessIndicator].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Diagnosis].[IllnessIndicator].[LastModifiedOn]
			FROM 
				[Diagnosis].[IllnessIndicator] WITH (NOLOCK)
			WHERE
				[Diagnosis].[IllnessIndicator].[IllnessIndicatorID] = @IllnessIndicatorID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Diagnosis].[IllnessIndicatorHistory]
					(
						[IllnessIndicatorID]
						, [IllnessIndicatorCode]
						, [IllnessIndicatorName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Diagnosis].[IllnessIndicator].[IllnessIndicatorID]
					, [Diagnosis].[IllnessIndicator].[IllnessIndicatorCode]
					, [Diagnosis].[IllnessIndicator].[IllnessIndicatorName]
					, [Diagnosis].[IllnessIndicator].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Diagnosis].[IllnessIndicator].[IsActive]
				FROM 
					[Diagnosis].[IllnessIndicator]
				WHERE
					[Diagnosis].[IllnessIndicator].[IllnessIndicatorID] = @IllnessIndicatorID;
				
				UPDATE 
					[Diagnosis].[IllnessIndicator]
				SET
					[Diagnosis].[IllnessIndicator].[IllnessIndicatorCode] = @IllnessIndicatorCode
					, [Diagnosis].[IllnessIndicator].[IllnessIndicatorName] = @IllnessIndicatorName
					, [Diagnosis].[IllnessIndicator].[Comment] = @Comment
					, [Diagnosis].[IllnessIndicator].[LastModifiedBy] = @CurrentModificationBy
					, [Diagnosis].[IllnessIndicator].[LastModifiedOn] = @CurrentModificationOn
					, [Diagnosis].[IllnessIndicator].[IsActive] = @IsActive
				WHERE
					[Diagnosis].[IllnessIndicator].[IllnessIndicatorID] = @IllnessIndicatorID;				
			END
			ELSE
			BEGIN
				SELECT @IllnessIndicatorID = -2;
			END
		END
		ELSE IF @IllnessIndicatorID_PREV <> @IllnessIndicatorID
		BEGIN			
			SELECT @IllnessIndicatorID = -1;			
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
			SELECT @IllnessIndicatorID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
