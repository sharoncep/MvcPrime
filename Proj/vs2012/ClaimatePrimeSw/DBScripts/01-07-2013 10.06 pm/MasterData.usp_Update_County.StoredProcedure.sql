USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_Update_County]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_Update_County]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the County in the database.
	 
CREATE PROCEDURE [MasterData].[usp_Update_County]
	@CountyCode NVARCHAR(6)
	, @CountyName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @CountyID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @CountyID_PREV BIGINT;
		SELECT @CountyID_PREV = [MasterData].[ufn_IsExists_County] (@CountyCode, @CountyName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [MasterData].[County].[CountyID] FROM [MasterData].[County] WHERE [MasterData].[County].[CountyID] = @CountyID AND [MasterData].[County].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@CountyID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [MasterData].[County].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [MasterData].[County].[LastModifiedOn]
			FROM 
				[MasterData].[County] WITH (NOLOCK)
			WHERE
				[MasterData].[County].[CountyID] = @CountyID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[MasterData].[CountyHistory]
					(
						[CountyID]
						, [CountyCode]
						, [CountyName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[MasterData].[County].[CountyID]
					, [MasterData].[County].[CountyCode]
					, [MasterData].[County].[CountyName]
					, [MasterData].[County].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [MasterData].[County].[IsActive]
				FROM 
					[MasterData].[County]
				WHERE
					[MasterData].[County].[CountyID] = @CountyID;
				
				UPDATE 
					[MasterData].[County]
				SET
					[MasterData].[County].[CountyCode] = @CountyCode
					, [MasterData].[County].[CountyName] = @CountyName
					, [MasterData].[County].[Comment] = @Comment
					, [MasterData].[County].[LastModifiedBy] = @CurrentModificationBy
					, [MasterData].[County].[LastModifiedOn] = @CurrentModificationOn
					, [MasterData].[County].[IsActive] = @IsActive
				WHERE
					[MasterData].[County].[CountyID] = @CountyID;				
			END
			ELSE
			BEGIN
				SELECT @CountyID = -2;
			END
		END
		ELSE IF @CountyID_PREV <> @CountyID
		BEGIN			
			SELECT @CountyID = -1;			
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
			SELECT @CountyID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
