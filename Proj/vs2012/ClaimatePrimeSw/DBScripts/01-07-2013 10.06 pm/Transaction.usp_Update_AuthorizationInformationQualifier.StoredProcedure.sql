USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Update_AuthorizationInformationQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Update_AuthorizationInformationQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the AuthorizationInformationQualifier in the database.
	 
CREATE PROCEDURE [Transaction].[usp_Update_AuthorizationInformationQualifier]
	@AuthorizationInformationQualifierCode NVARCHAR(2)
	, @AuthorizationInformationQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @AuthorizationInformationQualifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @AuthorizationInformationQualifierID_PREV BIGINT;
		SELECT @AuthorizationInformationQualifierID_PREV = [Transaction].[ufn_IsExists_AuthorizationInformationQualifier] (@AuthorizationInformationQualifierCode, @AuthorizationInformationQualifierName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID] FROM [Transaction].[AuthorizationInformationQualifier] WHERE [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID] = @AuthorizationInformationQualifierID AND [Transaction].[AuthorizationInformationQualifier].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@AuthorizationInformationQualifierID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Transaction].[AuthorizationInformationQualifier].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Transaction].[AuthorizationInformationQualifier].[LastModifiedOn]
			FROM 
				[Transaction].[AuthorizationInformationQualifier] WITH (NOLOCK)
			WHERE
				[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID] = @AuthorizationInformationQualifierID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Transaction].[AuthorizationInformationQualifierHistory]
					(
						[AuthorizationInformationQualifierID]
						, [AuthorizationInformationQualifierCode]
						, [AuthorizationInformationQualifierName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID]
					, [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode]
					, [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierName]
					, [Transaction].[AuthorizationInformationQualifier].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Transaction].[AuthorizationInformationQualifier].[IsActive]
				FROM 
					[Transaction].[AuthorizationInformationQualifier]
				WHERE
					[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID] = @AuthorizationInformationQualifierID;
				
				UPDATE 
					[Transaction].[AuthorizationInformationQualifier]
				SET
					[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode] = @AuthorizationInformationQualifierCode
					, [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierName] = @AuthorizationInformationQualifierName
					, [Transaction].[AuthorizationInformationQualifier].[Comment] = @Comment
					, [Transaction].[AuthorizationInformationQualifier].[LastModifiedBy] = @CurrentModificationBy
					, [Transaction].[AuthorizationInformationQualifier].[LastModifiedOn] = @CurrentModificationOn
					, [Transaction].[AuthorizationInformationQualifier].[IsActive] = @IsActive
				WHERE
					[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID] = @AuthorizationInformationQualifierID;				
			END
			ELSE
			BEGIN
				SELECT @AuthorizationInformationQualifierID = -2;
			END
		END
		ELSE IF @AuthorizationInformationQualifierID_PREV <> @AuthorizationInformationQualifierID
		BEGIN			
			SELECT @AuthorizationInformationQualifierID = -1;			
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
			SELECT @AuthorizationInformationQualifierID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
