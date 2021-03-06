USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetNameByID_Patient]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetNameByID_Patient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select the particular record

CREATE PROCEDURE [Patient].[usp_GetNameByID_Patient] 
	@PatientID	BIGINT
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
		[Patient].[Patient].[PatientID]
		, ((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], '')))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') AS [NAME_CODE]
	FROM
		[Patient].[Patient]
	WHERE
		@PatientID = [Patient].[Patient].[PatientID]
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END;

	SELECT * FROM @TBL_RES;
	-- EXEC [Patient].[usp_GetByPkIdChartNumber_Patient] 8, NULL
	-- EXEC [Patient].[usp_GetByPkId_Patient] 1, 1
	-- EXEC [Patient].[usp_GetByPkId_Patient] 1, 0
END
GO
