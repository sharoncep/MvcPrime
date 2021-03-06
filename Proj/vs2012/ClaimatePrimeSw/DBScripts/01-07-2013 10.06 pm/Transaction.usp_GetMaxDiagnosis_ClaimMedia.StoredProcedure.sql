USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetMaxDiagnosis_ClaimMedia]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetMaxDiagnosis_ClaimMedia]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Transaction].[usp_GetMaxDiagnosis_ClaimMedia] 
	@PatientVisitID  BIGINT 
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_TMP TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [MAX_DIAGNOSIS] TINYINT NOT NULL
	);
	
	INSERT INTO 
		@TBL_TMP 
	SELECT
		[Transaction].[ClaimMedia].[MaxDiagnosis] AS [MAX_DIAGNOSIS]
	FROM
		[Transaction].[ClaimMedia]
	INNER JOIN
		[EDI].[EDIReceiver]
	ON
		[EDI].[EDIReceiver].[ClaimMediaID] = [Transaction].[ClaimMedia].[ClaimMediaID]
	INNER JOIN
		[Insurance].[Insurance]
	ON
		[Insurance].[Insurance].[EDIReceiverID] = [EDI].[EDIReceiver].[EDIReceiverID]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[InsuranceID] = [Insurance].[Insurance].[InsuranceID]
	INNER JOIN
		[Patient].[PatientVisit]
	ON
		[Patient].[PatientVisit].[PatientID] = [Patient].[Patient].[PatientID]
	WHERE
		[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID
		
	SELECT * FROM @TBL_TMP;
	
	-- EXEC [Transaction].[usp_GetMaxDiagnosis_ClaimMedia] 4289
	-- EXEC [Transaction].[usp_GetMaxDiagnosis_ClaimMedia] 4286
END
GO
