USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Update_EntityTypeQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Update_EntityTypeQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the EntityTypeQualifier in the database.
	 
CREATE PROCEDURE [Transaction].[usp_Update_EntityTypeQualifier]
	@EntityTypeQualifierCode NVARCHAR(1)
	, @EntityTypeQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @EntityTypeQualifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @EntityTypeQualifierID_PREV BIGINT;
		SELECT @EntityTypeQualifierID_PREV = [Transaction].[ufn_IsExists_EntityTypeQualifier] (@EntityTypeQualifierCode, @EntityTypeQualifierName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Transaction].[EntityTypeQualifier].[EntityTypeQualifierID] FROM [Transaction].[EntityTypeQualifier] WHERE [Transaction].[EntityTypeQualifier].[EntityTypeQualifierID] = @EntityTypeQualifierID AND [Transaction].[EntityTypeQualifier].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@EntityTypeQualifierID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Transaction].[EntityTypeQualifier].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Transaction].[EntityTypeQualifier].[LastModifiedOn]
			FROM 
				[Transaction].[EntityTypeQualifier] WITH (NOLOCK)
			WHERE
				[Transaction].[EntityTypeQualifier].[EntityTypeQualifierID] = @EntityTypeQualifierID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Transaction].[EntityTypeQualifierHistory]
					(
						[EntityTypeQualifierID]
						, [EntityTypeQualifierCode]
						, [EntityTypeQualifierName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Transaction].[EntityTypeQualifier].[EntityTypeQualifierID]
					, [Transaction].[EntityTypeQualifier].[EntityTypeQualifierCode]
					, [Transaction].[EntityTypeQualifier].[EntityTypeQualifierName]
					, [Transaction].[EntityTypeQualifier].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Transaction].[EntityTypeQualifier].[IsActive]
				FROM 
					[Transaction].[EntityTypeQualifier]
				WHERE
					[Transaction].[EntityTypeQualifier].[EntityTypeQualifierID] = @EntityTypeQualifierID;
				
				UPDATE 
					[Transaction].[EntityTypeQualifier]
				SET
					[Transaction].[EntityTypeQualifier].[EntityTypeQualifierCode] = @EntityTypeQualifierCode
					, [Transaction].[EntityTypeQualifier].[EntityTypeQualifierName] = @EntityTypeQualifierName
					, [Transaction].[EntityTypeQualifier].[Comment] = @Comment
					, [Transaction].[EntityTypeQualifier].[LastModifiedBy] = @CurrentModificationBy
					, [Transaction].[EntityTypeQualifier].[LastModifiedOn] = @CurrentModificationOn
					, [Transaction].[EntityTypeQualifier].[IsActive] = @IsActive
				WHERE
					[Transaction].[EntityTypeQualifier].[EntityTypeQualifierID] = @EntityTypeQualifierID;				
			END
			ELSE
			BEGIN
				SELECT @EntityTypeQualifierID = -2;
			END
		END
		ELSE IF @EntityTypeQualifierID_PREV <> @EntityTypeQualifierID
		BEGIN			
			SELECT @EntityTypeQualifierID = -1;			
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
			SELECT @EntityTypeQualifierID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
