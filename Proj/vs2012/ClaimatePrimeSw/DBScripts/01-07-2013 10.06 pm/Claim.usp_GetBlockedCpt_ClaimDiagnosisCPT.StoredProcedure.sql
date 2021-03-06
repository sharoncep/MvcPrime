USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetBlockedCpt_ClaimDiagnosisCPT]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetBlockedCpt_ClaimDiagnosisCPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetBlockedCpt_ClaimDiagnosisCPT] 
	@PatientVisitID BIGINT
	, @IsActive BIT 
	, @DescType NVARCHAR(15) = NULL
	
		AS
		BEGIN
			SET NOCOUNT ON;
			
			DECLARE @TBL_ANS TABLE 
	(
		[ID] BIGINT IDENTITY (1, 1) NOT NULL
		, [CLAIM_DIAGNOSIS_CPT_ID] BIGINT NULL
		, [DX_NAME_CODE] NVARCHAR(400) NOT NULL
		, [DX_CODE] NVARCHAR(9) NOT NULL
		, [CPT_NAME_CODE] NVARCHAR(400) NULL
		, [CPT_CODE] NVARCHAR(9) NULL
		, [FACILITY_TYPE_NAME_CODE] NVARCHAR(400) NULL
		, [FACILITY_TYPE_CODE] NVARCHAR(9) NULL
		, [UNIT] INT NULL
		, [CHARGE_PER_UNIT] DECIMAL(9,2) NULL
		, [CPT_DOS] DATE NULL
		, [MODI1_NAME_CODE] NVARCHAR(165) NULL
		, [MODI1_CODE] NVARCHAR(9) NULL
		, [MODI2_NAME_CODE] NVARCHAR(165) NULL
		, [MODI2_CODE] NVARCHAR(9) NULL
		, [MODI3_NAME_CODE] NVARCHAR(165) NULL
		, [MODI3_CODE] NVARCHAR(9) NULL
		, [MODI4_NAME_CODE] NVARCHAR(165) NULL
		, [MODI4_CODE] NVARCHAR(9) NULL
	);
	
			IF (@DescType IS NULL) OR (NOT (@DescType = 'ShortDesc' OR @DescType = 'MediumDesc' OR @DescType = 'LongDesc' OR @DescType = 'CustomDesc')) OR (@DescType = 'ShortDesc')
			BEGIN
				INSERT INTO
				@TBL_ANS
				(
					 [CLAIM_DIAGNOSIS_CPT_ID]
					, [DX_NAME_CODE]
					, [DX_CODE]
					, [CPT_NAME_CODE]
					, [CPT_CODE]
					, [FACILITY_TYPE_NAME_CODE]
					, [FACILITY_TYPE_CODE]
					, [UNIT]
					, [CHARGE_PER_UNIT]
					, [CPT_DOS]
				)
				SELECT
					 [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPT_ID]
					, (ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [DX_NAME_CODE]
					, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [DX_CODE]
					, (ISNULL([Diagnosis].[CPT].[ShortDesc], '*NO SHORT DESC*') + ' [' + [Diagnosis].[CPT].[CPTCode] + ']' )  AS [CPT_NAME_CODE]
					, [Diagnosis].[CPT].[CPTCode] AS [CPT_CODE]
					, [Billing].[FacilityType].[FacilityTypeName] + ' [' +[Billing].[FacilityType].[FacilityTypeCode] + ']' AS [FACILITY_TYPE_NAME_CODE]
					, [Billing].[FacilityType].[FacilityTypeCode] AS [FACILITY_TYPE_CODE]
					, [Claim].[ClaimDiagnosisCPT].[UNIT]
					, [Claim].[ClaimDiagnosisCPT].[ChargePerUnit]
					, [Claim].[ClaimDiagnosisCPT].[CPTDOS]
				FROM
					[Claim].[ClaimDiagnosis]
				INNER JOIN
					[Diagnosis].[Diagnosis]
				ON
					[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
				LEFT JOIN
					[Diagnosis].[DiagnosisGroup]
				ON
					[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
				AND
					[Diagnosis].[DiagnosisGroup].[IsActive] = 1
				INNER JOIN
					[Claim].[ClaimDiagnosisCPT]
				ON
					[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID]
				AND
					[Claim].[ClaimDiagnosisCPT].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosisCPT].[IsActive] ELSE @IsActive END
				LEFT JOIN
					[Diagnosis].[CPT]
				ON
					[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
				AND
					[Diagnosis].[CPT].[IsActive] = 1
				LEFT JOIN
					[Billing].[FacilityType]
				ON 
					[Billing].[FacilityType].[FacilityTypeID] = [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
				AND
					[Billing].[FacilityType].[IsActive] = 1
				WHERE
					 [Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
				AND
					[Diagnosis].[Diagnosis].[IsActive] = 1;
			END
			IF (@DescType = 'MediumDesc')
			BEGIN
				INSERT INTO
				@TBL_ANS
				(
					 [CLAIM_DIAGNOSIS_CPT_ID]
					, [DX_NAME_CODE]
					, [DX_CODE]
					, [CPT_NAME_CODE]
					, [CPT_CODE]
					, [FACILITY_TYPE_NAME_CODE]
					, [FACILITY_TYPE_CODE]
					, [UNIT]
					, [CHARGE_PER_UNIT]
					, [CPT_DOS]
				)
				SELECT
					[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPT_ID]
					, (ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [DX_NAME_CODE]
					, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [DX_CODE]
					, (ISNULL([Diagnosis].[CPT].[MediumDesc], '*NO MEDIUM DESC*') + ' [' + [Diagnosis].[CPT].[CPTCode] + ']' )  AS [CPT_NAME_CODE]
					, [Diagnosis].[CPT].[CPTCode] AS[CPT_CODE]
					, [Billing].[FacilityType].[FacilityTypeName] + ' [' +[Billing].[FacilityType].[FacilityTypeCode] + ']' AS [FACILITY_TYPE_NAME_CODE]
					, [Billing].[FacilityType].[FacilityTypeCode]AS [FACILITY_TYPE_CODE]
					, [Claim].[ClaimDiagnosisCPT].[UNIT]
					, [Claim].[ClaimDiagnosisCPT].[ChargePerUnit]
					, [Claim].[ClaimDiagnosisCPT].[CPTDOS]
				FROM
					[Claim].[ClaimDiagnosis]
				INNER JOIN
					[Diagnosis].[Diagnosis]
				ON
					[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
				LEFT JOIN
					[Diagnosis].[DiagnosisGroup]
				ON
					[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
				AND
					[Diagnosis].[DiagnosisGroup].[IsActive] = 1
				INNER JOIN
					[Claim].[ClaimDiagnosisCPT]
				ON
					[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID]
				AND
					[Claim].[ClaimDiagnosisCPT].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosisCPT].[IsActive] ELSE @IsActive END
				LEFT JOIN
					[Diagnosis].[CPT]
				ON
					[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
				AND
					[Diagnosis].[CPT].[IsActive] = 1
				LEFT JOIN
					[Billing].[FacilityType]
				ON 
					[Billing].[FacilityType].[FacilityTypeID] = [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
				AND
					[Billing].[FacilityType].[IsActive] = 1
				WHERE
					 [Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
				AND
					[Diagnosis].[Diagnosis].[IsActive] = 1;
			END	
			IF (@DescType = 'LongDesc')
			BEGIN
				INSERT INTO
				@TBL_ANS
				(
					 [CLAIM_DIAGNOSIS_CPT_ID]
					, [DX_NAME_CODE]
					, [DX_CODE]
					, [CPT_NAME_CODE]
					, [CPT_CODE]
					, [FACILITY_TYPE_NAME_CODE]
					, [FACILITY_TYPE_CODE]
					, [UNIT]
					, [CHARGE_PER_UNIT]
					, [CPT_DOS]
				)
				SELECT
					[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPT_ID]
					, (ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [DX_NAME_CODE]
					, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [DX_CODE]
					, (ISNULL([Diagnosis].[CPT].[LongDesc], '*NO LONG DESC*') + ' [' + [Diagnosis].[CPT].[CPTCode] + ']' )  AS [CPT_NAME_CODE]
					, [Diagnosis].[CPT].[CPTCode] AS [CPT_CODE]
					, [Billing].[FacilityType].[FacilityTypeName] + ' [' +[Billing].[FacilityType].[FacilityTypeCode] + ']' AS [FACILITY_TYPE_NAME_CODE]
					, [Billing].[FacilityType].[FacilityTypeCode] AS [FACILITY_TYPE_CODE]
					, [Claim].[ClaimDiagnosisCPT].[UNIT]
					, [Claim].[ClaimDiagnosisCPT].[ChargePerUnit]
					, [Claim].[ClaimDiagnosisCPT].[CPTDOS]
				FROM
					[Claim].[ClaimDiagnosis]
				INNER JOIN
					[Diagnosis].[Diagnosis]
				ON
					[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
				LEFT JOIN
					[Diagnosis].[DiagnosisGroup]
				ON
					[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
				AND
					[Diagnosis].[DiagnosisGroup].[IsActive] = 1
				INNER JOIN
					[Claim].[ClaimDiagnosisCPT]
				ON
					[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID]
				AND
					[Claim].[ClaimDiagnosisCPT].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosisCPT].[IsActive] ELSE @IsActive END
				LEFT JOIN
					[Diagnosis].[CPT]
				ON
					[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
				AND
					[Diagnosis].[CPT].[IsActive] = 1
				LEFT JOIN
					[Billing].[FacilityType]
				ON 
					[Billing].[FacilityType].[FacilityTypeID] = [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
				AND
					[Billing].[FacilityType].[IsActive] = 1
				WHERE
					 [Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
				AND
					[Diagnosis].[Diagnosis].[IsActive] = 1
			END	
			IF (@DescType = 'CustomDesc')
			BEGIN
				INSERT INTO
				@TBL_ANS
				(
					 [CLAIM_DIAGNOSIS_CPT_ID]
					, [DX_NAME_CODE]
					, [DX_CODE]
					, [CPT_NAME_CODE]
					, [CPT_CODE]
					, [FACILITY_TYPE_NAME_CODE]
					, [FACILITY_TYPE_CODE]
					, [UNIT]
					, [CHARGE_PER_UNIT]
					, [CPT_DOS]
				)
				SELECT
					[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPT_ID]
					, (ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - DG' + ISNULL([Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode], '**') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [DX_NAME_CODE]
					, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [DX_CODE]
					, (ISNULL([Diagnosis].[CPT].[CustomDesc], '*NO CUSTOM DESC*') + ' [' + [Diagnosis].[CPT].[CPTCode] + ']' )  AS [CPT_NAME_CODE]
					, [Diagnosis].[CPT].[CPTCode] AS [CPT_CODE]
					, [Billing].[FacilityType].[FacilityTypeName] + ' [' +[Billing].[FacilityType].[FacilityTypeCode] + ']' AS [FACILITY_TYPE_NAME_CODE]
					, [Billing].[FacilityType].[FacilityTypeCode] AS [FACILITY_TYPE_CODE]
					, [Claim].[ClaimDiagnosisCPT].[UNIT]
					, [Claim].[ClaimDiagnosisCPT].[ChargePerUnit]
					, [Claim].[ClaimDiagnosisCPT].[CPTDOS]
				FROM
					[Claim].[ClaimDiagnosis]
				INNER JOIN
					[Diagnosis].[Diagnosis]
				ON
					[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
				LEFT JOIN
					[Diagnosis].[DiagnosisGroup]
				ON
					[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
				AND
					[Diagnosis].[DiagnosisGroup].[IsActive] = 1
				INNER JOIN
					[Claim].[ClaimDiagnosisCPT]
				ON
					[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID]
				AND
					[Claim].[ClaimDiagnosisCPT].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosisCPT].[IsActive] ELSE @IsActive END
				LEFT JOIN
					[Diagnosis].[CPT]
				ON
					[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
				AND
					[Diagnosis].[CPT].[IsActive] = 1
				LEFT JOIN
					[Billing].[FacilityType]
				ON 
					[Billing].[FacilityType].[FacilityTypeID] = [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
				AND
					[Billing].[FacilityType].[IsActive] = 1
				WHERE
					 [Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
				AND
					[Diagnosis].[Diagnosis].[IsActive] = 1
			END	
	
	-- MODIFIERS
	
	DECLARE CUR_TBL CURSOR LOCAL FAST_FORWARD READ_ONLY FOR SELECT [CLAIM_DIAGNOSIS_CPT_ID] FROM @TBL_ANS;
	DECLARE @CLAIM_DIAGNOSIS_CPT_ID BIGINT;
	
	OPEN CUR_TBL;
	
	FETCH NEXT FROM CUR_TBL INTO @CLAIM_DIAGNOSIS_CPT_ID;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @MODIFIER_NAME NVARCHAR(165);
		DECLARE @MODIFIER_CODE NVARCHAR(9);
		
		SELECT @MODIFIER_NAME = NULL;
		SELECT @MODIFIER_CODE = NULL;
		
		SELECT
			@MODIFIER_NAME = [Diagnosis].[Modifier].[ModifierName] + ' [' +[Diagnosis].[Modifier].[ModifierCode] + ']' 
			, @MODIFIER_CODE = [Diagnosis].[Modifier].[ModifierCode]
		FROM
			[Diagnosis].[Modifier]
		INNER JOIN
			[Claim].[ClaimDiagnosisCPTModifier]
		ON
			[Claim].[ClaimDiagnosisCPTModifier].[ModifierID] = [Diagnosis].[Modifier].[ModifierID]
		WHERE
			[Claim].[ClaimDiagnosisCPTModifier].[ModifierLevel] = 1
		AND
			[Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTID] = @CLAIM_DIAGNOSIS_CPT_ID
		AND
			[Diagnosis].[Modifier].[IsActive] = 1
		AND
			[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosisCPTModifier].[IsActive] ELSE @IsActive END;
			
		UPDATE
			@TBL_ANS
		SET
			[MODI1_NAME_CODE] = @MODIFIER_NAME
			, [MODI1_CODE] = @MODIFIER_CODE
		WHERE
			[CLAIM_DIAGNOSIS_CPT_ID] = @CLAIM_DIAGNOSIS_CPT_ID;
		
		SELECT @MODIFIER_NAME = NULL;
		SELECT @MODIFIER_CODE = NULL;
		
		SELECT
			@MODIFIER_NAME = [Diagnosis].[Modifier].[ModifierName] + ' [' +[Diagnosis].[Modifier].[ModifierCode] + ']' 
			, @MODIFIER_CODE = [Diagnosis].[Modifier].[ModifierCode]
		FROM
			[Diagnosis].[Modifier]
		INNER JOIN
			[Claim].[ClaimDiagnosisCPTModifier]
		ON
			[Claim].[ClaimDiagnosisCPTModifier].[ModifierID] = [Diagnosis].[Modifier].[ModifierID]
		WHERE
			[Claim].[ClaimDiagnosisCPTModifier].[ModifierLevel] = 2
		AND
			[Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTID] = @CLAIM_DIAGNOSIS_CPT_ID
		AND
			[Diagnosis].[Modifier].[IsActive] = 1
		AND
			[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosisCPTModifier].[IsActive] ELSE @IsActive END;
			
		UPDATE
			@TBL_ANS
		SET
			[MODI2_NAME_CODE] = @MODIFIER_NAME
			, [MODI2_CODE] = @MODIFIER_CODE
		WHERE
			[CLAIM_DIAGNOSIS_CPT_ID] = @CLAIM_DIAGNOSIS_CPT_ID;
		
		SELECT @MODIFIER_NAME = NULL;
		SELECT @MODIFIER_CODE = NULL;
		
		SELECT
			@MODIFIER_NAME = [Diagnosis].[Modifier].[ModifierName] + ' [' +[Diagnosis].[Modifier].[ModifierCode] + ']' 
			, @MODIFIER_CODE = [Diagnosis].[Modifier].[ModifierCode]
		FROM
			[Diagnosis].[Modifier]
		INNER JOIN
			[Claim].[ClaimDiagnosisCPTModifier]
		ON
			[Claim].[ClaimDiagnosisCPTModifier].[ModifierID] = [Diagnosis].[Modifier].[ModifierID]
		WHERE
			[Claim].[ClaimDiagnosisCPTModifier].[ModifierLevel] = 3
		AND
			[Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTID] = @CLAIM_DIAGNOSIS_CPT_ID
		AND
			[Diagnosis].[Modifier].[IsActive] = 1
		AND
			[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosisCPTModifier].[IsActive] ELSE @IsActive END;
			
		UPDATE
			@TBL_ANS
		SET
			[MODI3_NAME_CODE] = @MODIFIER_NAME
			, [MODI3_CODE] = @MODIFIER_CODE
		WHERE
			[CLAIM_DIAGNOSIS_CPT_ID] = @CLAIM_DIAGNOSIS_CPT_ID;
		
		SELECT @MODIFIER_NAME = NULL;
		SELECT @MODIFIER_CODE = NULL;
		
		SELECT
			@MODIFIER_NAME = [Diagnosis].[Modifier].[ModifierName] + ' [' +[Diagnosis].[Modifier].[ModifierCode] + ']' 
			, @MODIFIER_CODE = [Diagnosis].[Modifier].[ModifierCode]
		FROM
			[Diagnosis].[Modifier]
		INNER JOIN
			[Claim].[ClaimDiagnosisCPTModifier]
		ON
			[Claim].[ClaimDiagnosisCPTModifier].[ModifierID] = [Diagnosis].[Modifier].[ModifierID]
		WHERE
			[Claim].[ClaimDiagnosisCPTModifier].[ModifierLevel] = 4
		AND
			[Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTID] = @CLAIM_DIAGNOSIS_CPT_ID
		AND
			[Diagnosis].[Modifier].[IsActive] = 1
		AND
			[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimDiagnosisCPTModifier].[IsActive] ELSE @IsActive END;
			
		UPDATE
			@TBL_ANS
		SET
			[MODI4_NAME_CODE] = @MODIFIER_NAME
			, [MODI4_CODE] = @MODIFIER_CODE
		WHERE
			[CLAIM_DIAGNOSIS_CPT_ID] = @CLAIM_DIAGNOSIS_CPT_ID;
	
		FETCH NEXT FROM CUR_TBL INTO @CLAIM_DIAGNOSIS_CPT_ID;
	END
	
	CLOSE CUR_TBL;
	DEALLOCATE CUR_TBL;
	
	SELECT * FROM @TBL_ANS ORDER BY [ID] ASC;
			
	-- EXEC [Claim].[usp_GetBlockedCpt_ClaimDiagnosisCPT] @PatientVisitID = 4333, @IsActive=0, @DescType = 'CustomDesc'
	-- EXEC [Claim].[usp_GetBlockedCpt_ClaimDiagnosisCPT] @PatientVisitID = 4333, @IsActive=0
	-- EXEC [Claim].[usp_GetBlockedCpt_ClaimDiagnosisCPT] @PatientVisitID = 4333, @IsActive=1
END
GO
