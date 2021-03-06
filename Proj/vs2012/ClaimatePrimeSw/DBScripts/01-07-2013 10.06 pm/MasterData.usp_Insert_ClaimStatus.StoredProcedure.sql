USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_Insert_ClaimStatus]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_Insert_ClaimStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [MasterData].[usp_Insert_ClaimStatus]
	@ClaimStatusCode NVARCHAR(2)
	, @ClaimStatusName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @ClaimStatusID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @ClaimStatusID = [MasterData].[ufn_IsExists_ClaimStatus] (@ClaimStatusCode, @ClaimStatusName, @Comment, 0);
		
		IF @ClaimStatusID = 0
		BEGIN
			INSERT INTO [MasterData].[ClaimStatus]
			(
				[ClaimStatusCode]
				, [ClaimStatusName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@ClaimStatusCode
				, @ClaimStatusName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @ClaimStatusID = MAX([MasterData].[ClaimStatus].[ClaimStatusID]) FROM [MasterData].[ClaimStatus];
		END
		ELSE
		BEGIN			
			SELECT @ClaimStatusID = -1;
		END		
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
