USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetByID_ClaimProcessEDIFile]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetByID_ClaimProcessEDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetByID_ClaimProcessEDIFile]
    @EDIFileID INT 
    , @ClinicID INT
    , @UserID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		 [PatientVisitID] BIGINT NOT NULL
		, [PatName] NVARCHAR(500) NOT NULL
		, [ChartNumber] NVARCHAR(20) NOT NULL
		, [DOS] DATE NOT NULL
		, [ClinicID] INT NOT NULL
		, [AssignToMe] BIT NOT NULL
	);
	
	INSERT INTO
		@TBL_ANS
	SELECT
		 [PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PatName]
		, [Patient].[ChartNumber]
		, [PatientVisit].[DOS]
		, [Patient].[ClinicID]
		, CAST('1' AS BIT) AS [AssignToMe]
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		[Claim].[ClaimProcess]
	ON
		[Claim].[ClaimProcess].[PatientVisitID]	= [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Claim].[ClaimProcessEDIFile]
	ON
		[Claim].[ClaimProcessEDIFile].[ClaimProcessID] = [Claim].[ClaimProcess].[ClaimProcessID]
	INNER JOIN
		[EDI].[EDIFile]
	ON
		[EDI].[EDIFile].[EDIFileID] = [Claim].[ClaimProcessEDIFile].[EDIFileID]
	WHERE
		[EDI].[EDIFile].[EDIFileID] = @EDIFileID
	AND
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[AssignedTo] = @UserID

	
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Claim].[usp_GetByID_ClaimProcessEDIFile] @EDIFileID  = 8052 , @ClinicID = 1, @UserID = 101
END
GO
