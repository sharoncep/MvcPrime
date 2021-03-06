USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837Visit_ClaimDiagnosisCPT]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetAnsi837Visit_ClaimDiagnosisCPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetAnsi837Visit_ClaimDiagnosisCPT]
	@PatientVisitID	BIGINT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @PRIMARY_DIAGNOSIS_ID BIGINT;
				
	DECLARE @DIAGNOSIS_ID BIGINT;
	DECLARE @CLAIM_NUMBER BIGINT;
	
	SELECT 
		@PRIMARY_DIAGNOSIS_ID = [Claim].[ClaimDiagnosis].[DiagnosisID]
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Claim].[ClaimDiagnosis]
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	WHERE
		[Patient].[PatientVisit].[PrimaryClaimDiagnosisID] IS NOT NULL
	AND
		[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID
	AND 
		[Claim].[ClaimDiagnosis].[IsActive] = 1;
		
	IF @PRIMARY_DIAGNOSIS_ID IS NOT NULL AND @PRIMARY_DIAGNOSIS_ID > 0
	BEGIN
		DECLARE @DIAG_COUNT INT;
		
		SELECT 
			@DIAG_COUNT = COUNT([Claim].[ClaimDiagnosis].[DiagnosisID]) 
		FROM 
			[Claim].[ClaimDiagnosis] 
		WHERE 
			[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
		AND
			 [Claim].[ClaimDiagnosis].[DiagnosisID] <> @PRIMARY_DIAGNOSIS_ID
		AND 
			[Claim].[ClaimDiagnosis].[IsActive] = 1;
		
		IF @DIAG_COUNT = 0
		BEGIN
			SELECT @PRIMARY_DIAGNOSIS_ID = 0;
		END
	END
		
	DECLARE @TBL_DIAG TABLE
	(
		[ID] BIGINT IDENTITY (1, 1) NOT NULL
		, [DIAGNOSIS_ID] BIGINT NOT NULL
		, [CLAIM_NUMBER] BIGINT NOT NULL
	);
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] BIGINT IDENTITY (1, 1) NOT NULL
		, [CLAIM_NUMBER] BIGINT NOT NULL
		, [DX_CODE] NVARCHAR(9) NOT NULL
		, [ICD_FORMAT] TINYINT NOT NULL
		, [CLAIM_DIAGNOSIS_CPT_ID] BIGINT NULL
		, [CPT_CODE] NVARCHAR(9) NULL
		, [FACILITY_TYPE_CODE] NVARCHAR(9) NULL
		, [UNIT] INT NULL
		, [CHARGE_PER_UNIT] DECIMAL(9,2) NULL
		, [IS_HCPCS_CODE] BIT NOT NULL
		, [CPT_DOS] DATE NULL
		, [MODI1_CODE] NVARCHAR(9) NULL
		, [MODI2_CODE] NVARCHAR(9) NULL
		, [MODI3_CODE] NVARCHAR(9) NULL
		, [MODI4_CODE] NVARCHAR(9) NULL
	);
		
	IF @PRIMARY_DIAGNOSIS_ID IS NULL OR @PRIMARY_DIAGNOSIS_ID = 0
	BEGIN
		INSERT INTO
			@TBL_DIAG
		SELECT
			[Claim].[ClaimDiagnosis].[DiagnosisID]
			, [Claim].[ClaimDiagnosis].[ClaimNumber] 
		FROM 
			[Claim].[ClaimDiagnosis]
		WHERE 
			[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
		AND 
			[Claim].[ClaimDiagnosis].[IsActive] = 1
		ORDER BY
			[Claim].[ClaimDiagnosis].[ClaimNumber]
		ASC
			, [Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
		ASC;
	END
	ELSE
	BEGIN
		DECLARE 
			CUR_DIAG 
		CURSOR LOCAL FAST_FORWARD READ_ONLY FOR 
			SELECT
				[Claim].[ClaimDiagnosis].[DiagnosisID]
				, [Claim].[ClaimDiagnosis].[ClaimNumber] 
			FROM 
				[Claim].[ClaimDiagnosis]
			WHERE 
				[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				[Claim].[ClaimDiagnosis].[DiagnosisID] != @PRIMARY_DIAGNOSIS_ID
			AND 
				[Claim].[ClaimDiagnosis].[IsActive] = 1
			ORDER BY
				[Claim].[ClaimDiagnosis].[ClaimNumber]
			ASC
				, [Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
			ASC;
		
		DECLARE @CLAIM_NUMBER_PREV BIGINT;
		
		SELECT @CLAIM_NUMBER_PREV = -1;
				
		OPEN CUR_DIAG;
		
		FETCH NEXT FROM CUR_DIAG INTO @DIAGNOSIS_ID, @CLAIM_NUMBER;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @CLAIM_NUMBER_PREV != @CLAIM_NUMBER
			BEGIN
				INSERT INTO
					@TBL_DIAG
				SELECT
					@PRIMARY_DIAGNOSIS_ID
					, @CLAIM_NUMBER;
					
				SELECT @CLAIM_NUMBER_PREV = @CLAIM_NUMBER;
			END
			
			INSERT INTO
				@TBL_DIAG
			SELECT
				@DIAGNOSIS_ID
				, @CLAIM_NUMBER;
		
			FETCH NEXT FROM CUR_DIAG INTO @DIAGNOSIS_ID, @CLAIM_NUMBER;
		END
		
		CLOSE CUR_DIAG;
		DEALLOCATE CUR_DIAG;
	END
    
    DECLARE 
		CUR_DIAG 
	CURSOR LOCAL FAST_FORWARD READ_ONLY FOR 
		SELECT
			[DIAGNOSIS_ID]
			, [CLAIM_NUMBER]
		FROM 
			@TBL_DIAG
		ORDER BY
			[ID]
		ASC;
		
	OPEN CUR_DIAG;
	
	FETCH NEXT FROM CUR_DIAG INTO @DIAGNOSIS_ID, @CLAIM_NUMBER;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO
			@TBL_ANS
			(
				[CLAIM_NUMBER]
				, [CLAIM_DIAGNOSIS_CPT_ID]
				, [DX_CODE]
				, [ICD_FORMAT]
				, [CPT_CODE]
				, [IS_HCPCS_CODE]
				, [FACILITY_TYPE_CODE]
				, [UNIT]
				, [CHARGE_PER_UNIT]
				, [CPT_DOS]
			)
		SELECT
			@CLAIM_NUMBER AS [CLAIM_NUMBER]
			, [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPT_ID]
			, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [DX_CODE]
			, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
			, [Diagnosis].[CPT].[CPTCode] AS [CPT_CODE]
			, ISNULL([Diagnosis].[CPT].[IsHCPCSCode], 0) AS [IS_HCPCS_CODE]
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
		LEFT JOIN
			[Claim].[ClaimDiagnosisCPT]
		ON
			[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID]
		AND
			[Claim].[ClaimDiagnosisCPT].[IsActive] = 1
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
			[Claim].[ClaimDiagnosis].[DiagnosisID] = @DIAGNOSIS_ID
		AND
			[Diagnosis].[Diagnosis].[IsActive] = 1
		ORDER BY
			[Claim].[ClaimDiagnosis].[ClaimNumber]
		ASC
			, [Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
		ASC;
	
		FETCH NEXT FROM CUR_DIAG INTO @DIAGNOSIS_ID, @CLAIM_NUMBER;
	END
	
	CLOSE CUR_DIAG;
	DEALLOCATE CUR_DIAG;
	
	-- MODIFIERS
	
	DECLARE CUR_TBL CURSOR LOCAL FAST_FORWARD READ_ONLY FOR SELECT [CLAIM_DIAGNOSIS_CPT_ID] FROM @TBL_ANS;
	DECLARE @CLAIM_DIAGNOSIS_CPT_ID BIGINT;
	
	OPEN CUR_TBL;
	
	FETCH NEXT FROM CUR_TBL INTO @CLAIM_DIAGNOSIS_CPT_ID;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @MODIFIER_CODE NVARCHAR(9);
		SELECT @MODIFIER_CODE = NULL;
		
		SELECT
			@MODIFIER_CODE = [Diagnosis].[Modifier].[ModifierCode]
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
			[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = 1;
			
		UPDATE
			@TBL_ANS
		SET
			[MODI1_CODE] = @MODIFIER_CODE
		WHERE
			[CLAIM_DIAGNOSIS_CPT_ID] = @CLAIM_DIAGNOSIS_CPT_ID;
		
		SELECT @MODIFIER_CODE = NULL;
		
		SELECT
			@MODIFIER_CODE = [Diagnosis].[Modifier].[ModifierCode]
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
			[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = 1;
			
		UPDATE
			@TBL_ANS
		SET
			[MODI2_CODE] = @MODIFIER_CODE
		WHERE
			[CLAIM_DIAGNOSIS_CPT_ID] = @CLAIM_DIAGNOSIS_CPT_ID;
		
		SELECT @MODIFIER_CODE = NULL;
		
		SELECT
			@MODIFIER_CODE = [Diagnosis].[Modifier].[ModifierCode]
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
			[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = 1;
			
		UPDATE
			@TBL_ANS
		SET
			[MODI3_CODE] = @MODIFIER_CODE
		WHERE
			[CLAIM_DIAGNOSIS_CPT_ID] = @CLAIM_DIAGNOSIS_CPT_ID;
		
		SELECT @MODIFIER_CODE = NULL;
		
		SELECT
			@MODIFIER_CODE = [Diagnosis].[Modifier].[ModifierCode]
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
			[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = 1;
			
		UPDATE
			@TBL_ANS
		SET
			[MODI4_CODE] = @MODIFIER_CODE
		WHERE
			[CLAIM_DIAGNOSIS_CPT_ID] = @CLAIM_DIAGNOSIS_CPT_ID;
	
		FETCH NEXT FROM CUR_TBL INTO @CLAIM_DIAGNOSIS_CPT_ID;
	END
	
	CLOSE CUR_TBL;
	DEALLOCATE CUR_TBL;
	
	SELECT * FROM @TBL_ANS ORDER BY [ID] ASC;
	
	-- EXEC [Claim].[usp_GetAnsi837Visit_ClaimDiagnosisCPT] @PatientVisitID = 22943
	-- EXEC [Claim].[usp_GetAnsi837Visit_ClaimDiagnosisCPT] @PatientVisitID = 8569
	-- EXEC [Claim].[usp_GetAnsi837Visit_ClaimDiagnosisCPT] @PatientVisitID = 8569
	-- EXEC [Claim].[usp_GetAnsi837Visit_ClaimDiagnosisCPT] @PatientVisitID = 8569
	-- EXEC [Claim].[usp_GetAnsi837Visit_ClaimDiagnosisCPT] @PatientVisitID = 8569
END
GO
