USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_Update_DiagnosisGroup]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_Update_DiagnosisGroup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the DiagnosisGroup in the database.
	 
CREATE PROCEDURE [Diagnosis].[usp_Update_DiagnosisGroup]
	@DiagnosisGroupCode NVARCHAR(9)
	, @DiagnosisGroupDescription NVARCHAR(150)
	, @Amount DECIMAL
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @DiagnosisGroupID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @DiagnosisGroupID_PREV BIGINT;
		SELECT @DiagnosisGroupID_PREV = [Diagnosis].[ufn_IsExists_DiagnosisGroup] (@DiagnosisGroupCode, @DiagnosisGroupDescription, @Amount, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] FROM [Diagnosis].[DiagnosisGroup] WHERE [Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = @DiagnosisGroupID AND [Diagnosis].[DiagnosisGroup].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@DiagnosisGroupID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Diagnosis].[DiagnosisGroup].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Diagnosis].[DiagnosisGroup].[LastModifiedOn]
			FROM 
				[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
			WHERE
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = @DiagnosisGroupID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Diagnosis].[DiagnosisGroupHistory]
					(
						[DiagnosisGroupID]
						, [DiagnosisGroupCode]
						, [DiagnosisGroupDescription]
						, [Amount]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID]
					, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode]
					, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription]
					, [Diagnosis].[DiagnosisGroup].[Amount]
					, [Diagnosis].[DiagnosisGroup].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Diagnosis].[DiagnosisGroup].[IsActive]
				FROM 
					[Diagnosis].[DiagnosisGroup]
				WHERE
					[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = @DiagnosisGroupID;
				
				UPDATE 
					[Diagnosis].[DiagnosisGroup]
				SET
					[Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] = @DiagnosisGroupCode
					, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] = @DiagnosisGroupDescription
					, [Diagnosis].[DiagnosisGroup].[Amount] = @Amount
					, [Diagnosis].[DiagnosisGroup].[Comment] = @Comment
					, [Diagnosis].[DiagnosisGroup].[LastModifiedBy] = @CurrentModificationBy
					, [Diagnosis].[DiagnosisGroup].[LastModifiedOn] = @CurrentModificationOn
					, [Diagnosis].[DiagnosisGroup].[IsActive] = @IsActive
				WHERE
					[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = @DiagnosisGroupID;				
			END
			ELSE
			BEGIN
				SELECT @DiagnosisGroupID = -2;
			END
		END
		ELSE IF @DiagnosisGroupID_PREV <> @DiagnosisGroupID
		BEGIN			
			SELECT @DiagnosisGroupID = -1;			
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
			SELECT @DiagnosisGroupID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
