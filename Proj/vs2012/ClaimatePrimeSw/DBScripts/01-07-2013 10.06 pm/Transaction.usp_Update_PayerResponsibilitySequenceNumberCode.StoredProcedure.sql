USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Update_PayerResponsibilitySequenceNumberCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Update_PayerResponsibilitySequenceNumberCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the PayerResponsibilitySequenceNumberCode in the database.
	 
CREATE PROCEDURE [Transaction].[usp_Update_PayerResponsibilitySequenceNumberCode]
	@PayerResponsibilitySequenceNumberCodeCode NVARCHAR(1)
	, @PayerResponsibilitySequenceNumberCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @PayerResponsibilitySequenceNumberCodeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @PayerResponsibilitySequenceNumberCodeID_PREV BIGINT;
		SELECT @PayerResponsibilitySequenceNumberCodeID_PREV = [Transaction].[ufn_IsExists_PayerResponsibilitySequenceNumberCode] (@PayerResponsibilitySequenceNumberCodeCode, @PayerResponsibilitySequenceNumberCodeName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeID] FROM [Transaction].[PayerResponsibilitySequenceNumberCode] WHERE [Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeID] = @PayerResponsibilitySequenceNumberCodeID AND [Transaction].[PayerResponsibilitySequenceNumberCode].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@PayerResponsibilitySequenceNumberCodeID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Transaction].[PayerResponsibilitySequenceNumberCode].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Transaction].[PayerResponsibilitySequenceNumberCode].[LastModifiedOn]
			FROM 
				[Transaction].[PayerResponsibilitySequenceNumberCode] WITH (NOLOCK)
			WHERE
				[Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeID] = @PayerResponsibilitySequenceNumberCodeID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Transaction].[PayerResponsibilitySequenceNumberCodeHistory]
					(
						[PayerResponsibilitySequenceNumberCodeID]
						, [PayerResponsibilitySequenceNumberCodeCode]
						, [PayerResponsibilitySequenceNumberCodeName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeID]
					, [Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeCode]
					, [Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeName]
					, [Transaction].[PayerResponsibilitySequenceNumberCode].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Transaction].[PayerResponsibilitySequenceNumberCode].[IsActive]
				FROM 
					[Transaction].[PayerResponsibilitySequenceNumberCode]
				WHERE
					[Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeID] = @PayerResponsibilitySequenceNumberCodeID;
				
				UPDATE 
					[Transaction].[PayerResponsibilitySequenceNumberCode]
				SET
					[Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeCode] = @PayerResponsibilitySequenceNumberCodeCode
					, [Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeName] = @PayerResponsibilitySequenceNumberCodeName
					, [Transaction].[PayerResponsibilitySequenceNumberCode].[Comment] = @Comment
					, [Transaction].[PayerResponsibilitySequenceNumberCode].[LastModifiedBy] = @CurrentModificationBy
					, [Transaction].[PayerResponsibilitySequenceNumberCode].[LastModifiedOn] = @CurrentModificationOn
					, [Transaction].[PayerResponsibilitySequenceNumberCode].[IsActive] = @IsActive
				WHERE
					[Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeID] = @PayerResponsibilitySequenceNumberCodeID;				
			END
			ELSE
			BEGIN
				SELECT @PayerResponsibilitySequenceNumberCodeID = -2;
			END
		END
		ELSE IF @PayerResponsibilitySequenceNumberCodeID_PREV <> @PayerResponsibilitySequenceNumberCodeID
		BEGIN			
			SELECT @PayerResponsibilitySequenceNumberCodeID = -1;			
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
			SELECT @PayerResponsibilitySequenceNumberCodeID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
