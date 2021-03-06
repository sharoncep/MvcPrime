USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_Update_ClaimProcessEDIFile]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_Update_ClaimProcessEDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the ClaimProcessEDIFile in the database.
	 
CREATE PROCEDURE [Claim].[usp_Update_ClaimProcessEDIFile]
	@ClaimProcessID BIGINT
	, @EDIFileID INT
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @ClaimProcessEDIFileID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @ClaimProcessEDIFileID_PREV BIGINT;
		SELECT @ClaimProcessEDIFileID_PREV = [Claim].[ufn_IsExists_ClaimProcessEDIFile] (@ClaimProcessID, @EDIFileID, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Claim].[ClaimProcessEDIFile].[ClaimProcessEDIFileID] FROM [Claim].[ClaimProcessEDIFile] WHERE [Claim].[ClaimProcessEDIFile].[ClaimProcessEDIFileID] = @ClaimProcessEDIFileID AND [Claim].[ClaimProcessEDIFile].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@ClaimProcessEDIFileID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Claim].[ClaimProcessEDIFile].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Claim].[ClaimProcessEDIFile].[LastModifiedOn]
			FROM 
				[Claim].[ClaimProcessEDIFile] WITH (NOLOCK)
			WHERE
				[Claim].[ClaimProcessEDIFile].[ClaimProcessEDIFileID] = @ClaimProcessEDIFileID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Claim].[ClaimProcessEDIFileHistory]
					(
						[ClaimProcessEDIFileID]
						, [ClaimProcessID]
						, [EDIFileID]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Claim].[ClaimProcessEDIFile].[ClaimProcessEDIFileID]
					, [Claim].[ClaimProcessEDIFile].[ClaimProcessID]
					, [Claim].[ClaimProcessEDIFile].[EDIFileID]
					, [Claim].[ClaimProcessEDIFile].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Claim].[ClaimProcessEDIFile].[IsActive]
				FROM 
					[Claim].[ClaimProcessEDIFile]
				WHERE
					[Claim].[ClaimProcessEDIFile].[ClaimProcessEDIFileID] = @ClaimProcessEDIFileID;
				
				UPDATE 
					[Claim].[ClaimProcessEDIFile]
				SET
					[Claim].[ClaimProcessEDIFile].[ClaimProcessID] = @ClaimProcessID
					, [Claim].[ClaimProcessEDIFile].[EDIFileID] = @EDIFileID
					, [Claim].[ClaimProcessEDIFile].[Comment] = @Comment
					, [Claim].[ClaimProcessEDIFile].[LastModifiedBy] = @CurrentModificationBy
					, [Claim].[ClaimProcessEDIFile].[LastModifiedOn] = @CurrentModificationOn
					, [Claim].[ClaimProcessEDIFile].[IsActive] = @IsActive
				WHERE
					[Claim].[ClaimProcessEDIFile].[ClaimProcessEDIFileID] = @ClaimProcessEDIFileID;				
			END
			ELSE
			BEGIN
				SELECT @ClaimProcessEDIFileID = -2;
			END
		END
		ELSE IF @ClaimProcessEDIFileID_PREV <> @ClaimProcessEDIFileID
		BEGIN			
			SELECT @ClaimProcessEDIFileID = -1;			
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
			SELECT @ClaimProcessEDIFileID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
