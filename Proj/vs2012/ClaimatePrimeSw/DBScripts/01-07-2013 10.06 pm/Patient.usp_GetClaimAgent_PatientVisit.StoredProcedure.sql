USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetClaimAgent_PatientVisit]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetClaimAgent_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetClaimAgent_PatientVisit]
    @ClinicID INT
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
				
				CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitComplexity] END ASC,
				CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitComplexity] END DESC,
				
				CASE WHEN @OrderByField = 'TargetBAUserID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[TargetBAUserID] END ASC,
				CASE WHEN @orderByField = 'TargetBAUserID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[TargetBAUserID] END DESC,
				
				CASE WHEN @OrderByField = 'TargetQAUserID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[TargetQAUserID] END ASC,
				CASE WHEN @orderByField = 'TargetQAUserID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[TargetQAUserID] END DESC,
			    
			    CASE WHEN @OrderByField = 'TargetEAUserID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[TargetEAUserID] END ASC,
				CASE WHEN @orderByField = 'TargetEAUserID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[TargetEAUserID] END DESC,

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
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] ))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE '%' + @SearchName + '%' 
		)
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;	
	
	DECLARE @TBL_RES TABLE
	(
		[PAT_NAME] NVARCHAR(500) NOT NULL
		, [CHART_NUMBER] NVARCHAR(20) NOT NULL
		, [DOS] DATE NOT NULL
		, [PATIENT_VISIT_ID] BIGINT NOT NULL
		, [TARGET_BA_USER] NVARCHAR(400) NULL
		, [TARGET_BA_USERID] INT NULL
		, [TARGET_QA_USER] NVARCHAR(400) NULL
		, [TARGET_QA_USERID] INT NULL
		, [TARGET_EA_USER] NVARCHAR(400) NULL
		, [TARGET_EA_USERID] INT NULL
		, [IS_ACTIVE] BIT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT		
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))
		,ChartNumber
		,DOS
		,PatientVisitID
		,NULL
		,TargetBAUserID
		,NULL
		,TargetQAUserID
		,NULL
		,TargetEAUserID
		,PatientVisit.IsActive
	FROM
		[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [PatientVisit].[PatientVisitID]
		INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[PatientVisit].[PatientID] = [Patient].[Patient].[PatientID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	UPDATE
		T
	SET
		[T].[TARGET_BA_USER] = [U].[LastName] + ' ' + [U].[FirstName] + ISNULL((' ' + [U].[MiddleName]), '') + ' [' + [U].[UserName] + ']'
	FROM
		@TBL_RES T
	INNER JOIN
		[User].[User] U
	ON
		[U].[UserID] = [T].[TARGET_BA_USERID]
	WHERE
		[T].[TARGET_BA_USERID] IS NOT NULL;
		
	UPDATE
		T
	SET
		[T].[TARGET_QA_USER] = [U].[LastName] + ' ' + [U].[FirstName] + ISNULL((' ' + [U].[MiddleName]), '') + ' [' + [U].[UserName] + ']'
	FROM
		@TBL_RES T
	INNER JOIN
		[User].[User] U
	ON
		[U].[UserID] = [T].[TARGET_QA_USERID]
	WHERE
		[T].[TARGET_QA_USERID] IS NOT NULL;
		
	UPDATE
		T
	SET
		[T].[TARGET_EA_USER] = [U].[LastName] + ' ' + [U].[FirstName] + ISNULL((' ' + [U].[MiddleName]), '') + ' [' + [U].[UserName] + ']'
	FROM
		@TBL_RES T
	INNER JOIN
		[User].[User] U
	ON
		[U].[UserID] = [T].[TARGET_EA_USERID]
	WHERE
		[T].[TARGET_EA_USERID] IS NOT NULL;
	
	SELECT * FROM @TBL_RES;	
	
	-- EXEC [Patient].[usp_GetClaimAgent_PatientVisit] @ClinicID = '2'
	-- EXEC [Patient].[usp_GetClaimAgent_PatientVisit] @SearchName  = '', @StartBy = 'c', @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D',@ClinicID=2
END
GO
