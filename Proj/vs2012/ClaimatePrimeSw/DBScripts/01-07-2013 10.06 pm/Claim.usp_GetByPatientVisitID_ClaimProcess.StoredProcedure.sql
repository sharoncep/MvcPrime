USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetByPatientVisitID_ClaimProcess]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Claim].[usp_GetByPatientVisitID_ClaimProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Claim].[usp_GetByPatientVisitID_ClaimProcess] 
	@PatientVisitID	BIGINT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Claim].[ClaimProcess].[ClaimStatusID]
		, [Claim].[ClaimProcess].[StatusStartDate]
		, [Claim].[ClaimProcess].[StatusEndDate]
		, [Claim].[ClaimProcess].[DurationMins]
		, [Claim].[ClaimProcess].[Comment]
		, ISNULL((LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))), '') AS [USER_NAME_CODE]
		, ISNULL([Claim].[ClaimProcessEDIFile].[ClaimProcessEDIFileID], 0) AS [ClaimProcessEDIFileID]
		, ISNULL([EDI].[EDIFile].[X12FileRelPath], '') AS [X12FileRelPath]
		, ISNULL([EDI].[EDIFile].[RefFileRelPath], '') AS [RefFileRelPath]
		, ISNULL([EDI].[EDIFile].[CreatedOn], '1900-01-01') AS [CreatedOn]		
		
	FROM
		[Claim].[ClaimProcess]
	LEFT JOIN
		[Claim].[ClaimProcessEDIFile]
	ON
		[Claim].[ClaimProcess].[ClaimProcessID] = [Claim].[ClaimProcessEDIFile].[ClaimProcessID]
	AND
		[Claim].[ClaimProcessEDIFile].[IsActive] = 1
	LEFT JOIN
		[EDI].[EDIFile]
	ON
		[Claim].[ClaimProcessEDIFile].[EDIFileID] = [EDI].[EDIFile].[EDIFileID]
	AND
		[EDI].[EDIFile].[IsActive] = 1
	LEFT JOIN
		[EDI].[EDIReceiver]
	ON
		[EDI].[EDIFile].[EDIReceiverID] = [EDI].[EDIReceiver].[EDIReceiverID]
	AND
		[EDI].[EDIReceiver].[IsActive] = 1
	LEFT JOIN
		[User].[User]
	ON
		[User].[User].[UserID] = [Claim].[ClaimProcess].[AssignedTo]
	AND
		[User].[User].[IsActive] = 1
	WHERE
		[Claim].[ClaimProcess].[PatientVisitID] = @PatientVisitID
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	ORDER BY 
		[Claim].[ClaimProcess].[ClaimProcessID]
	ASC;
		
	-- EXEC [Claim].[usp_GetByPatientVisitID_ClaimProcess] 7219
	-- EXEC [Claim].[usp_GetByPatientVisitID_ClaimProcess] 1, 1
	-- EXEC [Claim].[usp_GetByPatientVisitID_ClaimProcess] 1, 0
END
GO
