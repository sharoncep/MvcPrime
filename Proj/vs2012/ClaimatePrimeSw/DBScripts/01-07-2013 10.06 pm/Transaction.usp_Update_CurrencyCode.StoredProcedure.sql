USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Update_CurrencyCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Update_CurrencyCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the CurrencyCode in the database.
	 
CREATE PROCEDURE [Transaction].[usp_Update_CurrencyCode]
	@CurrencyCodeCode NVARCHAR(3)
	, @CurrencyCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @CurrencyCodeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @CurrencyCodeID_PREV BIGINT;
		SELECT @CurrencyCodeID_PREV = [Transaction].[ufn_IsExists_CurrencyCode] (@CurrencyCodeCode, @CurrencyCodeName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Transaction].[CurrencyCode].[CurrencyCodeID] FROM [Transaction].[CurrencyCode] WHERE [Transaction].[CurrencyCode].[CurrencyCodeID] = @CurrencyCodeID AND [Transaction].[CurrencyCode].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@CurrencyCodeID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Transaction].[CurrencyCode].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Transaction].[CurrencyCode].[LastModifiedOn]
			FROM 
				[Transaction].[CurrencyCode] WITH (NOLOCK)
			WHERE
				[Transaction].[CurrencyCode].[CurrencyCodeID] = @CurrencyCodeID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Transaction].[CurrencyCodeHistory]
					(
						[CurrencyCodeID]
						, [CurrencyCodeCode]
						, [CurrencyCodeName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Transaction].[CurrencyCode].[CurrencyCodeID]
					, [Transaction].[CurrencyCode].[CurrencyCodeCode]
					, [Transaction].[CurrencyCode].[CurrencyCodeName]
					, [Transaction].[CurrencyCode].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Transaction].[CurrencyCode].[IsActive]
				FROM 
					[Transaction].[CurrencyCode]
				WHERE
					[Transaction].[CurrencyCode].[CurrencyCodeID] = @CurrencyCodeID;
				
				UPDATE 
					[Transaction].[CurrencyCode]
				SET
					[Transaction].[CurrencyCode].[CurrencyCodeCode] = @CurrencyCodeCode
					, [Transaction].[CurrencyCode].[CurrencyCodeName] = @CurrencyCodeName
					, [Transaction].[CurrencyCode].[Comment] = @Comment
					, [Transaction].[CurrencyCode].[LastModifiedBy] = @CurrentModificationBy
					, [Transaction].[CurrencyCode].[LastModifiedOn] = @CurrentModificationOn
					, [Transaction].[CurrencyCode].[IsActive] = @IsActive
				WHERE
					[Transaction].[CurrencyCode].[CurrencyCodeID] = @CurrencyCodeID;				
			END
			ELSE
			BEGIN
				SELECT @CurrencyCodeID = -2;
			END
		END
		ELSE IF @CurrencyCodeID_PREV <> @CurrencyCodeID
		BEGIN			
			SELECT @CurrencyCodeID = -1;			
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
			SELECT @CurrencyCodeID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
