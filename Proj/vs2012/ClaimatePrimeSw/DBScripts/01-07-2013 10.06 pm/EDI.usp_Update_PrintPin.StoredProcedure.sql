USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_Update_PrintPin]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_Update_PrintPin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the PrintPin in the database.
	 
CREATE PROCEDURE [EDI].[usp_Update_PrintPin]
	@PrintPinCode NVARCHAR(2)
	, @PrintPinName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @PrintPinID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @PrintPinID_PREV BIGINT;
		SELECT @PrintPinID_PREV = [EDI].[ufn_IsExists_PrintPin] (@PrintPinCode, @PrintPinName, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [EDI].[PrintPin].[PrintPinID] FROM [EDI].[PrintPin] WHERE [EDI].[PrintPin].[PrintPinID] = @PrintPinID AND [EDI].[PrintPin].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@PrintPinID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [EDI].[PrintPin].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [EDI].[PrintPin].[LastModifiedOn]
			FROM 
				[EDI].[PrintPin] WITH (NOLOCK)
			WHERE
				[EDI].[PrintPin].[PrintPinID] = @PrintPinID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[EDI].[PrintPinHistory]
					(
						[PrintPinID]
						, [PrintPinCode]
						, [PrintPinName]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[EDI].[PrintPin].[PrintPinID]
					, [EDI].[PrintPin].[PrintPinCode]
					, [EDI].[PrintPin].[PrintPinName]
					, [EDI].[PrintPin].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [EDI].[PrintPin].[IsActive]
				FROM 
					[EDI].[PrintPin]
				WHERE
					[EDI].[PrintPin].[PrintPinID] = @PrintPinID;
				
				UPDATE 
					[EDI].[PrintPin]
				SET
					[EDI].[PrintPin].[PrintPinCode] = @PrintPinCode
					, [EDI].[PrintPin].[PrintPinName] = @PrintPinName
					, [EDI].[PrintPin].[Comment] = @Comment
					, [EDI].[PrintPin].[LastModifiedBy] = @CurrentModificationBy
					, [EDI].[PrintPin].[LastModifiedOn] = @CurrentModificationOn
					, [EDI].[PrintPin].[IsActive] = @IsActive
				WHERE
					[EDI].[PrintPin].[PrintPinID] = @PrintPinID;				
			END
			ELSE
			BEGIN
				SELECT @PrintPinID = -2;
			END
		END
		ELSE IF @PrintPinID_PREV <> @PrintPinID
		BEGIN			
			SELECT @PrintPinID = -1;			
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
			SELECT @PrintPinID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
