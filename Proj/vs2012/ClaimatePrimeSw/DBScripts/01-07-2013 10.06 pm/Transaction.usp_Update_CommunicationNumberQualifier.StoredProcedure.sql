USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Update_CommunicationNumberQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Update_CommunicationNumberQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the CommunicationNumberQualifier in the database.
	 
CREATE PROCEDURE [Transaction].[usp_Update_CommunicationNumberQualifier]
	@CommunicationNumberQualifierCode NVARCHAR(2)
	, @CommunicationNumberQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @CommunicationNumberQualifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @CommunicationNumberQualifierID_PREV BIGINT;
		SELECT @CommunicationNumberQualifierID_PREV = [Transaction].[ufn_IsExists_CommunicationNumberQualifier] (@CommunicationNumberQualifierCode, @CommunicationNumberQualifierName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierID] FROM [Transaction].[CommunicationNumberQualifier] WHERE [Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierID] = @CommunicationNumberQualifierID AND [Transaction].[CommunicationNumberQualifier].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@CommunicationNumberQualifierID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Transaction].[CommunicationNumberQualifier].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Transaction].[CommunicationNumberQualifier].[LastModifiedOn]
			FROM 
				[Transaction].[CommunicationNumberQualifier] WITH (NOLOCK)
			WHERE
				[Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierID] = @CommunicationNumberQualifierID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Transaction].[CommunicationNumberQualifierHistory]
					(
						[CommunicationNumberQualifierID]
						, [CommunicationNumberQualifierCode]
						, [CommunicationNumberQualifierName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierID]
					, [Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierCode]
					, [Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierName]
					, [Transaction].[CommunicationNumberQualifier].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Transaction].[CommunicationNumberQualifier].[IsActive]
				FROM 
					[Transaction].[CommunicationNumberQualifier]
				WHERE
					[Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierID] = @CommunicationNumberQualifierID;
				
				UPDATE 
					[Transaction].[CommunicationNumberQualifier]
				SET
					[Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierCode] = @CommunicationNumberQualifierCode
					, [Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierName] = @CommunicationNumberQualifierName
					, [Transaction].[CommunicationNumberQualifier].[Comment] = @Comment
					, [Transaction].[CommunicationNumberQualifier].[LastModifiedBy] = @CurrentModificationBy
					, [Transaction].[CommunicationNumberQualifier].[LastModifiedOn] = @CurrentModificationOn
					, [Transaction].[CommunicationNumberQualifier].[IsActive] = @IsActive
				WHERE
					[Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierID] = @CommunicationNumberQualifierID;				
			END
			ELSE
			BEGIN
				SELECT @CommunicationNumberQualifierID = -2;
			END
		END
		ELSE IF @CommunicationNumberQualifierID_PREV <> @CommunicationNumberQualifierID
		BEGIN			
			SELECT @CommunicationNumberQualifierID = -1;			
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
			SELECT @CommunicationNumberQualifierID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
