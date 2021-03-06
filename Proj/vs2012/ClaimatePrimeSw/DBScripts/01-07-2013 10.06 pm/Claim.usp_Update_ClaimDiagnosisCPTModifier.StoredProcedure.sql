USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_Update_ClaimDiagnosisCPTModifier]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_Update_ClaimDiagnosisCPTModifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the ClaimDiagnosisCPTModifier in the database.
	 
CREATE PROCEDURE [Claim].[usp_Update_ClaimDiagnosisCPTModifier]
	@ClaimDiagnosisCPTID BIGINT
	, @ModifierID INT
	, @ModifierLevel TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @ClaimDiagnosisCPTModifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @ClaimDiagnosisCPTModifierID_PREV BIGINT;
		SELECT @ClaimDiagnosisCPTModifierID_PREV = [Claim].[ufn_IsExists_ClaimDiagnosisCPTModifier] (@ClaimDiagnosisCPTID, @ModifierID, @ModifierLevel, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTModifierID] FROM [Claim].[ClaimDiagnosisCPTModifier] WHERE [Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTModifierID] = @ClaimDiagnosisCPTModifierID AND [Claim].[ClaimDiagnosisCPTModifier].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@ClaimDiagnosisCPTModifierID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Claim].[ClaimDiagnosisCPTModifier].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Claim].[ClaimDiagnosisCPTModifier].[LastModifiedOn]
			FROM 
				[Claim].[ClaimDiagnosisCPTModifier] WITH (NOLOCK)
			WHERE
				[Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTModifierID] = @ClaimDiagnosisCPTModifierID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Claim].[ClaimDiagnosisCPTModifierHistory]
					(
						[ClaimDiagnosisCPTModifierID]
						, [ClaimDiagnosisCPTID]
						, [ModifierID]
						, [ModifierLevel]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTModifierID]
					, [Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTID]
					, [Claim].[ClaimDiagnosisCPTModifier].[ModifierID]
					, [Claim].[ClaimDiagnosisCPTModifier].[ModifierLevel]
					, [Claim].[ClaimDiagnosisCPTModifier].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Claim].[ClaimDiagnosisCPTModifier].[IsActive]
				FROM 
					[Claim].[ClaimDiagnosisCPTModifier]
				WHERE
					[Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTModifierID] = @ClaimDiagnosisCPTModifierID;
				
				UPDATE 
					[Claim].[ClaimDiagnosisCPTModifier]
				SET
					[Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTID] = @ClaimDiagnosisCPTID
					, [Claim].[ClaimDiagnosisCPTModifier].[ModifierID] = @ModifierID
					, [Claim].[ClaimDiagnosisCPTModifier].[ModifierLevel] = @ModifierLevel
					, [Claim].[ClaimDiagnosisCPTModifier].[Comment] = @Comment
					, [Claim].[ClaimDiagnosisCPTModifier].[LastModifiedBy] = @CurrentModificationBy
					, [Claim].[ClaimDiagnosisCPTModifier].[LastModifiedOn] = @CurrentModificationOn
					, [Claim].[ClaimDiagnosisCPTModifier].[IsActive] = @IsActive
				WHERE
					[Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTModifierID] = @ClaimDiagnosisCPTModifierID;				
			END
			ELSE
			BEGIN
				SELECT @ClaimDiagnosisCPTModifierID = -2;
			END
		END
		ELSE IF @ClaimDiagnosisCPTModifierID_PREV <> @ClaimDiagnosisCPTModifierID
		BEGIN			
			SELECT @ClaimDiagnosisCPTModifierID = -1;			
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
			SELECT @ClaimDiagnosisCPTModifierID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
