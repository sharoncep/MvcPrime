USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_Update_Country]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_Update_Country]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Country in the database.
	 
CREATE PROCEDURE [MasterData].[usp_Update_Country]
	@CountryCode NVARCHAR(3)
	, @CountryName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @CountryID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @CountryID_PREV BIGINT;
		SELECT @CountryID_PREV = [MasterData].[ufn_IsExists_Country] (@CountryCode, @CountryName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [MasterData].[Country].[CountryID] FROM [MasterData].[Country] WHERE [MasterData].[Country].[CountryID] = @CountryID AND [MasterData].[Country].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@CountryID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [MasterData].[Country].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [MasterData].[Country].[LastModifiedOn]
			FROM 
				[MasterData].[Country] WITH (NOLOCK)
			WHERE
				[MasterData].[Country].[CountryID] = @CountryID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[MasterData].[CountryHistory]
					(
						[CountryID]
						, [CountryCode]
						, [CountryName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[MasterData].[Country].[CountryID]
					, [MasterData].[Country].[CountryCode]
					, [MasterData].[Country].[CountryName]
					, [MasterData].[Country].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [MasterData].[Country].[IsActive]
				FROM 
					[MasterData].[Country]
				WHERE
					[MasterData].[Country].[CountryID] = @CountryID;
				
				UPDATE 
					[MasterData].[Country]
				SET
					[MasterData].[Country].[CountryCode] = @CountryCode
					, [MasterData].[Country].[CountryName] = @CountryName
					, [MasterData].[Country].[Comment] = @Comment
					, [MasterData].[Country].[LastModifiedBy] = @CurrentModificationBy
					, [MasterData].[Country].[LastModifiedOn] = @CurrentModificationOn
					, [MasterData].[Country].[IsActive] = @IsActive
				WHERE
					[MasterData].[Country].[CountryID] = @CountryID;				
			END
			ELSE
			BEGIN
				SELECT @CountryID = -2;
			END
		END
		ELSE IF @CountryID_PREV <> @CountryID
		BEGIN			
			SELECT @CountryID = -1;			
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
			SELECT @CountryID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
