USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_Insert_ClaimMedia]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_Insert_ClaimMedia]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Transaction].[usp_Insert_ClaimMedia]
	@ClaimMediaCode NVARCHAR(15)
	, @ClaimMediaName NVARCHAR(150)
	, @MaxDiagnosis TINYINT
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @ClaimMediaID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @ClaimMediaID = [Transaction].[ufn_IsExists_ClaimMedia] (@ClaimMediaCode, @ClaimMediaName, @MaxDiagnosis, @Comment, 0);
		
		IF @ClaimMediaID = 0
		BEGIN
			INSERT INTO [Transaction].[ClaimMedia]
			(
				[ClaimMediaCode]
				, [ClaimMediaName]
				, [MaxDiagnosis]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@ClaimMediaCode
				, @ClaimMediaName
				, @MaxDiagnosis
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @ClaimMediaID = MAX([Transaction].[ClaimMedia].[ClaimMediaID]) FROM [Transaction].[ClaimMedia];
		END
		ELSE
		BEGIN			
			SELECT @ClaimMediaID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @ClaimMediaID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
