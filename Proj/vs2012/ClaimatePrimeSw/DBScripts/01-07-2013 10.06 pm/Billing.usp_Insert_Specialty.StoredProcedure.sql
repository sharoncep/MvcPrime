USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_Insert_Specialty]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_Insert_Specialty]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Billing].[usp_Insert_Specialty]
	@SpecialtyCode NVARCHAR(15)
	, @SpecialtyName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @SpecialtyID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @SpecialtyID = [Billing].[ufn_IsExists_Specialty] (@SpecialtyCode, @SpecialtyName, @Comment, 0);
		
		IF @SpecialtyID = 0
		BEGIN
			INSERT INTO [Billing].[Specialty]
			(
				[SpecialtyCode]
				, [SpecialtyName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@SpecialtyCode
				, @SpecialtyName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @SpecialtyID = MAX([Billing].[Specialty].[SpecialtyID]) FROM [Billing].[Specialty];
		END
		ELSE
		BEGIN			
			SELECT @SpecialtyID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @SpecialtyID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
