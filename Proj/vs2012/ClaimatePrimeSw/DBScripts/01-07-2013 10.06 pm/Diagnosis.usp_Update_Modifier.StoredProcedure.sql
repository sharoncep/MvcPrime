USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_Update_Modifier]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_Update_Modifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Modifier in the database.
	 
CREATE PROCEDURE [Diagnosis].[usp_Update_Modifier]
	@ModifierCode NVARCHAR(2)
	, @ModifierName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @ModifierID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @ModifierID_PREV BIGINT;
		SELECT @ModifierID_PREV = [Diagnosis].[ufn_IsExists_Modifier] (@ModifierCode, @ModifierName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Diagnosis].[Modifier].[ModifierID] FROM [Diagnosis].[Modifier] WHERE [Diagnosis].[Modifier].[ModifierID] = @ModifierID AND [Diagnosis].[Modifier].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@ModifierID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Diagnosis].[Modifier].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Diagnosis].[Modifier].[LastModifiedOn]
			FROM 
				[Diagnosis].[Modifier] WITH (NOLOCK)
			WHERE
				[Diagnosis].[Modifier].[ModifierID] = @ModifierID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Diagnosis].[ModifierHistory]
					(
						[ModifierID]
						, [ModifierCode]
						, [ModifierName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Diagnosis].[Modifier].[ModifierID]
					, [Diagnosis].[Modifier].[ModifierCode]
					, [Diagnosis].[Modifier].[ModifierName]
					, [Diagnosis].[Modifier].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Diagnosis].[Modifier].[IsActive]
				FROM 
					[Diagnosis].[Modifier]
				WHERE
					[Diagnosis].[Modifier].[ModifierID] = @ModifierID;
				
				UPDATE 
					[Diagnosis].[Modifier]
				SET
					[Diagnosis].[Modifier].[ModifierCode] = @ModifierCode
					, [Diagnosis].[Modifier].[ModifierName] = @ModifierName
					, [Diagnosis].[Modifier].[Comment] = @Comment
					, [Diagnosis].[Modifier].[LastModifiedBy] = @CurrentModificationBy
					, [Diagnosis].[Modifier].[LastModifiedOn] = @CurrentModificationOn
					, [Diagnosis].[Modifier].[IsActive] = @IsActive
				WHERE
					[Diagnosis].[Modifier].[ModifierID] = @ModifierID;				
			END
			ELSE
			BEGIN
				SELECT @ModifierID = -2;
			END
		END
		ELSE IF @ModifierID_PREV <> @ModifierID
		BEGIN			
			SELECT @ModifierID = -1;			
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
			SELECT @ModifierID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
