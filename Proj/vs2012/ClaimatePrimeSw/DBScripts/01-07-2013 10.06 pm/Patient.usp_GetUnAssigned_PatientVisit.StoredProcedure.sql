USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetUnAssigned_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetUnAssigned_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetUnAssigned_PatientVisit]
	  @ClinicID INT
	, @StatusIDs NVARCHAR(100)
	, @SearchName NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @AssignedTo INT = NULL
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'	
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SELECT @SearchName = '';
	END
	
	DECLARE @PatientVisitID BIGINT;
	BEGIN TRY
		SELECT @PatientVisitID = CAST (@SearchName AS BIGINT);
	END TRY
	BEGIN CATCH
		SELECT @PatientVisitID = 0;
	END CATCH
	
	IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = CAST('1900-01-01' AS DATE);
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = DATEADD(MONTH, 1, GETDATE());
	END
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		, ROW_NUMBER() OVER (
			ORDER BY
			
				CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
							
				CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
								
				CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
				CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]	
	WHERE
		
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))) LIKE '%' + @SearchName + '%' 
		OR
			[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
		)
	AND
		(
			[Patient].[PatientVisit].[AssignedTo] = @AssignedTo
		OR
			@AssignedTo IS NULL
		)
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
	DECLARE @TBL_ANS TABLE
	(
		 [PatientVisitID] BIGINT NOT NULL
		, [PatName] NVARCHAR(500) NOT NULL
		, [PatChartNumber] NVARCHAR(20) NOT NULL
		, [DOS] DATE NOT NULL
		, [PatientVisitComplexity] TINYINT NOT NULL
		, [AssignToMe] BIT NOT NULL
	);
	
	INSERT INTO
		@TBL_ANS
	SELECT
		 [Patient].[PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PatName]
		, [Patient].[Patient].[ChartNumber] AS [PatChartNumber] 
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
		, CAST('1' AS BIT) AS [AssignToMe]
	FROM
		@SEARCH_TMP
	INNER JOIN
		[Patient].[PatientVisit]
	ON
		[PK_ID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]
	ORDER BY
		[ID]
	ASC;
	
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Patient].[usp_GetUnAssigned_PatientVisit] @ClinicID = 1, @SearchName='RITBE000', @StatusIDs = '1, 2', @DateFrom = '3/1/2000 12:00:00 AM' , @DateTo = '3/2/2014 12:00:00 AM'
END
GO
