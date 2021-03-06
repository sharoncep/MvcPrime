USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Insert_TransactionSetPurposeCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Insert_TransactionSetPurposeCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Transaction].[usp_Insert_TransactionSetPurposeCode]
	@TransactionSetPurposeCodeCode NVARCHAR(2)
	, @TransactionSetPurposeCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @TransactionSetPurposeCodeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @TransactionSetPurposeCodeID = [Transaction].[ufn_IsExists_TransactionSetPurposeCode] (@TransactionSetPurposeCodeCode, @TransactionSetPurposeCodeName, @Comment, 0);
		
		IF @TransactionSetPurposeCodeID = 0
		BEGIN
			INSERT INTO [Transaction].[TransactionSetPurposeCode]
			(
				[TransactionSetPurposeCodeCode]
				, [TransactionSetPurposeCodeName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@TransactionSetPurposeCodeCode
				, @TransactionSetPurposeCodeName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @TransactionSetPurposeCodeID = MAX([Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeID]) FROM [Transaction].[TransactionSetPurposeCode];
		END
		ELSE
		BEGIN			
			SELECT @TransactionSetPurposeCodeID = -1;
		END		
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
