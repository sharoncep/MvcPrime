USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_Update_Relationship]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_Update_Relationship]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Relationship in the database.
	 
CREATE PROCEDURE [Insurance].[usp_Update_Relationship]
	@RelationshipCode NVARCHAR(2)
	, @RelationshipName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @RelationshipID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @RelationshipID_PREV BIGINT;
		SELECT @RelationshipID_PREV = [Insurance].[ufn_IsExists_Relationship] (@RelationshipCode, @RelationshipName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Insurance].[Relationship].[RelationshipID] FROM [Insurance].[Relationship] WHERE [Insurance].[Relationship].[RelationshipID] = @RelationshipID AND [Insurance].[Relationship].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@RelationshipID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Insurance].[Relationship].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Insurance].[Relationship].[LastModifiedOn]
			FROM 
				[Insurance].[Relationship] WITH (NOLOCK)
			WHERE
				[Insurance].[Relationship].[RelationshipID] = @RelationshipID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Insurance].[RelationshipHistory]
					(
						[RelationshipID]
						, [RelationshipCode]
						, [RelationshipName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Insurance].[Relationship].[RelationshipID]
					, [Insurance].[Relationship].[RelationshipCode]
					, [Insurance].[Relationship].[RelationshipName]
					, [Insurance].[Relationship].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Insurance].[Relationship].[IsActive]
				FROM 
					[Insurance].[Relationship]
				WHERE
					[Insurance].[Relationship].[RelationshipID] = @RelationshipID;
				
				UPDATE 
					[Insurance].[Relationship]
				SET
					[Insurance].[Relationship].[RelationshipCode] = @RelationshipCode
					, [Insurance].[Relationship].[RelationshipName] = @RelationshipName
					, [Insurance].[Relationship].[Comment] = @Comment
					, [Insurance].[Relationship].[LastModifiedBy] = @CurrentModificationBy
					, [Insurance].[Relationship].[LastModifiedOn] = @CurrentModificationOn
					, [Insurance].[Relationship].[IsActive] = @IsActive
				WHERE
					[Insurance].[Relationship].[RelationshipID] = @RelationshipID;				
			END
			ELSE
			BEGIN
				SELECT @RelationshipID = -2;
			END
		END
		ELSE IF @RelationshipID_PREV <> @RelationshipID
		BEGIN			
			SELECT @RelationshipID = -1;			
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
			SELECT @RelationshipID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
