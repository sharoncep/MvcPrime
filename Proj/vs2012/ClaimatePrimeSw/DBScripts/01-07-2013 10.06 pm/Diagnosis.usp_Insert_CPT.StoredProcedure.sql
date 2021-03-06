USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_Insert_CPT]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_Insert_CPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Diagnosis].[usp_Insert_CPT]
	@CPTCode NVARCHAR(9)
	, @ShortDesc NVARCHAR(150) = NULL
	, @MediumDesc NVARCHAR(150) = NULL
	, @LongDesc NVARCHAR(255) = NULL
	, @CustomDesc NVARCHAR(150) = NULL
	, @ChargePerUnit DECIMAL
	, @IsHCPCSCode BIT
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @CPTID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @CPTID = [Diagnosis].[ufn_IsExists_CPT] (@CPTCode, @ShortDesc, @MediumDesc, @LongDesc, @CustomDesc, @ChargePerUnit, @IsHCPCSCode, @Comment, 0);
		
		IF @CPTID = 0
		BEGIN
			INSERT INTO [Diagnosis].[CPT]
			(
				[CPTCode]
				, [ShortDesc]
				, [MediumDesc]
				, [LongDesc]
				, [CustomDesc]
				, [ChargePerUnit]
				, [IsHCPCSCode]
				, [Comment]
				, [CreatedBy]
				, [CreatedOn]
				, [LastModifiedBy]
				, [LastModifiedOn]
				, [IsActive]
			)
			VALUES
			(
				@CPTCode
				, @ShortDesc
				, @MediumDesc
				, @LongDesc
				, @CustomDesc
				, @ChargePerUnit
				, @IsHCPCSCode
				, @Comment
				, @CurrentModificationBy
				, @CurrentModificationOn
				, @CurrentModificationBy
				, @CurrentModificationOn
				, 1
			);
			
			SELECT @CPTID = MAX([Diagnosis].[CPT].[CPTID]) FROM [Diagnosis].[CPT];
		END
		ELSE
		BEGIN			
			SELECT @CPTID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @CPTID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END
GO
