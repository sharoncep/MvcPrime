USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Insert_CurrencyCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Insert_CurrencyCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Transaction].[usp_Insert_CurrencyCode]
	@CurrencyCodeCode NVARCHAR(3)
	, @CurrencyCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @CurrencyCodeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @CurrencyCodeID = [Transaction].[ufn_IsExists_CurrencyCode] (@CurrencyCodeCode, @CurrencyCodeName, @Comment, 0);
		
		IF @CurrencyCodeID = 0
		BEGIN
			INSERT INTO [Transaction].[CurrencyCode]
			(
				[CurrencyCodeCode]
				, [CurrencyCodeName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@CurrencyCodeCode
				, @CurrencyCodeName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @CurrencyCodeID = MAX([Transaction].[CurrencyCode].[CurrencyCodeID]) FROM [Transaction].[CurrencyCode];
		END
		ELSE
		BEGIN			
			SELECT @CurrencyCodeID = -1;
		END		
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
