USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetNameByPatientVisitID_Patient]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetNameByPatientVisitID_Patient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Patient].[usp_GetNameByPatientVisitID_Patient] 
	@PatientVisitID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[PatientID] INT NOT NULL 
		, [NAME_CODE] NVARCHAR(500) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Patient].[PatientVisit].[PatientID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], '') + ' [' + [Patient].[Patient].[ChartNumber] + ']'))) AS [NAME_CODE]
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		@PatientVisitID = [Patient].[PatientVisit].[PatientVisitID]
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END
	AND
		[Patient].[PatientVisit].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientVisit].[IsActive] ELSE @IsActive END;

	SELECT * FROM @TBL_RES;
	
	-- EXEC [Patient].[usp_GetNameByPatientVisitID_Patient] 81, NULL

END
GO
