USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_Update_ClaimDiagnosisCPT]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_Update_ClaimDiagnosisCPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Description:This Stored Procedure is used to UPDATE the ClaimDiagnosisCPT in the database.
	 
CREATE PROCEDURE [Claim].[usp_Update_ClaimDiagnosisCPT]
	@ClaimDiagnosisID BIGINT
	, @CPTID INT
	, @FacilityTypeID TINYINT
	, @Unit INT
	, @ChargePerUnit DECIMAL
	, @CPTDOS DATE
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @ClaimDiagnosisCPTID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @ClaimDiagnosisCPTID_PREV BIGINT;
		SELECT @ClaimDiagnosisCPTID_PREV = [Claim].[ufn_IsExists_ClaimDiagnosisCPT] (@ClaimDiagnosisID, @CPTID, @FacilityTypeID, @Unit, @ChargePerUnit, @CPTDOS, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] FROM [Claim].[ClaimDiagnosisCPT] WHERE [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] = @ClaimDiagnosisCPTID AND [Claim].[ClaimDiagnosisCPT].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@ClaimDiagnosisCPTID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Claim].[ClaimDiagnosisCPT].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Claim].[ClaimDiagnosisCPT].[LastModifiedOn]
			FROM 
				[Claim].[ClaimDiagnosisCPT] WITH (NOLOCK)
			WHERE
				[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] = @ClaimDiagnosisCPTID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				INSERT INTO 
					[Claim].[ClaimDiagnosisCPTHistory]
					(
						[ClaimDiagnosisCPTID]
						, [ClaimDiagnosisID]
						, [CPTID]
						, [FacilityTypeID]
						, [Unit]
						, [ChargePerUnit]
						, [CPTDOS]
						, [Comment]
						, [CreatedBy]
						, [CreatedOn]
						, [LastModifiedBy]
						, [LastModifiedOn]
						, [IsActive]
					)
				SELECT
					[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID]
					, [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID]
					, [Claim].[ClaimDiagnosisCPT].[CPTID]
					, [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
					, [Claim].[ClaimDiagnosisCPT].[Unit]
					, [Claim].[ClaimDiagnosisCPT].[ChargePerUnit]
					, [Claim].[ClaimDiagnosisCPT].[CPTDOS]
					, [Claim].[ClaimDiagnosisCPT].[Comment]
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @LastModifiedBy
					, @LastModifiedOn
					, [Claim].[ClaimDiagnosisCPT].[IsActive]
				FROM 
					[Claim].[ClaimDiagnosisCPT]
				WHERE
					[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] = @ClaimDiagnosisCPTID;
				
				UPDATE 
					[Claim].[ClaimDiagnosisCPT]
				SET
					[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID] = @ClaimDiagnosisID
					, [Claim].[ClaimDiagnosisCPT].[CPTID] = @CPTID
					, [Claim].[ClaimDiagnosisCPT].[FacilityTypeID] = @FacilityTypeID
					, [Claim].[ClaimDiagnosisCPT].[Unit] = @Unit
					, [Claim].[ClaimDiagnosisCPT].[ChargePerUnit] = @ChargePerUnit
					, [Claim].[ClaimDiagnosisCPT].[CPTDOS] = @CPTDOS
					, [Claim].[ClaimDiagnosisCPT].[Comment] = @Comment
					, [Claim].[ClaimDiagnosisCPT].[LastModifiedBy] = @CurrentModificationBy
					, [Claim].[ClaimDiagnosisCPT].[LastModifiedOn] = @CurrentModificationOn
					, [Claim].[ClaimDiagnosisCPT].[IsActive] = @IsActive
				WHERE
					[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] = @ClaimDiagnosisCPTID;				
			END
			ELSE
			BEGIN
				SELECT @ClaimDiagnosisCPTID = -2;
			END
		END
		ELSE IF @ClaimDiagnosisCPTID_PREV <> @ClaimDiagnosisCPTID
		BEGIN			
			SELECT @ClaimDiagnosisCPTID = -1;			
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
			SELECT @ClaimDiagnosisCPTID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END
GO
