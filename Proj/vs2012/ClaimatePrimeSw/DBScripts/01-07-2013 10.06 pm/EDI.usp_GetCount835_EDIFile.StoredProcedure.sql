USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetCount835_EDIFile]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetCount835_EDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [EDI].[usp_GetCount835_EDIFile]
	@ClinicID int
	, @ClaimStatusID TINYINT
	, @UserID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CLAIM_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
	SELECT
		COUNT ([EDI].[EDIFile].[EDIFileID]) AS [CLAIM_COUNT]
	FROM
		[EDI].[EDIFile]	
	WHERE
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
		[EDI].[EDIFile].[IsActive] = 1;
		
	SELECT * FROM @TBL_ANS;
		
	-- EXEC [EDI].[usp_GetCount835_EDIFile] 1, 23, 101
END
GO
