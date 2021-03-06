USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Update_EntityIdentifierCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Update_EntityIdentifierCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the EntityIdentifierCode in the database.
	 
CREATE PROCEDURE [Transaction].[usp_Update_EntityIdentifierCode]
	@EntityIdentifierCodeCode NVARCHAR(2)
	, @EntityIdentifierCodeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @EntityIdentifierCodeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @EntityIdentifierCodeID_PREV BIGINT;
		SELECT @EntityIdentifierCodeID_PREV = [Transaction].[ufn_IsExists_EntityIdentifierCode] (@EntityIdentifierCodeCode, @EntityIdentifierCodeName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeID] FROM [Transaction].[EntityIdentifierCode] WHERE [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeID] = @EntityIdentifierCodeID AND [Transaction].[EntityIdentifierCode].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@EntityIdentifierCodeID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Transaction].[EntityIdentifierCode].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Transaction].[EntityIdentifierCode].[LastModifiedOn]
			FROM 
				[Transaction].[EntityIdentifierCode] WITH (NOLOCK)
			WHERE
				[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeID] = @EntityIdentifierCodeID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Transaction].[EntityIdentifierCodeHistory]
					(
						[EntityIdentifierCodeID]
						, [EntityIdentifierCodeCode]
						, [EntityIdentifierCodeName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeID]
					, [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeCode]
					, [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeName]
					, [Transaction].[EntityIdentifierCode].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Transaction].[EntityIdentifierCode].[IsActive]
				FROM 
					[Transaction].[EntityIdentifierCode]
				WHERE
					[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeID] = @EntityIdentifierCodeID;
				
				UPDATE 
					[Transaction].[EntityIdentifierCode]
				SET
					[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeCode] = @EntityIdentifierCodeCode
					, [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeName] = @EntityIdentifierCodeName
					, [Transaction].[EntityIdentifierCode].[Comment] = @Comment
					, [Transaction].[EntityIdentifierCode].[LastModifiedBy] = @CurrentModificationBy
					, [Transaction].[EntityIdentifierCode].[LastModifiedOn] = @CurrentModificationOn
					, [Transaction].[EntityIdentifierCode].[IsActive] = @IsActive
				WHERE
					[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeID] = @EntityIdentifierCodeID;				
			END
			ELSE
			BEGIN
				SELECT @EntityIdentifierCodeID = -2;
			END
		END
		ELSE IF @EntityIdentifierCodeID_PREV <> @EntityIdentifierCodeID
		BEGIN			
			SELECT @EntityIdentifierCodeID = -1;			
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
			SELECT @EntityIdentifierCodeID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
