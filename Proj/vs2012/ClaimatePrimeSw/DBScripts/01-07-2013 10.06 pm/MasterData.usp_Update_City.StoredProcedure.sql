USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_Update_City]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_Update_City]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the City in the database.
	 
CREATE PROCEDURE [MasterData].[usp_Update_City]
	@CityCode NVARCHAR(5)
	, @ZipCode NVARCHAR(10)
	, @CityName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @CityID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @CityID_PREV BIGINT;
		SELECT @CityID_PREV = [MasterData].[ufn_IsExists_City] (@CityCode, @ZipCode, @CityName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [MasterData].[City].[CityID] FROM [MasterData].[City] WHERE [MasterData].[City].[CityID] = @CityID AND [MasterData].[City].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@CityID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [MasterData].[City].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [MasterData].[City].[LastModifiedOn]
			FROM 
				[MasterData].[City] WITH (NOLOCK)
			WHERE
				[MasterData].[City].[CityID] = @CityID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[MasterData].[CityHistory]
					(
						[CityID]
						, [CityCode]
						, [ZipCode]
						, [CityName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[MasterData].[City].[CityID]
					, [MasterData].[City].[CityCode]
					, [MasterData].[City].[ZipCode]
					, [MasterData].[City].[CityName]
					, [MasterData].[City].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [MasterData].[City].[IsActive]
				FROM 
					[MasterData].[City]
				WHERE
					[MasterData].[City].[CityID] = @CityID;
				
				UPDATE 
					[MasterData].[City]
				SET
					[MasterData].[City].[CityCode] = @CityCode
					, [MasterData].[City].[ZipCode] = @ZipCode
					, [MasterData].[City].[CityName] = @CityName
					, [MasterData].[City].[Comment] = @Comment
					, [MasterData].[City].[LastModifiedBy] = @CurrentModificationBy
					, [MasterData].[City].[LastModifiedOn] = @CurrentModificationOn
					, [MasterData].[City].[IsActive] = @IsActive
				WHERE
					[MasterData].[City].[CityID] = @CityID;				
			END
			ELSE
			BEGIN
				SELECT @CityID = -2;
			END
		END
		ELSE IF @CityID_PREV <> @CityID
		BEGIN			
			SELECT @CityID = -1;			
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
			SELECT @CityID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
