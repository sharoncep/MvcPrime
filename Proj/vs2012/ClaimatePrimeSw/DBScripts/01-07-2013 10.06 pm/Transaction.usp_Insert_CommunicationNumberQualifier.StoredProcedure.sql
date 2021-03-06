USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Insert_CommunicationNumberQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Insert_CommunicationNumberQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Transaction].[usp_Insert_CommunicationNumberQualifier]
	@CommunicationNumberQualifierCode NVARCHAR(2)
	, @CommunicationNumberQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @CommunicationNumberQualifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @CommunicationNumberQualifierID = [Transaction].[ufn_IsExists_CommunicationNumberQualifier] (@CommunicationNumberQualifierCode, @CommunicationNumberQualifierName, @Comment, 0);
		
		IF @CommunicationNumberQualifierID = 0
		BEGIN
			INSERT INTO [Transaction].[CommunicationNumberQualifier]
			(
				[CommunicationNumberQualifierCode]
				, [CommunicationNumberQualifierName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@CommunicationNumberQualifierCode
				, @CommunicationNumberQualifierName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @CommunicationNumberQualifierID = MAX([Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierID]) FROM [Transaction].[CommunicationNumberQualifier];
		END
		ELSE
		BEGIN			
			SELECT @CommunicationNumberQualifierID = -1;
		END		
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
