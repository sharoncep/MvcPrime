USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_Insert_PatientDocument]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_Insert_PatientDocument]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Patient].[usp_Insert_PatientDocument]
	@PatientID BIGINT
	, @DocumentCategoryID TINYINT
	, @ServiceOrFromDate DATE
	, @ToDate DATE = NULL
	, @DocumentRelPath NVARCHAR(350) = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @PatientDocumentID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @PatientDocumentID = [Patient].[ufn_IsExists_PatientDocument] (@PatientID, @DocumentCategoryID, @ServiceOrFromDate, @ToDate, @DocumentRelPath, @Comment, 0);
		
		IF @PatientDocumentID = 0
		BEGIN
			INSERT INTO [Patient].[PatientDocument]
			(
				[PatientID]
				, [DocumentCategoryID]
				, [ServiceOrFromDate]
				, [ToDate]
				, [DocumentRelPath]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@PatientID
				, @DocumentCategoryID
				, @ServiceOrFromDate
				, @ToDate
				, @DocumentRelPath
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @PatientDocumentID = MAX([Patient].[PatientDocument].[PatientDocumentID]) FROM [Patient].[PatientDocument];
		END
		ELSE
		BEGIN			
			SELECT @PatientDocumentID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @PatientDocumentID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
