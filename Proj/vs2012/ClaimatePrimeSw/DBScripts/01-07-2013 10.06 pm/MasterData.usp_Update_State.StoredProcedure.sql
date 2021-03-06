USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_Update_State]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_Update_State]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the State in the database.
	 
CREATE PROCEDURE [MasterData].[usp_Update_State]
	@StateCode NVARCHAR(2)
	, @StateName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @StateID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @StateID_PREV BIGINT;
		SELECT @StateID_PREV = [MasterData].[ufn_IsExists_State] (@StateCode, @StateName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [MasterData].[State].[StateID] FROM [MasterData].[State] WHERE [MasterData].[State].[StateID] = @StateID AND [MasterData].[State].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@StateID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [MasterData].[State].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [MasterData].[State].[LastModifiedOn]
			FROM 
				[MasterData].[State] WITH (NOLOCK)
			WHERE
				[MasterData].[State].[StateID] = @StateID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[MasterData].[StateHistory]
					(
						[StateID]
						, [StateCode]
						, [StateName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[MasterData].[State].[StateID]
					, [MasterData].[State].[StateCode]
					, [MasterData].[State].[StateName]
					, [MasterData].[State].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [MasterData].[State].[IsActive]
				FROM 
					[MasterData].[State]
				WHERE
					[MasterData].[State].[StateID] = @StateID;
				
				UPDATE 
					[MasterData].[State]
				SET
					[MasterData].[State].[StateCode] = @StateCode
					, [MasterData].[State].[StateName] = @StateName
					, [MasterData].[State].[Comment] = @Comment
					, [MasterData].[State].[LastModifiedBy] = @CurrentModificationBy
					, [MasterData].[State].[LastModifiedOn] = @CurrentModificationOn
					, [MasterData].[State].[IsActive] = @IsActive
				WHERE
					[MasterData].[State].[StateID] = @StateID;				
			END
			ELSE
			BEGIN
				SELECT @StateID = -2;
			END
		END
		ELSE IF @StateID_PREV <> @StateID
		BEGIN			
			SELECT @StateID = -1;			
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
			SELECT @StateID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
