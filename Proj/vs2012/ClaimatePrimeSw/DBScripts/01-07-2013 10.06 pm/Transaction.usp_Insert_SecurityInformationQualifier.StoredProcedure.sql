USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Insert_SecurityInformationQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Insert_SecurityInformationQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Transaction].[usp_Insert_SecurityInformationQualifier]
	@SecurityInformationQualifierCode NVARCHAR(2)
	, @SecurityInformationQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @SecurityInformationQualifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @SecurityInformationQualifierID = [Transaction].[ufn_IsExists_SecurityInformationQualifier] (@SecurityInformationQualifierCode, @SecurityInformationQualifierName, @Comment, 0);
		
		IF @SecurityInformationQualifierID = 0
		BEGIN
			INSERT INTO [Transaction].[SecurityInformationQualifier]
			(
				[SecurityInformationQualifierCode]
				, [SecurityInformationQualifierName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@SecurityInformationQualifierCode
				, @SecurityInformationQualifierName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @SecurityInformationQualifierID = MAX([Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierID]) FROM [Transaction].[SecurityInformationQualifier];
		END
		ELSE
		BEGIN			
			SELECT @SecurityInformationQualifierID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @SecurityInformationQualifierID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
