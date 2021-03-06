USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_Update_PrintSign]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_Update_PrintSign]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the PrintSign in the database.
	 
CREATE PROCEDURE [EDI].[usp_Update_PrintSign]
	@PrintSignCode NVARCHAR(2)
	, @PrintSignName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @PrintSignID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @PrintSignID_PREV BIGINT;
		SELECT @PrintSignID_PREV = [EDI].[ufn_IsExists_PrintSign] (@PrintSignCode, @PrintSignName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [EDI].[PrintSign].[PrintSignID] FROM [EDI].[PrintSign] WHERE [EDI].[PrintSign].[PrintSignID] = @PrintSignID AND [EDI].[PrintSign].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@PrintSignID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [EDI].[PrintSign].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [EDI].[PrintSign].[LastModifiedOn]
			FROM 
				[EDI].[PrintSign] WITH (NOLOCK)
			WHERE
				[EDI].[PrintSign].[PrintSignID] = @PrintSignID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[EDI].[PrintSignHistory]
					(
						[PrintSignID]
						, [PrintSignCode]
						, [PrintSignName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[EDI].[PrintSign].[PrintSignID]
					, [EDI].[PrintSign].[PrintSignCode]
					, [EDI].[PrintSign].[PrintSignName]
					, [EDI].[PrintSign].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [EDI].[PrintSign].[IsActive]
				FROM 
					[EDI].[PrintSign]
				WHERE
					[EDI].[PrintSign].[PrintSignID] = @PrintSignID;
				
				UPDATE 
					[EDI].[PrintSign]
				SET
					[EDI].[PrintSign].[PrintSignCode] = @PrintSignCode
					, [EDI].[PrintSign].[PrintSignName] = @PrintSignName
					, [EDI].[PrintSign].[Comment] = @Comment
					, [EDI].[PrintSign].[LastModifiedBy] = @CurrentModificationBy
					, [EDI].[PrintSign].[LastModifiedOn] = @CurrentModificationOn
					, [EDI].[PrintSign].[IsActive] = @IsActive
				WHERE
					[EDI].[PrintSign].[PrintSignID] = @PrintSignID;				
			END
			ELSE
			BEGIN
				SELECT @PrintSignID = -2;
			END
		END
		ELSE IF @PrintSignID_PREV <> @PrintSignID
		BEGIN			
			SELECT @PrintSignID = -1;			
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
			SELECT @PrintSignID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
