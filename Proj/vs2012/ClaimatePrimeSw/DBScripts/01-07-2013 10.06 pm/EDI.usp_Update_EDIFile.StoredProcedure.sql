USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_Update_EDIFile]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_Update_EDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the EDIFile in the database.
	 
CREATE PROCEDURE [EDI].[usp_Update_EDIFile]
	@EDIReceiverID INT
	, @X12FileRelPath NVARCHAR(255)
	, @RefFileRelPath NVARCHAR(255)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @EDIFileID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @EDIFileID_PREV BIGINT;
		SELECT @EDIFileID_PREV = [EDI].[ufn_IsExists_EDIFile] (@EDIReceiverID, @X12FileRelPath, @RefFileRelPath, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [EDI].[EDIFile].[EDIFileID] FROM [EDI].[EDIFile] WHERE [EDI].[EDIFile].[EDIFileID] = @EDIFileID AND [EDI].[EDIFile].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@EDIFileID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [EDI].[EDIFile].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [EDI].[EDIFile].[LastModifiedOn]
			FROM 
				[EDI].[EDIFile] WITH (NOLOCK)
			WHERE
				[EDI].[EDIFile].[EDIFileID] = @EDIFileID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[EDI].[EDIFileHistory]
					(
						[EDIFileID]
						, [EDIReceiverID]
						, [X12FileRelPath]
						, [RefFileRelPath]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[EDI].[EDIFile].[EDIFileID]
					, [EDI].[EDIFile].[EDIReceiverID]
					, [EDI].[EDIFile].[X12FileRelPath]
					, [EDI].[EDIFile].[RefFileRelPath]
					, [EDI].[EDIFile].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [EDI].[EDIFile].[IsActive]
				FROM 
					[EDI].[EDIFile]
				WHERE
					[EDI].[EDIFile].[EDIFileID] = @EDIFileID;
				
				UPDATE 
					[EDI].[EDIFile]
				SET
					[EDI].[EDIFile].[EDIReceiverID] = @EDIReceiverID
					, [EDI].[EDIFile].[X12FileRelPath] = @X12FileRelPath
					, [EDI].[EDIFile].[RefFileRelPath] = @RefFileRelPath
					, [EDI].[EDIFile].[Comment] = @Comment
					, [EDI].[EDIFile].[LastModifiedBy] = @CurrentModificationBy
					, [EDI].[EDIFile].[LastModifiedOn] = @CurrentModificationOn
					, [EDI].[EDIFile].[IsActive] = @IsActive
				WHERE
					[EDI].[EDIFile].[EDIFileID] = @EDIFileID;				
			END
			ELSE
			BEGIN
				SELECT @EDIFileID = -2;
			END
		END
		ELSE IF @EDIFileID_PREV <> @EDIFileID
		BEGIN			
			SELECT @EDIFileID = -1;			
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
			SELECT @EDIFileID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
