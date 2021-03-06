USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetIDAutoComplete_ClaimDiagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_GetIDAutoComplete_ClaimDiagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetIDAutoComplete_ClaimDiagnosis] 
	@DiagnosisID	NVARCHAR(9)
	, @PatientVisitID BIGINT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TBL_RES TABLE
	(
		[ID] TINYINT NOT NULL IDENTITY (1, 1)
		, [ClaimDiagnosisID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID]
	FROM
		[Claim].[ClaimDiagnosis]
	WHERE
		[Claim].[ClaimDiagnosis].[DiagnosisID] = @DiagnosisID 
	AND
		[Claim].[ClaimDiagnosis].[PatientVisitID] = @PatientVisitID
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Claim].[usp_GetIDAutoComplete_ClaimDiagnosis] '2888' , 1
	
END
GO
