USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Insert_AuthorizationInformationQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Insert_AuthorizationInformationQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Transaction].[usp_Insert_AuthorizationInformationQualifier]
	@AuthorizationInformationQualifierCode NVARCHAR(2)
	, @AuthorizationInformationQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @AuthorizationInformationQualifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @AuthorizationInformationQualifierID = [Transaction].[ufn_IsExists_AuthorizationInformationQualifier] (@AuthorizationInformationQualifierCode, @AuthorizationInformationQualifierName, @Comment, 0);
		
		IF @AuthorizationInformationQualifierID = 0
		BEGIN
			INSERT INTO [Transaction].[AuthorizationInformationQualifier]
			(
				[AuthorizationInformationQualifierCode]
				, [AuthorizationInformationQualifierName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@AuthorizationInformationQualifierCode
				, @AuthorizationInformationQualifierName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @AuthorizationInformationQualifierID = MAX([Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID]) FROM [Transaction].[AuthorizationInformationQualifier];
		END
		ELSE
		BEGIN			
			SELECT @AuthorizationInformationQualifierID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @AuthorizationInformationQualifierID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
