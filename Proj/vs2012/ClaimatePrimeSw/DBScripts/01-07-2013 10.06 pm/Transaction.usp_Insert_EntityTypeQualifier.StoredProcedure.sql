USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Insert_EntityTypeQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Insert_EntityTypeQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Transaction].[usp_Insert_EntityTypeQualifier]
	@EntityTypeQualifierCode NVARCHAR(1)
	, @EntityTypeQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @EntityTypeQualifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @EntityTypeQualifierID = [Transaction].[ufn_IsExists_EntityTypeQualifier] (@EntityTypeQualifierCode, @EntityTypeQualifierName, @Comment, 0);
		
		IF @EntityTypeQualifierID = 0
		BEGIN
			INSERT INTO [Transaction].[EntityTypeQualifier]
			(
				[EntityTypeQualifierCode]
				, [EntityTypeQualifierName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@EntityTypeQualifierCode
				, @EntityTypeQualifierName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @EntityTypeQualifierID = MAX([Transaction].[EntityTypeQualifier].[EntityTypeQualifierID]) FROM [Transaction].[EntityTypeQualifier];
		END
		ELSE
		BEGIN			
			SELECT @EntityTypeQualifierID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @EntityTypeQualifierID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
