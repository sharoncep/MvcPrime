USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetByPatientVisit_ClaimDiagnosis]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetByPatientVisit_ClaimDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetByPatientVisit_ClaimDiagnosis]
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
		, [CLAIM_DIAGNOSIS_ID] BIGINT NOT NULL
		, [CLAIM_NUMBER] BIGINT NOT NULL
		, [NAME_CODE] NVARCHAR(400) NOT NULL
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
			SELECT
				[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] AS [CLAIM_DIAGNOSIS_ID]
				, @CLAIM_NUMBER AS [CLAIM_NUMBER]
				, (ISNULL([Diagnosis].[Diagnosis].[ShortDesc], '*NO SHORT DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ' + ISNULL('DG' + [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] , '*NO DG CODE*') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Claim].[ClaimDiagnosis]
			INNER JOIN
				[Diagnosis].[Diagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
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
				[Claim].[ClaimDiagnosis].[IsActive] = 1
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
			SELECT
				[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] AS [CLAIM_DIAGNOSIS_ID]
				, @CLAIM_NUMBER AS [CLAIM_NUMBER]
				, (ISNULL([Diagnosis].[Diagnosis].[MediumDesc], '*NO MEDIUM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ' + ISNULL('DG' + [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] , '*NO DG CODE*') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Claim].[ClaimDiagnosis]
			INNER JOIN
				[Diagnosis].[Diagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
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
				[Claim].[ClaimDiagnosis].[IsActive] = 1
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
			SELECT
				[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] AS [CLAIM_DIAGNOSIS_ID]
				, @CLAIM_NUMBER AS [CLAIM_NUMBER]
				, (ISNULL([Diagnosis].[Diagnosis].[LongDesc], '*NO LONG DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ' + ISNULL('DG' + [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] , '*NO DG CODE*') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Claim].[ClaimDiagnosis]
			INNER JOIN
				[Diagnosis].[Diagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
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
				[Claim].[ClaimDiagnosis].[IsActive] = 1
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
			SELECT
				[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] AS [CLAIM_DIAGNOSIS_ID]
				, @CLAIM_NUMBER AS [CLAIM_NUMBER]
				, (ISNULL([Diagnosis].[Diagnosis].[CustomDesc], '*NO CUSTOM DESC*') + ' - ' + [Diagnosis].[Diagnosis].[DiagnosisCode] + ' - ' + ISNULL('DG' + [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] , '*NO DG CODE*') + ' - ICD' + CAST([Diagnosis].[Diagnosis].[ICDFormat] AS NVARCHAR(3)) + ' [' + CAST([Diagnosis].[Diagnosis].[DiagnosisID] AS NVARCHAR) + ']') AS [NAME_CODE]
			FROM
				[Claim].[ClaimDiagnosis]
			INNER JOIN
				[Diagnosis].[Diagnosis]
			ON
				[Claim].[ClaimDiagnosis].[DiagnosisID] = [Diagnosis].[Diagnosis].[DiagnosisID]
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
				[Claim].[ClaimDiagnosis].[IsActive] = 1
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
	
	SELECT * FROM @TBL_ANS ORDER BY [ID] ASC;
	
	-- EXEC [Claim].[usp_GetByPatientVisit_ClaimDiagnosis] @PatientVisitID = 4339
END
GO
