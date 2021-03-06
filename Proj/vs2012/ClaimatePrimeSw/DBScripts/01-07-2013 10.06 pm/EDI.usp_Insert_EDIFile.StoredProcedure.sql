USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_Insert_EDIFile]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_Insert_EDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [EDI].[usp_Insert_EDIFile]
	@EDIReceiverID INT
	, @X12FileRelPath NVARCHAR(255)
	, @RefFileRelPath NVARCHAR(255)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @EDIFileID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @EDIFileID = [EDI].[ufn_IsExists_EDIFile] (@EDIReceiverID, @X12FileRelPath, @RefFileRelPath, @Comment, 0);
		
		IF @EDIFileID = 0
		BEGIN
			INSERT INTO [EDI].[EDIFile]
			(
				[EDIReceiverID]
				, [X12FileRelPath]
				, [RefFileRelPath]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@EDIReceiverID
				, @X12FileRelPath
				, @RefFileRelPath
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @EDIFileID = MAX([EDI].[EDIFile].[EDIFileID]) FROM [EDI].[EDIFile];
		END
		ELSE
		BEGIN			
			SELECT @EDIFileID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @EDIFileID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
