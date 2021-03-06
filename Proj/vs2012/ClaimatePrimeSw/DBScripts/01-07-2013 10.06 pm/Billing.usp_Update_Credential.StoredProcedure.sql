USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_Update_Credential]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_Update_Credential]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the Credential in the database.
	 
CREATE PROCEDURE [Billing].[usp_Update_Credential]
	@CredentialCode NVARCHAR(9)
	, @CredentialName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @CredentialID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @CredentialID_PREV BIGINT;
		SELECT @CredentialID_PREV = [Billing].[ufn_IsExists_Credential] (@CredentialCode, @CredentialName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Billing].[Credential].[CredentialID] FROM [Billing].[Credential] WHERE [Billing].[Credential].[CredentialID] = @CredentialID AND [Billing].[Credential].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@CredentialID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Billing].[Credential].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Billing].[Credential].[LastModifiedOn]
			FROM 
				[Billing].[Credential] WITH (NOLOCK)
			WHERE
				[Billing].[Credential].[CredentialID] = @CredentialID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Billing].[CredentialHistory]
					(
						[CredentialID]
						, [CredentialCode]
						, [CredentialName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Billing].[Credential].[CredentialID]
					, [Billing].[Credential].[CredentialCode]
					, [Billing].[Credential].[CredentialName]
					, [Billing].[Credential].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Billing].[Credential].[IsActive]
				FROM 
					[Billing].[Credential]
				WHERE
					[Billing].[Credential].[CredentialID] = @CredentialID;
				
				UPDATE 
					[Billing].[Credential]
				SET
					[Billing].[Credential].[CredentialCode] = @CredentialCode
					, [Billing].[Credential].[CredentialName] = @CredentialName
					, [Billing].[Credential].[Comment] = @Comment
					, [Billing].[Credential].[LastModifiedBy] = @CurrentModificationBy
					, [Billing].[Credential].[LastModifiedOn] = @CurrentModificationOn
					, [Billing].[Credential].[IsActive] = @IsActive
				WHERE
					[Billing].[Credential].[CredentialID] = @CredentialID;				
			END
			ELSE
			BEGIN
				SELECT @CredentialID = -2;
			END
		END
		ELSE IF @CredentialID_PREV <> @CredentialID
		BEGIN			
			SELECT @CredentialID = -1;			
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
			SELECT @CredentialID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
