USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_Insert_InsuranceType]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_Insert_InsuranceType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Insurance].[usp_Insert_InsuranceType]
	@InsuranceTypeCode NVARCHAR(2)
	, @InsuranceTypeName NVARCHAR(150)
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @InsuranceTypeID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @InsuranceTypeID = [Insurance].[ufn_IsExists_InsuranceType] (@InsuranceTypeCode, @InsuranceTypeName, @Comment, 0);
		
		IF @InsuranceTypeID = 0
		BEGIN
			INSERT INTO [Insurance].[InsuranceType]
			(
				[InsuranceTypeCode]
				, [InsuranceTypeName]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@InsuranceTypeCode
				, @InsuranceTypeName
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @InsuranceTypeID = MAX([Insurance].[InsuranceType].[InsuranceTypeID]) FROM [Insurance].[InsuranceType];
		END
		ELSE
		BEGIN			
			SELECT @InsuranceTypeID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @InsuranceTypeID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
