USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Update_SecurityInformationQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Update_SecurityInformationQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the SecurityInformationQualifier in the database.
	 
CREATE PROCEDURE [Transaction].[usp_Update_SecurityInformationQualifier]
	@SecurityInformationQualifierCode NVARCHAR(2)
	, @SecurityInformationQualifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @SecurityInformationQualifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @SecurityInformationQualifierID_PREV BIGINT;
		SELECT @SecurityInformationQualifierID_PREV = [Transaction].[ufn_IsExists_SecurityInformationQualifier] (@SecurityInformationQualifierCode, @SecurityInformationQualifierName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierID] FROM [Transaction].[SecurityInformationQualifier] WHERE [Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierID] = @SecurityInformationQualifierID AND [Transaction].[SecurityInformationQualifier].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@SecurityInformationQualifierID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Transaction].[SecurityInformationQualifier].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Transaction].[SecurityInformationQualifier].[LastModifiedOn]
			FROM 
				[Transaction].[SecurityInformationQualifier] WITH (NOLOCK)
			WHERE
				[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierID] = @SecurityInformationQualifierID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Transaction].[SecurityInformationQualifierHistory]
					(
						[SecurityInformationQualifierID]
						, [SecurityInformationQualifierCode]
						, [SecurityInformationQualifierName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierID]
					, [Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierCode]
					, [Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierName]
					, [Transaction].[SecurityInformationQualifier].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Transaction].[SecurityInformationQualifier].[IsActive]
				FROM 
					[Transaction].[SecurityInformationQualifier]
				WHERE
					[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierID] = @SecurityInformationQualifierID;
				
				UPDATE 
					[Transaction].[SecurityInformationQualifier]
				SET
					[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierCode] = @SecurityInformationQualifierCode
					, [Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierName] = @SecurityInformationQualifierName
					, [Transaction].[SecurityInformationQualifier].[Comment] = @Comment
					, [Transaction].[SecurityInformationQualifier].[LastModifiedBy] = @CurrentModificationBy
					, [Transaction].[SecurityInformationQualifier].[LastModifiedOn] = @CurrentModificationOn
					, [Transaction].[SecurityInformationQualifier].[IsActive] = @IsActive
				WHERE
					[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierID] = @SecurityInformationQualifierID;				
			END
			ELSE
			BEGIN
				SELECT @SecurityInformationQualifierID = -2;
			END
		END
		ELSE IF @SecurityInformationQualifierID_PREV <> @SecurityInformationQualifierID
		BEGIN			
			SELECT @SecurityInformationQualifierID = -1;			
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
			SELECT @SecurityInformationQualifierID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
