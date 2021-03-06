USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetSentFile_EDIFile]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetSentFile_EDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [EDI].[usp_GetSentFile_EDIFile] 
	@ClinicID	INT
	, @ClaimStatusID TINYINT
	, @UserID INT
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = CAST('1900-01-01' AS DATE);
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = DATEADD(MONTH, 1, GETDATE());
	END	
	
	SELECT
		[EDIFile].[EDIFileID]
		,[EDIFile].[X12FileRelPath]
		,[EDIFile].[RefFileRelPath]
		,[EDIFile].[CreatedOn]		
	FROM
		[EDI].[EDIFile]	
	WHERE
		DATEDIFF(DAY, [EDI].[EDIFile].[CreatedOn], @DateFrom) <= 0 AND DATEDIFF(DAY, [EDI].[EDIFile].[CreatedOn], @DateTo) >= 0
	AND
		[EDI].[EDIFile].[EDIFileID] IN
		(
			SELECT
				[Claim].[ClaimProcessEDIFile].[EDIFileID]
			FROM
				[Claim].[ClaimProcessEDIFile]
			INNER JOIN
				[Claim].[ClaimProcess]
			ON
				[Claim].[ClaimProcess].[ClaimProcessID] = [Claim].[ClaimProcessEDIFile].[ClaimProcessID]
			INNER JOIN
				[Patient].[PatientVisit]
			ON
				[Patient].[PatientVisit].[PatientVisitID] = [Claim].[ClaimProcess].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[Patient].[ClinicID] = @ClinicID
			AND
				[Patient].[PatientVisit].[ClaimStatusID] = @ClaimStatusID
			AND
				[Patient].[PatientVisit].[AssignedTo] = @UserID
			AND
				[Patient].[PatientVisit].[IsActive] = 1	
			AND
				[Patient].[Patient].[IsActive] = 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1	
			AND
				[Claim].[ClaimProcessEDIFile].[IsActive] = 1	
		)
	AND
		[EDI].[EDIFile].[IsActive] = 1
	ORDER BY
		[EDIFile].[LastModifiedOn]
	DESC;
			
			
	-- EXEC [EDI].[usp_GetSentFile_EDIFile] 1, 23, 101,'1900-01-01','2013-07-11'

END
GO
