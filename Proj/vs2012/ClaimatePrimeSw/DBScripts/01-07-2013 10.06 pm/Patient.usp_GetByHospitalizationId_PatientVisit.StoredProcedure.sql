USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetByHospitalizationId_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetByHospitalizationId_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Patient].[usp_GetByHospitalizationId_PatientVisit]
	@PatientHospitalizationID BIGINT
	, @AdmittedOn DATE
	, @DischargedOn	DATE = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @DischargedOn IS NULL
	BEGIN
		SELECT @DischargedOn = DATEADD(DAY, 1, GETDATE());
	END
	
	DECLARE @TBL_VST TABLE
	(
		[PAT_VISIT_ID] BIGINT NULL
		, [DOS] DATE NULL
	);

	INSERT INTO
		@TBL_VST
	SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		, [Patient].[PatientVisit].[DOS]
	FROM
		[Patient].[PatientVisit]
	WHERE
		[Patient].[PatientVisit].[PatientHospitalizationID] = @PatientHospitalizationID
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	DELETE FROM @TBL_VST WHERE [PAT_VISIT_ID] IS NULL OR [DOS] IS NULL;
	
	DECLARE @TBL_ANS TABLE
	(
		[PATIENT_VISIT_ID] BIGINT NOT NULL
		, [HAS_DOS_ERROR] BIT NOT NULL
	);
	
	IF EXISTS(SELECT * FROM @TBL_VST)
	BEGIN
		IF EXISTS(SELECT * FROM @TBL_VST WHERE [DOS] BETWEEN @AdmittedOn AND @DischargedOn)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT
				[PAT_VISIT_ID] AS [PATIENT_VISIT_ID]
				, '0' AS [HAS_DOS_ERROR]
			FROM
				@TBL_VST;
		END
		ELSE
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT
				[PAT_VISIT_ID] AS [PATIENT_VISIT_ID]
				, '1' AS [HAS_DOS_ERROR]
			FROM
				@TBL_VST;
		END
	END
	ELSE
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			'0' AS [PATIENT_VISIT_ID]
			, '0' AS [HAS_DOS_ERROR];
	END
	
	SELECT * FROM @TBL_ANS;

	-- EXEC [Patient].[usp_GetByHospitalizationId_PatientVisit] 6, '2013-Feb-14'
	-- EXEC [Patient].[usp_GetByPkId_PatientVisit] 1, 1
	-- EXEC [Patient].[usp_GetByPkId_PatientVisit] 1, 0
END
GO
