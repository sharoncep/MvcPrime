USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Insert_EntityIdentifierCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Insert_EntityIdentifierCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Transaction].[usp_Insert_EntityIdentifierCode]
	@EntityIdentifierCodeCode NVARCHAR(2)
	, @EntityIdentifierCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @EntityIdentifierCodeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @EntityIdentifierCodeID = [Transaction].[ufn_IsExists_EntityIdentifierCode] (@EntityIdentifierCodeCode, @EntityIdentifierCodeName, @Comment, 0);
		
		IF @EntityIdentifierCodeID = 0
		BEGIN
			INSERT INTO [Transaction].[EntityIdentifierCode]
			(
				[EntityIdentifierCodeCode]
				, [EntityIdentifierCodeName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@EntityIdentifierCodeCode
				, @EntityIdentifierCodeName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @EntityIdentifierCodeID = MAX([Transaction].[EntityIdentifierCode].[EntityIdentifierCodeID]) FROM [Transaction].[EntityIdentifierCode];
		END
		ELSE
		BEGIN			
			SELECT @EntityIdentifierCodeID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @EntityIdentifierCodeID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
