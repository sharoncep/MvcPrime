USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetByPatVisitDx_ClaimDiagnosisCPT]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetByPatVisitDx_ClaimDiagnosisCPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetByPatVisitDx_ClaimDiagnosisCPT]
	@PatientVisitID	BIGINT 
	, @DescType NVARCHAR(15) = NULL
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
		, [DX_NAME_CODE] NVARCHAR(900) NOT NULL
		, [DX_CODE] NVARCHAR(9) NOT NULL
		, [CLAIM_DIAGNOSIS_CPT_ID] BIGINT NOT NULL
		, [CPT_NAME_CODE] NVARCHAR(400) NOT NULL
		, [CPT_CODE] NVARCHAR(9) NOT NULL
		, [FACILITY_TYPE_NAME_CODE] NVARCHAR(400) NOT NULL
		, [FACILITY_TYPE_CODE] NVARCHAR(9) NOT NULL
		, [UNIT] INT NOT NULL
		, [CHARGE_PER_UNIT] DECIMAL(9,2) NOT NULL
		, [CPT_DOS] DATE NOT NULL
		, [MODI1_NAME_CODE] NVARCHAR(165) NULL
		, [MODI1_CODE] NVARCHAR(9) NULL
		, [MODI2_NAME_CODE] NVARCHAR(165) NULL
		, [MODI2_CODE] NVARCHAR(9) NULL
		, [MODI3_NAME_CODE] NVARCHAR(165) NULL
		, [MODI3_CODE] NVARCHAR(9) NULL
		, [MODI4_NAME_CODE] NVARCHAR(165) NULL
		, [MODI4_CODE] NVARCHAR(9) NULL
	);
	
	IF (@DescType IS NULL) OR (NOT (@DescType = 'ShortDesc' OR @DescType = 'MediumDesc' OR @DescType = 'LongDesc' OR @DescType = 'CustomDesc'))
	BEGIN
		SELECT @DescType = 'ShortDesc';
	END
		
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
    
    IF @DescType = 'ShortDesc'		-- ShortDesc STARTS
	BEGIN	
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
				@CLAIM_NUMBER AS [CLAIM_NUMBER]
				, [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPT_ID]
				, CASE WHEN [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] IS NULL 
					THEN 
						ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']' + ' | DG: **'
					ELSE 
						ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']' + ' | DG: ' + [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription]+ ' - $' + CAST ([Diagnosis].[DiagnosisGroup].[Amount] AS NVARCHAR(15)) + ' ['+ [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] +']'
					END 
				AS [NAME_CODE]
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
			INNER JOIN
				[Claim].[ClaimDiagnosisCPT]
			ON
				[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID]
			INNER JOIN
				[Diagnosis].[CPT]
			ON
				[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
			INNER JOIN
				[Billing].[FacilityType]
			ON 
				[Billing].[FacilityType].[FacilityTypeID] = [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			WHERE
				 [Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				[Claim].[ClaimDiagnosis].[DiagnosisID] = @DIAGNOSIS_ID
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosisCPT].[IsActive] = 1
			AND
				[Diagnosis].[CPT].[IsActive] = 1
			AND
				[Billing].[FacilityType].[IsActive] = 1
			ORDER BY
				[Claim].[ClaimDiagnosis].[ClaimNumber]
			ASC
				, [Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
			ASC;
		
			FETCH NEXT FROM CUR_DIAG INTO @DIAGNOSIS_ID, @CLAIM_NUMBER;
		END
		
		CLOSE CUR_DIAG;
		DEALLOCATE CUR_DIAG;
	END
	ELSE IF @DescType = 'MediumDesc'		-- MediumDesc STARTS
	BEGIN	
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
				@CLAIM_NUMBER AS [CLAIM_NUMBER]
				, [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPT_ID]
				, CASE WHEN [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] IS NULL 
					THEN 
						ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']' + ' | DG: **'
					ELSE 
						ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']' + ' | DG: ' + [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription]+ ' - $' + CAST ([Diagnosis].[DiagnosisGroup].[Amount] AS NVARCHAR(15)) + ' ['+ [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] +']'
					END 
				AS [NAME_CODE]
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
			INNER JOIN
				[Claim].[ClaimDiagnosisCPT]
			ON
				[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID]
			INNER JOIN
				[Diagnosis].[CPT]
			ON
				[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
			INNER JOIN
				[Billing].[FacilityType]
			ON 
				[Billing].[FacilityType].[FacilityTypeID] = [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			WHERE
				 [Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				[Claim].[ClaimDiagnosis].[DiagnosisID] = @DIAGNOSIS_ID
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosisCPT].[IsActive] = 1
			AND
				[Diagnosis].[CPT].[IsActive] = 1
			AND
				[Billing].[FacilityType].[IsActive] = 1
			ORDER BY
				[Claim].[ClaimDiagnosis].[ClaimNumber]
			ASC
				, [Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
			ASC;
		
			FETCH NEXT FROM CUR_DIAG INTO @DIAGNOSIS_ID, @CLAIM_NUMBER;
		END
		
		CLOSE CUR_DIAG;
		DEALLOCATE CUR_DIAG;
	END
	ELSE IF @DescType = 'LongDesc'		-- LongDesc STARTS
	BEGIN	
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
				@CLAIM_NUMBER AS [CLAIM_NUMBER]
				, [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPT_ID]
				, CASE WHEN [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] IS NULL 
					THEN 
						ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']' + ' | DG: **'
					ELSE 
						ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']' + ' | DG: ' + [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription]+ ' - $' + CAST ([Diagnosis].[DiagnosisGroup].[Amount] AS NVARCHAR(15)) + ' ['+ [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] +']'
					END 
				AS [NAME_CODE]
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
			INNER JOIN
				[Claim].[ClaimDiagnosisCPT]
			ON
				[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID]
			INNER JOIN
				[Diagnosis].[CPT]
			ON
				[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
			INNER JOIN
				[Billing].[FacilityType]
			ON 
				[Billing].[FacilityType].[FacilityTypeID] = [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			WHERE
				 [Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				[Claim].[ClaimDiagnosis].[DiagnosisID] = @DIAGNOSIS_ID
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosisCPT].[IsActive] = 1
			AND
				[Diagnosis].[CPT].[IsActive] = 1
			AND
				[Billing].[FacilityType].[IsActive] = 1
			ORDER BY
				[Claim].[ClaimDiagnosis].[ClaimNumber]
			ASC
				, [Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
			ASC;
		
			FETCH NEXT FROM CUR_DIAG INTO @DIAGNOSIS_ID, @CLAIM_NUMBER;
		END
		
		CLOSE CUR_DIAG;
		DEALLOCATE CUR_DIAG;
	END
	ELSE IF @DescType = 'CustomDesc'		-- CustomDesc STARTS
	BEGIN	
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
				@CLAIM_NUMBER AS [CLAIM_NUMBER]
				, [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPT_ID]
				, CASE WHEN [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] IS NULL 
					THEN 
						ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']' + ' | DG: **'
					ELSE 
						ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']' + ' | DG: ' + [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription]+ ' - $' + CAST ([Diagnosis].[DiagnosisGroup].[Amount] AS NVARCHAR(15)) + ' ['+ [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] +']'
					END 
				AS [NAME_CODE]
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
			INNER JOIN
				[Claim].[ClaimDiagnosisCPT]
			ON
				[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID]
			INNER JOIN
				[Diagnosis].[CPT]
			ON
				[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
			INNER JOIN
				[Billing].[FacilityType]
			ON 
				[Billing].[FacilityType].[FacilityTypeID] = [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup]
			ON
				[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
			AND
				[Diagnosis].[DiagnosisGroup].[IsActive] = 1
			WHERE
				 [Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
			AND
				[Claim].[ClaimDiagnosis].[DiagnosisID] = @DIAGNOSIS_ID
			AND
				[Diagnosis].[Diagnosis].[IsActive] = 1
			AND
				[Claim].[ClaimDiagnosisCPT].[IsActive] = 1
			AND
				[Diagnosis].[CPT].[IsActive] = 1
			AND
				[Billing].[FacilityType].[IsActive] = 1
			ORDER BY
				[Claim].[ClaimDiagnosis].[ClaimNumber]
			ASC
				, [Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
			ASC;
		
			FETCH NEXT FROM CUR_DIAG INTO @DIAGNOSIS_ID, @CLAIM_NUMBER;
		END
		
		CLOSE CUR_DIAG;
		DEALLOCATE CUR_DIAG;
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
			[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = 1;
			
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
			[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = 1;
			
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
			[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = 1;
			
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
			[Claim].[ClaimDiagnosisCPTModifier].[IsActive] = 1;
			
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
	
	-- EXEC [Claim].[usp_GetByPatVisitDx_ClaimDiagnosisCPT] @PatientVisitID = 4333
	-- EXEC [Claim].[usp_GetByPatVisitDx_ClaimDiagnosisCPT] @PatientVisitID = 8569, @DescType= 'ShortDesc'
	-- EXEC [Claim].[usp_GetByPatVisitDx_ClaimDiagnosisCPT] @PatientVisitID = 8569, @DescType= 'MediumDesc'
	-- EXEC [Claim].[usp_GetByPatVisitDx_ClaimDiagnosisCPT] @PatientVisitID = 8569, @DescType= 'LongDesc'
	-- EXEC [Claim].[usp_GetByPatVisitDx_ClaimDiagnosisCPT] @PatientVisitID = 8569, @DescType= 'CustomDesc'
END
GO
