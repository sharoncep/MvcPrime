USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientDocument]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetBySearch_PatientDocument]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetBySearch_PatientDocument] 
	 @SearchName NVARCHAR(350) = NULL
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
		SELECT @StartBy = '';
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
		[Patient].[PatientDocument].[PatientDocumentID]
		, ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN @OrderByField = 'Name' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'Name' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END DESC,
						
				CASE WHEN @OrderByField = 'ChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'ChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
								
				CASE WHEN @OrderByField = 'DocumentCategoryName' AND @OrderByDirection = 'A' THEN [MasterData].[DocumentCategory].[DocumentCategoryName] END ASC,
				CASE WHEN @orderByField = 'DocumentCategoryName' AND @orderByDirection = 'D' THEN [MasterData].[DocumentCategory].[DocumentCategoryName] END DESC,
								

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientDocument].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientDocument].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Patient].[PatientDocument]
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[PatientDocument].[PatientID] = [Patient].[Patient].[PatientID]
		
	INNER JOIN
		[MasterData].[DocumentCategory]
	ON 
		[Patient].[PatientDocument].[DocumentCategoryID] = [MasterData].[DocumentCategory].[DocumentCategoryID]
		
	WHERE
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] ))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE '%' + @SearchName + '%' 
		)
	AND
		[Patient].[PatientDocument].[ServiceOrFromDate] BETWEEN @DateFrom AND @DateTo
	AND
		[Patient].[PatientDocument].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientDocument].[IsActive] ELSE @IsActive END
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	

	DECLARE @TBL_RES TABLE
	(
		[PatientDocumentID] INT NOT NULL
		, [Name] NVARCHAR(500) NOT NULL
		, [DocumentCategoryName] NVARCHAR(155) NOT NULL
		, [DocumentRelPath]NVARCHAR(350)  NULL
		, [ChartNumber] NVARCHAR(20) NOT NULL
		, [IsActive] BIT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Patient].[PatientDocument].[PatientDocumentID]
		,(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		,[DocumentCategory].[DocumentCategoryName] + ' ['+ [DocumentCategory].[DocumentCategoryCode] + ']'
		,[Patient].[PatientDocument].[DocumentRelPath]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[PatientDocument].[IsActive]
	FROM
		[Patient].[PatientDocument] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] =[Patient].[PatientDocument].[PatientDocumentID]
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[PatientDocument].[PatientID] = [Patient].[Patient].[PatientID]
		INNER JOIN
		[MasterData].[DocumentCategory]
	ON 
		[Patient].[PatientDocument].[DocumentCategoryID] = [MasterData].[DocumentCategory].[DocumentCategoryID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	SELECT * FROM @TBL_RES;
	
	-- EXEC [Patient].[usp_GetBySearch_PatientDocument] @StartBy=' '
	-- EXEC [Patient].[usp_GetBySearch_PatientDocument] @ClinicTypeID = 2, @SearchName  = NULL, @StartBy = NULL, @PatientID = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
