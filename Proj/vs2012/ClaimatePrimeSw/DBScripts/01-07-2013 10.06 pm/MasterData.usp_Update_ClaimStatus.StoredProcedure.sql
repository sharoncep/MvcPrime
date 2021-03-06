USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_Update_ClaimStatus]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_Update_ClaimStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the ClaimStatus in the database.
	 
CREATE PROCEDURE [MasterData].[usp_Update_ClaimStatus]
	@ClaimStatusCode NVARCHAR(2)
	, @ClaimStatusName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @ClaimStatusID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @ClaimStatusID_PREV BIGINT;
		SELECT @ClaimStatusID_PREV = [MasterData].[ufn_IsExists_ClaimStatus] (@ClaimStatusCode, @ClaimStatusName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [MasterData].[ClaimStatus].[ClaimStatusID] FROM [MasterData].[ClaimStatus] WHERE [MasterData].[ClaimStatus].[ClaimStatusID] = @ClaimStatusID AND [MasterData].[ClaimStatus].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@ClaimStatusID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [MasterData].[ClaimStatus].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [MasterData].[ClaimStatus].[LastModifiedOn]
			FROM 
				[MasterData].[ClaimStatus] WITH (NOLOCK)
			WHERE
				[MasterData].[ClaimStatus].[ClaimStatusID] = @ClaimStatusID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[MasterData].[ClaimStatusHistory]
					(
						[ClaimStatusID]
						, [ClaimStatusCode]
						, [ClaimStatusName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[MasterData].[ClaimStatus].[ClaimStatusID]
					, [MasterData].[ClaimStatus].[ClaimStatusCode]
					, [MasterData].[ClaimStatus].[ClaimStatusName]
					, [MasterData].[ClaimStatus].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [MasterData].[ClaimStatus].[IsActive]
				FROM 
					[MasterData].[ClaimStatus]
				WHERE
					[MasterData].[ClaimStatus].[ClaimStatusID] = @ClaimStatusID;
				
				UPDATE 
					[MasterData].[ClaimStatus]
				SET
					[MasterData].[ClaimStatus].[ClaimStatusCode] = @ClaimStatusCode
					, [MasterData].[ClaimStatus].[ClaimStatusName] = @ClaimStatusName
					, [MasterData].[ClaimStatus].[Comment] = @Comment
					, [MasterData].[ClaimStatus].[LastModifiedBy] = @CurrentModificationBy
					, [MasterData].[ClaimStatus].[LastModifiedOn] = @CurrentModificationOn
					, [MasterData].[ClaimStatus].[IsActive] = @IsActive
				WHERE
					[MasterData].[ClaimStatus].[ClaimStatusID] = @ClaimStatusID;				
			END
			ELSE
			BEGIN
				SELECT @ClaimStatusID = -2;
			END
		END
		ELSE IF @ClaimStatusID_PREV <> @ClaimStatusID
		BEGIN			
			SELECT @ClaimStatusID = -1;			
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
			SELECT @ClaimStatusID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
