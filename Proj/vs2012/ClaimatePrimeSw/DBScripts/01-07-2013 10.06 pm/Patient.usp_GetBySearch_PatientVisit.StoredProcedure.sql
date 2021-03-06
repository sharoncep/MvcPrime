USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetBySearch_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetBySearch_PatientVisit]
	@StatusFrom TINYINT
	, @StatusTo TINYINT
	, @UserID INT
	, @ClinicID INT
	, @PatientID BIGINT = NULL
	, @SearchName NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
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
	
	IF @StartBy IS NULL
	BEGIN
		SET @StartBy = '';
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
			
				CASE WHEN @OrderByField = 'Name' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'Name' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END DESC,
						
				CASE WHEN @OrderByField = 'ChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'ChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
								
				CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
				CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitComplexity] END ASC,
				CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitComplexity] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[PatientVisit].[PatientID] = [Patient].[Patient].[PatientID]
	WHERE
		[Patient].[PatientID] = CASE WHEN @PatientID IS NULL THEN [PatientVisit].[PatientID] ELSE @PatientID END
	AND
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))) LIKE '%' + @SearchName + '%' 
		OR
			[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
		)
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;	
	
	SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
		, [Patient].[PatientVisit].[TargetBAUserID]
		, [Patient].[PatientVisit].[TargetQAUserID]
		, [Patient].[PatientVisit].[TargetEAUserID]
		, [Patient].[PatientVisit].[IsActive]
		, CAST((CASE WHEN (([Patient].[PatientVisit].[ClaimStatusID] BETWEEN @StatusFrom AND @StatusTo)) THEN '1' ELSE '0' END) AS BIT) AS [CAN_UN_BLOCK]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[Patient].[PatientID]=[Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] =[Patient].[PatientVisit].[PatientVisitID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] @StatusFrom = '1', @StatusTo = '9' , @UserID = '101', @ClinicID = '1'
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] @StatusFrom = '1', @StatusTo = '9' , @UserID = '101', @ClinicID = '1', @SearchName  = '23197'
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] @StatusFrom = '1', @StatusTo = '9' , @UserID = '101', @ClinicID = '1', @SearchName  = 'RITBE000'
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] @StatusFrom = '1', @StatusTo = '9' , @UserID = '101', @ClinicID = '1', @SearchName  = '', @StartBy = 'A', @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
