USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Update_InterchangeIDQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Update_InterchangeIDQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the InterchangeIDQualifier in the database.
	 
CREATE PROCEDURE [Transaction].[usp_Update_InterchangeIDQualifier]
	@InterchangeIDQualifierCode NVARCHAR(2)
	, @InterchangeIDQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @InterchangeIDQualifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @InterchangeIDQualifierID_PREV BIGINT;
		SELECT @InterchangeIDQualifierID_PREV = [Transaction].[ufn_IsExists_InterchangeIDQualifier] (@InterchangeIDQualifierCode, @InterchangeIDQualifierName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierID] FROM [Transaction].[InterchangeIDQualifier] WHERE [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierID] = @InterchangeIDQualifierID AND [Transaction].[InterchangeIDQualifier].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@InterchangeIDQualifierID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Transaction].[InterchangeIDQualifier].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Transaction].[InterchangeIDQualifier].[LastModifiedOn]
			FROM 
				[Transaction].[InterchangeIDQualifier] WITH (NOLOCK)
			WHERE
				[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierID] = @InterchangeIDQualifierID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Transaction].[InterchangeIDQualifierHistory]
					(
						[InterchangeIDQualifierID]
						, [InterchangeIDQualifierCode]
						, [InterchangeIDQualifierName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierID]
					, [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode]
					, [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName]
					, [Transaction].[InterchangeIDQualifier].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Transaction].[InterchangeIDQualifier].[IsActive]
				FROM 
					[Transaction].[InterchangeIDQualifier]
				WHERE
					[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierID] = @InterchangeIDQualifierID;
				
				UPDATE 
					[Transaction].[InterchangeIDQualifier]
				SET
					[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] = @InterchangeIDQualifierCode
					, [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] = @InterchangeIDQualifierName
					, [Transaction].[InterchangeIDQualifier].[Comment] = @Comment
					, [Transaction].[InterchangeIDQualifier].[LastModifiedBy] = @CurrentModificationBy
					, [Transaction].[InterchangeIDQualifier].[LastModifiedOn] = @CurrentModificationOn
					, [Transaction].[InterchangeIDQualifier].[IsActive] = @IsActive
				WHERE
					[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierID] = @InterchangeIDQualifierID;				
			END
			ELSE
			BEGIN
				SELECT @InterchangeIDQualifierID = -2;
			END
		END
		ELSE IF @InterchangeIDQualifierID_PREV <> @InterchangeIDQualifierID
		BEGIN			
			SELECT @InterchangeIDQualifierID = -1;			
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
			SELECT @InterchangeIDQualifierID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
