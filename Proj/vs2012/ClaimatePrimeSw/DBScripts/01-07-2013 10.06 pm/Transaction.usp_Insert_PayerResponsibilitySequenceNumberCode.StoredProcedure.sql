USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Insert_PayerResponsibilitySequenceNumberCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Insert_PayerResponsibilitySequenceNumberCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Transaction].[usp_Insert_PayerResponsibilitySequenceNumberCode]
	@PayerResponsibilitySequenceNumberCodeCode NVARCHAR(1)
	, @PayerResponsibilitySequenceNumberCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @PayerResponsibilitySequenceNumberCodeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @PayerResponsibilitySequenceNumberCodeID = [Transaction].[ufn_IsExists_PayerResponsibilitySequenceNumberCode] (@PayerResponsibilitySequenceNumberCodeCode, @PayerResponsibilitySequenceNumberCodeName, @Comment, 0);
		
		IF @PayerResponsibilitySequenceNumberCodeID = 0
		BEGIN
			INSERT INTO [Transaction].[PayerResponsibilitySequenceNumberCode]
			(
				[PayerResponsibilitySequenceNumberCodeCode]
				, [PayerResponsibilitySequenceNumberCodeName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@PayerResponsibilitySequenceNumberCodeCode
				, @PayerResponsibilitySequenceNumberCodeName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @PayerResponsibilitySequenceNumberCodeID = MAX([Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeID]) FROM [Transaction].[PayerResponsibilitySequenceNumberCode];
		END
		ELSE
		BEGIN			
			SELECT @PayerResponsibilitySequenceNumberCodeID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @PayerResponsibilitySequenceNumberCodeID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
