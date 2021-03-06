USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_Insert_ClaimProcessEDIFile]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_Insert_ClaimProcessEDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Claim].[usp_Insert_ClaimProcessEDIFile]
	@ClaimProcessID BIGINT
	, @EDIFileID INT
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @ClaimProcessEDIFileID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @ClaimProcessEDIFileID = [Claim].[ufn_IsExists_ClaimProcessEDIFile] (@ClaimProcessID, @EDIFileID, @Comment, 0);
		
		IF @ClaimProcessEDIFileID = 0
		BEGIN
			INSERT INTO [Claim].[ClaimProcessEDIFile]
			(
				[ClaimProcessID]
				, [EDIFileID]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@ClaimProcessID
				, @EDIFileID
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @ClaimProcessEDIFileID = MAX([Claim].[ClaimProcessEDIFile].[ClaimProcessEDIFileID]) FROM [Claim].[ClaimProcessEDIFile];
		END
		ELSE
		BEGIN			
			SELECT @ClaimProcessEDIFileID = -1;
		END		
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
