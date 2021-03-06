USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Claim].[usp_GetCommentByID_ClaimProcess]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Claim].[usp_GetCommentByID_ClaimProcess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Claim].[usp_GetCommentByID_ClaimProcess] 
	@PatientVisitID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] BIGINT IDENTITY (1, 1) NOT NULL
		, [USER_NAME_CODE] NVARCHAR(400) NOT NULL
		, [USER_COMMENTS] NVARCHAR(4000) NOT NULL
	);
	
	--
	
	INSERT INTO
		@TBL_ANS
	SELECT
		((LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL([User].[User].[MiddleName], '')))) + ' [' +[User].[User].[UserName] + ']') AS [USER_NAME_CODE] 
		, [Patient].[PatientVisit].[Comment] AS [USER_COMMENTS]
	FROM
		[Patient].[PatientVisit]
	INNER JOIN 
		[User].[User]
	ON
		[Patient].[PatientVisit].[LastModifiedBy] = [User].[User].[UserID]
	WHERE
		@PatientVisitID = [Patient].[PatientVisit].[PatientVisitID]
	AND
		[Patient].[PatientVisit].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientVisit].[IsActive] ELSE @IsActive END
	AND
		[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END
	ORDER BY
		[Patient].[PatientVisit].[PatientVisitID]
	ASC;
	
	--
	
	INSERT INTO
		@TBL_ANS
	SELECT
		((LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL([User].[User].[MiddleName], '')))) + ' [' +[User].[User].[UserName] + ']') AS [USER_NAME_CODE] 
		, [Claim].[ClaimProcess].[Comment] AS [USER_COMMENTS]
	FROM
		[Claim].[ClaimProcess]
	INNER JOIN 
		[User].[User]
	ON
		[Claim].[ClaimProcess].[AssignedTo] = [User].[User].[UserID]
	WHERE
		[Claim].[ClaimProcess].[AssignedTo] IS NOT NULL
	AND
		@PatientVisitID = [Claim].[ClaimProcess].[PatientVisitID]
	AND
		[Claim].[ClaimProcess].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimProcess].[IsActive] ELSE @IsActive END
	AND
		[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END
	ORDER BY
		[Claim].[ClaimProcess].[ClaimProcessID]
	DESC;

	SELECT DISTINCT [USER_COMMENTS],[USER_NAME_CODE] FROM @TBL_ANS WHERE [USER_COMMENTS] NOT LIKE 'Status changed by automated job services%' ORDER BY 2;

	-- EXEC [Claim].[usp_GetCommentByID_ClaimProcess] 22743
	-- EXEC [Claim].[usp_GetCommentByID_ClaimProcess] 1, 1
	-- EXEC [Claim].[usp_GetCommentByID_ClaimProcess] 1, 0
END
GO
