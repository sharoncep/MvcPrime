USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Insert_InterchangeIDQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Insert_InterchangeIDQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Transaction].[usp_Insert_InterchangeIDQualifier]
	@InterchangeIDQualifierCode NVARCHAR(2)
	, @InterchangeIDQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @InterchangeIDQualifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @InterchangeIDQualifierID = [Transaction].[ufn_IsExists_InterchangeIDQualifier] (@InterchangeIDQualifierCode, @InterchangeIDQualifierName, @Comment, 0);
		
		IF @InterchangeIDQualifierID = 0
		BEGIN
			INSERT INTO [Transaction].[InterchangeIDQualifier]
			(
				[InterchangeIDQualifierCode]
				, [InterchangeIDQualifierName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@InterchangeIDQualifierCode
				, @InterchangeIDQualifierName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @InterchangeIDQualifierID = MAX([Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierID]) FROM [Transaction].[InterchangeIDQualifier];
		END
		ELSE
		BEGIN			
			SELECT @InterchangeIDQualifierID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @InterchangeIDQualifierID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
