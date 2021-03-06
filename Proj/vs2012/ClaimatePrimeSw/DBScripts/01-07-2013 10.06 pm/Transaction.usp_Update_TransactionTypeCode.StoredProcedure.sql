USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Update_TransactionTypeCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Update_TransactionTypeCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the TransactionTypeCode in the database.
	 
CREATE PROCEDURE [Transaction].[usp_Update_TransactionTypeCode]
	@TransactionTypeCodeCode NVARCHAR(2)
	, @TransactionTypeCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @TransactionTypeCodeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @TransactionTypeCodeID_PREV BIGINT;
		SELECT @TransactionTypeCodeID_PREV = [Transaction].[ufn_IsExists_TransactionTypeCode] (@TransactionTypeCodeCode, @TransactionTypeCodeName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Transaction].[TransactionTypeCode].[TransactionTypeCodeID] FROM [Transaction].[TransactionTypeCode] WHERE [Transaction].[TransactionTypeCode].[TransactionTypeCodeID] = @TransactionTypeCodeID AND [Transaction].[TransactionTypeCode].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@TransactionTypeCodeID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Transaction].[TransactionTypeCode].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Transaction].[TransactionTypeCode].[LastModifiedOn]
			FROM 
				[Transaction].[TransactionTypeCode] WITH (NOLOCK)
			WHERE
				[Transaction].[TransactionTypeCode].[TransactionTypeCodeID] = @TransactionTypeCodeID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Transaction].[TransactionTypeCodeHistory]
					(
						[TransactionTypeCodeID]
						, [TransactionTypeCodeCode]
						, [TransactionTypeCodeName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Transaction].[TransactionTypeCode].[TransactionTypeCodeID]
					, [Transaction].[TransactionTypeCode].[TransactionTypeCodeCode]
					, [Transaction].[TransactionTypeCode].[TransactionTypeCodeName]
					, [Transaction].[TransactionTypeCode].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Transaction].[TransactionTypeCode].[IsActive]
				FROM 
					[Transaction].[TransactionTypeCode]
				WHERE
					[Transaction].[TransactionTypeCode].[TransactionTypeCodeID] = @TransactionTypeCodeID;
				
				UPDATE 
					[Transaction].[TransactionTypeCode]
				SET
					[Transaction].[TransactionTypeCode].[TransactionTypeCodeCode] = @TransactionTypeCodeCode
					, [Transaction].[TransactionTypeCode].[TransactionTypeCodeName] = @TransactionTypeCodeName
					, [Transaction].[TransactionTypeCode].[Comment] = @Comment
					, [Transaction].[TransactionTypeCode].[LastModifiedBy] = @CurrentModificationBy
					, [Transaction].[TransactionTypeCode].[LastModifiedOn] = @CurrentModificationOn
					, [Transaction].[TransactionTypeCode].[IsActive] = @IsActive
				WHERE
					[Transaction].[TransactionTypeCode].[TransactionTypeCodeID] = @TransactionTypeCodeID;				
			END
			ELSE
			BEGIN
				SELECT @TransactionTypeCodeID = -2;
			END
		END
		ELSE IF @TransactionTypeCodeID_PREV <> @TransactionTypeCodeID
		BEGIN			
			SELECT @TransactionTypeCodeID = -1;			
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
			SELECT @TransactionTypeCodeID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
