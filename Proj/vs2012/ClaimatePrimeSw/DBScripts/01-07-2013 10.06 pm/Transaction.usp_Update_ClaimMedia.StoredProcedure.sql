USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Update_ClaimMedia]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Update_ClaimMedia]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the ClaimMedia in the database.
	 
CREATE PROCEDURE [Transaction].[usp_Update_ClaimMedia]
	@ClaimMediaCode NVARCHAR(15)
	, @ClaimMediaName NVARCHAR(150)
	, @MaxDiagnosis TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @ClaimMediaID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @ClaimMediaID_PREV BIGINT;
		SELECT @ClaimMediaID_PREV = [Transaction].[ufn_IsExists_ClaimMedia] (@ClaimMediaCode, @ClaimMediaName, @MaxDiagnosis, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Transaction].[ClaimMedia].[ClaimMediaID] FROM [Transaction].[ClaimMedia] WHERE [Transaction].[ClaimMedia].[ClaimMediaID] = @ClaimMediaID AND [Transaction].[ClaimMedia].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@ClaimMediaID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Transaction].[ClaimMedia].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Transaction].[ClaimMedia].[LastModifiedOn]
			FROM 
				[Transaction].[ClaimMedia] WITH (NOLOCK)
			WHERE
				[Transaction].[ClaimMedia].[ClaimMediaID] = @ClaimMediaID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Transaction].[ClaimMediaHistory]
					(
						[ClaimMediaID]
						, [ClaimMediaCode]
						, [ClaimMediaName]
						, [MaxDiagnosis]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Transaction].[ClaimMedia].[ClaimMediaID]
					, [Transaction].[ClaimMedia].[ClaimMediaCode]
					, [Transaction].[ClaimMedia].[ClaimMediaName]
					, [Transaction].[ClaimMedia].[MaxDiagnosis]
					, [Transaction].[ClaimMedia].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Transaction].[ClaimMedia].[IsActive]
				FROM 
					[Transaction].[ClaimMedia]
				WHERE
					[Transaction].[ClaimMedia].[ClaimMediaID] = @ClaimMediaID;
				
				UPDATE 
					[Transaction].[ClaimMedia]
				SET
					[Transaction].[ClaimMedia].[ClaimMediaCode] = @ClaimMediaCode
					, [Transaction].[ClaimMedia].[ClaimMediaName] = @ClaimMediaName
					, [Transaction].[ClaimMedia].[MaxDiagnosis] = @MaxDiagnosis
					, [Transaction].[ClaimMedia].[Comment] = @Comment
					, [Transaction].[ClaimMedia].[LastModifiedBy] = @CurrentModificationBy
					, [Transaction].[ClaimMedia].[LastModifiedOn] = @CurrentModificationOn
					, [Transaction].[ClaimMedia].[IsActive] = @IsActive
				WHERE
					[Transaction].[ClaimMedia].[ClaimMediaID] = @ClaimMediaID;				
			END
			ELSE
			BEGIN
				SELECT @ClaimMediaID = -2;
			END
		END
		ELSE IF @ClaimMediaID_PREV <> @ClaimMediaID
		BEGIN			
			SELECT @ClaimMediaID = -1;			
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
			SELECT @ClaimMediaID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
