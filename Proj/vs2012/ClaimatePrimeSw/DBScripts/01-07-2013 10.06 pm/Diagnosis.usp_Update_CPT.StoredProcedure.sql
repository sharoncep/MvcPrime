USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_Update_CPT]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_Update_CPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the CPT in the database.
	 
CREATE PROCEDURE [Diagnosis].[usp_Update_CPT]
	@CPTCode NVARCHAR(9)
	, @ShortDesc NVARCHAR(150) = NULL
	, @MediumDesc NVARCHAR(150) = NULL
	, @LongDesc NVARCHAR(255) = NULL
	, @CustomDesc NVARCHAR(150) = NULL
	, @ChargePerUnit DECIMAL
	, @IsHCPCSCode BIT
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @CPTID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @CPTID_PREV BIGINT;
		SELECT @CPTID_PREV = [Diagnosis].[ufn_IsExists_CPT] (@CPTCode, @ShortDesc, @MediumDesc, @LongDesc, @CustomDesc, @ChargePerUnit, @IsHCPCSCode, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Diagnosis].[CPT].[CPTID] FROM [Diagnosis].[CPT] WHERE [Diagnosis].[CPT].[CPTID] = @CPTID AND [Diagnosis].[CPT].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@CPTID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Diagnosis].[CPT].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Diagnosis].[CPT].[LastModifiedOn]
			FROM 
				[Diagnosis].[CPT] WITH (NOLOCK)
			WHERE
				[Diagnosis].[CPT].[CPTID] = @CPTID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Diagnosis].[CPTHistory]
					(
						[CPTID]
						, [CPTCode]
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
				SELECT
					[Diagnosis].[CPT].[CPTID]
					, [Diagnosis].[CPT].[CPTCode]
					, [Diagnosis].[CPT].[ShortDesc]
					, [Diagnosis].[CPT].[MediumDesc]
					, [Diagnosis].[CPT].[LongDesc]
					, [Diagnosis].[CPT].[CustomDesc]
					, [Diagnosis].[CPT].[ChargePerUnit]
					, [Diagnosis].[CPT].[IsHCPCSCode]
					, [Diagnosis].[CPT].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Diagnosis].[CPT].[IsActive]
				FROM 
					[Diagnosis].[CPT]
				WHERE
					[Diagnosis].[CPT].[CPTID] = @CPTID;
				
				UPDATE 
					[Diagnosis].[CPT]
				SET
					[Diagnosis].[CPT].[CPTCode] = @CPTCode
					, [Diagnosis].[CPT].[ShortDesc] = @ShortDesc
					, [Diagnosis].[CPT].[MediumDesc] = @MediumDesc
					, [Diagnosis].[CPT].[LongDesc] = @LongDesc
					, [Diagnosis].[CPT].[CustomDesc] = @CustomDesc
					, [Diagnosis].[CPT].[ChargePerUnit] = @ChargePerUnit
					, [Diagnosis].[CPT].[IsHCPCSCode] = @IsHCPCSCode
					, [Diagnosis].[CPT].[Comment] = @Comment
					, [Diagnosis].[CPT].[LastModifiedBy] = @CurrentModificationBy
					, [Diagnosis].[CPT].[LastModifiedOn] = @CurrentModificationOn
					, [Diagnosis].[CPT].[IsActive] = @IsActive
				WHERE
					[Diagnosis].[CPT].[CPTID] = @CPTID;				
			END
			ELSE
			BEGIN
				SELECT @CPTID = -2;
			END
		END
		ELSE IF @CPTID_PREV <> @CPTID
		BEGIN			
			SELECT @CPTID = -1;			
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
			SELECT @CPTID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
