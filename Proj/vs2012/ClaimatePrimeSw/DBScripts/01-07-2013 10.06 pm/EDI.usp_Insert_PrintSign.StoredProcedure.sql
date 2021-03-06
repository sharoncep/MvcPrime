USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_Insert_PrintSign]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_Insert_PrintSign]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [EDI].[usp_Insert_PrintSign]
	@PrintSignCode NVARCHAR(2)
	, @PrintSignName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @PrintSignID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @PrintSignID = [EDI].[ufn_IsExists_PrintSign] (@PrintSignCode, @PrintSignName, @Comment, 0);
		
		IF @PrintSignID = 0
		BEGIN
			INSERT INTO [EDI].[PrintSign]
			(
				[PrintSignCode]
				, [PrintSignName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@PrintSignCode
				, @PrintSignName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @PrintSignID = MAX([EDI].[PrintSign].[PrintSignID]) FROM [EDI].[PrintSign];
		END
		ELSE
		BEGIN			
			SELECT @PrintSignID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @PrintSignID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
