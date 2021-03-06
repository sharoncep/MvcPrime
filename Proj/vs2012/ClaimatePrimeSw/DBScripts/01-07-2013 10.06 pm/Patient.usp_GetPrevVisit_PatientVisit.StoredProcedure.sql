USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetPrevVisit_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetPrevVisit_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetPrevVisit_PatientVisit]
	@PatientVisitID BIGINT
	, @PatientID BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		,[Patient].[PatientVisit].[DOS] 
		,[Patient].[PatientVisit].[ClaimStatusID]
		,[Patient].[PatientVisit].[PatientVisitComplexity]
		,CASE WHEN [Patient].[PatientVisit].[AssignedTo] IS NULL THEN NULL ELSE (SELECT LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], ''))) FROM [User].[User] WHERE [User].[User].[UserID] = [Patient].[PatientVisit].[AssignedTo])END AS [AssignedTo]
		,CASE WHEN [Patient].[PatientVisit].[TargetBAUserID] IS NULL THEN NULL ELSE (SELECT LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], ''))) FROM [User].[User] WHERE [User].[User].[UserID] = [Patient].[PatientVisit].[TargetBAUserID])END AS [TargetBAUserID]
		,CASE WHEN [Patient].[PatientVisit].[TargetQAUserID] IS NULL THEN NULL ELSE (SELECT LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], ''))) FROM [User].[User] WHERE [User].[User].[UserID] = [Patient].[PatientVisit].[TargetQAUserID])END AS [TargetQAUserID]
		,CASE WHEN [Patient].[PatientVisit].[TargetEAUserID] IS NULL THEN NULL ELSE (SELECT LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], ''))) FROM [User].[User] WHERE [User].[User].[UserID] = [Patient].[PatientVisit].[TargetEAUserID])END AS [TargetEAUserID]
	FROM
		[Patient].[PatientVisit]
	WHERE
		[Patient].[PatientVisit].[PatientID] = @PatientID
	AND
		[Patient].[PatientVisit].[PatientVisitID] <> @PatientVisitID
	ORDER BY 
		[Patient].[PatientVisit].[DOS]
	DESC
		
	-- EXEC [Patient].[usp_GetPrevVisit_PatientVisit] 11522 , 11522
END
GO
