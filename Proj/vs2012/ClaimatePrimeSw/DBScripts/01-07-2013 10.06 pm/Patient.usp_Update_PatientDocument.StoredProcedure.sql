USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_Update_PatientDocument]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_Update_PatientDocument]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the PatientDocument in the database.
	 
CREATE PROCEDURE [Patient].[usp_Update_PatientDocument]
	@PatientID BIGINT
	, @DocumentCategoryID TINYINT
	, @ServiceOrFromDate DATE
	, @ToDate DATE = NULL
	, @DocumentRelPath NVARCHAR(350) = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @PatientDocumentID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @PatientDocumentID_PREV BIGINT;
		SELECT @PatientDocumentID_PREV = [Patient].[ufn_IsExists_PatientDocument] (@PatientID, @DocumentCategoryID, @ServiceOrFromDate, @ToDate, @DocumentRelPath, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Patient].[PatientDocument].[PatientDocumentID] FROM [Patient].[PatientDocument] WHERE [Patient].[PatientDocument].[PatientDocumentID] = @PatientDocumentID AND [Patient].[PatientDocument].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@PatientDocumentID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Patient].[PatientDocument].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Patient].[PatientDocument].[LastModifiedOn]
			FROM 
				[Patient].[PatientDocument] WITH (NOLOCK)
			WHERE
				[Patient].[PatientDocument].[PatientDocumentID] = @PatientDocumentID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Patient].[PatientDocumentHistory]
					(
						[PatientDocumentID]
						, [PatientID]
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
				SELECT
					[Patient].[PatientDocument].[PatientDocumentID]
					, [Patient].[PatientDocument].[PatientID]
					, [Patient].[PatientDocument].[DocumentCategoryID]
					, [Patient].[PatientDocument].[ServiceOrFromDate]
					, [Patient].[PatientDocument].[ToDate]
					, [Patient].[PatientDocument].[DocumentRelPath]
					, [Patient].[PatientDocument].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Patient].[PatientDocument].[IsActive]
				FROM 
					[Patient].[PatientDocument]
				WHERE
					[Patient].[PatientDocument].[PatientDocumentID] = @PatientDocumentID;
				
				UPDATE 
					[Patient].[PatientDocument]
				SET
					[Patient].[PatientDocument].[PatientID] = @PatientID
					, [Patient].[PatientDocument].[DocumentCategoryID] = @DocumentCategoryID
					, [Patient].[PatientDocument].[ServiceOrFromDate] = @ServiceOrFromDate
					, [Patient].[PatientDocument].[ToDate] = @ToDate
					, [Patient].[PatientDocument].[DocumentRelPath] = @DocumentRelPath
					, [Patient].[PatientDocument].[Comment] = @Comment
					, [Patient].[PatientDocument].[LastModifiedBy] = @CurrentModificationBy
					, [Patient].[PatientDocument].[LastModifiedOn] = @CurrentModificationOn
					, [Patient].[PatientDocument].[IsActive] = @IsActive
				WHERE
					[Patient].[PatientDocument].[PatientDocumentID] = @PatientDocumentID;				
			END
			ELSE
			BEGIN
				SELECT @PatientDocumentID = -2;
			END
		END
		ELSE IF @PatientDocumentID_PREV <> @PatientDocumentID
		BEGIN			
			SELECT @PatientDocumentID = -1;			
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
			SELECT @PatientDocumentID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
