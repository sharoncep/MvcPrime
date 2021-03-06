USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Update_TransactionSetPurposeCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Update_TransactionSetPurposeCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the TransactionSetPurposeCode in the database.
	 
CREATE PROCEDURE [Transaction].[usp_Update_TransactionSetPurposeCode]
	@TransactionSetPurposeCodeCode NVARCHAR(2)
	, @TransactionSetPurposeCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @TransactionSetPurposeCodeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @TransactionSetPurposeCodeID_PREV BIGINT;
		SELECT @TransactionSetPurposeCodeID_PREV = [Transaction].[ufn_IsExists_TransactionSetPurposeCode] (@TransactionSetPurposeCodeCode, @TransactionSetPurposeCodeName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeID] FROM [Transaction].[TransactionSetPurposeCode] WHERE [Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeID] = @TransactionSetPurposeCodeID AND [Transaction].[TransactionSetPurposeCode].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@TransactionSetPurposeCodeID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Transaction].[TransactionSetPurposeCode].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Transaction].[TransactionSetPurposeCode].[LastModifiedOn]
			FROM 
				[Transaction].[TransactionSetPurposeCode] WITH (NOLOCK)
			WHERE
				[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeID] = @TransactionSetPurposeCodeID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Transaction].[TransactionSetPurposeCodeHistory]
					(
						[TransactionSetPurposeCodeID]
						, [TransactionSetPurposeCodeCode]
						, [TransactionSetPurposeCodeName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeID]
					, [Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeCode]
					, [Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeName]
					, [Transaction].[TransactionSetPurposeCode].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Transaction].[TransactionSetPurposeCode].[IsActive]
				FROM 
					[Transaction].[TransactionSetPurposeCode]
				WHERE
					[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeID] = @TransactionSetPurposeCodeID;
				
				UPDATE 
					[Transaction].[TransactionSetPurposeCode]
				SET
					[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeCode] = @TransactionSetPurposeCodeCode
					, [Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeName] = @TransactionSetPurposeCodeName
					, [Transaction].[TransactionSetPurposeCode].[Comment] = @Comment
					, [Transaction].[TransactionSetPurposeCode].[LastModifiedBy] = @CurrentModificationBy
					, [Transaction].[TransactionSetPurposeCode].[LastModifiedOn] = @CurrentModificationOn
					, [Transaction].[TransactionSetPurposeCode].[IsActive] = @IsActive
				WHERE
					[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeID] = @TransactionSetPurposeCodeID;				
			END
			ELSE
			BEGIN
				SELECT @TransactionSetPurposeCodeID = -2;
			END
		END
		ELSE IF @TransactionSetPurposeCodeID_PREV <> @TransactionSetPurposeCodeID
		BEGIN			
			SELECT @TransactionSetPurposeCodeID = -1;			
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
			SELECT @TransactionSetPurposeCodeID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
