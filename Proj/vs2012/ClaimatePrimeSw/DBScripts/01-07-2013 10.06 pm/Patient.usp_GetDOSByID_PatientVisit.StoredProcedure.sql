USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetDOSByID_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetDOSByID_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Patient].[usp_GetDOSByID_PatientVisit] 
	@PatientVisitID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [DOS] DATE NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Patient].[PatientVisit].[DOS]
	FROM
		[Patient].[PatientVisit]
	WHERE
		@PatientVisitID = [Patient].[PatientVisit].[PatientVisitID]
	AND
		[Patient].[PatientVisit].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientVisit].[IsActive] ELSE @IsActive END;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [Patient].[usp_GetByPkIdChartNumber_Patient] 8, NULL
	-- EXEC [Patient].[usp_GetByPkId_Patient] 1, 1
	-- EXEC [Patient].[usp_GetByPkId_Patient] 1, 0
END
GO
