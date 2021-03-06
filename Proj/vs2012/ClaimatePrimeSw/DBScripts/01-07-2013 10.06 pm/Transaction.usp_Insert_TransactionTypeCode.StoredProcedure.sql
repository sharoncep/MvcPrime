USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Insert_TransactionTypeCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Insert_TransactionTypeCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Transaction].[usp_Insert_TransactionTypeCode]
	@TransactionTypeCodeCode NVARCHAR(2)
	, @TransactionTypeCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @TransactionTypeCodeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @TransactionTypeCodeID = [Transaction].[ufn_IsExists_TransactionTypeCode] (@TransactionTypeCodeCode, @TransactionTypeCodeName, @Comment, 0);
		
		IF @TransactionTypeCodeID = 0
		BEGIN
			INSERT INTO [Transaction].[TransactionTypeCode]
			(
				[TransactionTypeCodeCode]
				, [TransactionTypeCodeName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@TransactionTypeCodeCode
				, @TransactionTypeCodeName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @TransactionTypeCodeID = MAX([Transaction].[TransactionTypeCode].[TransactionTypeCodeID]) FROM [Transaction].[TransactionTypeCode];
		END
		ELSE
		BEGIN			
			SELECT @TransactionTypeCodeID = -1;
		END		
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
