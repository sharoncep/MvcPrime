USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_Insert_Credential]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_Insert_Credential]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Billing].[usp_Insert_Credential]
	@CredentialCode NVARCHAR(9)
	, @CredentialName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @CredentialID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @CredentialID = [Billing].[ufn_IsExists_Credential] (@CredentialCode, @CredentialName, @Comment, 0);
		
		IF @CredentialID = 0
		BEGIN
			INSERT INTO [Billing].[Credential]
			(
				[CredentialCode]
				, [CredentialName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@CredentialCode
				, @CredentialName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @CredentialID = MAX([Billing].[Credential].[CredentialID]) FROM [Billing].[Credential];
		END
		ELSE
		BEGIN			
			SELECT @CredentialID = -1;
		END		
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
