USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetPrimeDxProc_ClaimDiagnosisCPT]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_GetPrimeDxProc_ClaimDiagnosisCPT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetPrimeDxProc_ClaimDiagnosisCPT] 
	@ClaimDiagnosisID BIGINT
	, @PatientVisitID BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [HAS_PROCEDURE] BIT NOT NULL
	);

		
	DECLARE @TBL_TMP TABLE ([ID] INT NOT NULL IDENTITY (1, 1), [ClaimDiagnosisCPTID] BIGINT NOT NULL);

	INSERT INTO 
		@TBL_TMP 
	SELECT 
		[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisCPTID]
	FROM 
		[Claim].[ClaimDiagnosisCPT]
	INNER JOIN
		[Claim].[ClaimDiagnosis]
	ON
		[Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
	WHERE 
		[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
	AND
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = @ClaimDiagnosisID
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	AND
		[Claim].[ClaimDiagnosisCPT].[IsActive] = 1
	
			
	IF ((SELECT COUNT ([T].[ID]) FROM @TBL_TMP T) > 0)
	BEGIN
		INSERT INTO
			@TBL_RES
		SELECT CAST('1' AS BIT) AS [HAS_PROCEDURE];
	END
	ELSE
	BEGIN
		INSERT INTO
			@TBL_RES
		SELECT CAST('0' AS BIT) AS [HAS_PROCEDURE];
	END
	
	SELECT * FROM @TBL_RES;
	
	-- EXEC [Claim].[usp_GetPrimeDxProc_ClaimDiagnosisCPT] @ClaimDiagnosisID= 17966,@PatientVisitID=4333
END
GO
