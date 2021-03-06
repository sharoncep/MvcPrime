USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_Insert_Relationship]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_Insert_Relationship]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Insurance].[usp_Insert_Relationship]
	@RelationshipCode NVARCHAR(2)
	, @RelationshipName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @RelationshipID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @RelationshipID = [Insurance].[ufn_IsExists_Relationship] (@RelationshipCode, @RelationshipName, @Comment, 0);
		
		IF @RelationshipID = 0
		BEGIN
			INSERT INTO [Insurance].[Relationship]
			(
				[RelationshipCode]
				, [RelationshipName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@RelationshipCode
				, @RelationshipName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @RelationshipID = MAX([Insurance].[Relationship].[RelationshipID]) FROM [Insurance].[Relationship];
		END
		ELSE
		BEGIN			
			SELECT @RelationshipID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @RelationshipID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
