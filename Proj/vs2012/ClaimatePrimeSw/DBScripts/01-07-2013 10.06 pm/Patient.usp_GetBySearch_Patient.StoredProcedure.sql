USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_Patient]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Patient].[usp_GetBySearch_Patient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetBySearch_Patient]
	@ClinicID INT
	, @SearchName NVARCHAR(150) = NULL
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
		SET @SearchName = '';
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
		[Patient].[Patient].[PatientID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'Name' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'Name' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END DESC,
				
				CASE WHEN @OrderByField = 'MedicareID' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[MedicareID] END ASC,
				CASE WHEN @orderByField = 'MedicareID' AND @orderByDirection = 'D' THEN [Patient].[Patient].[MedicareID] END DESC,
				
				CASE WHEN @OrderByField = 'ChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'ChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[Patient].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Patient].[Patient]
	WHERE
	
	(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
	
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] ))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE '%' + @SearchName + '%' 
		)
	AND
		[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		, [Patient].[PatientID]
		, [Patient].[ChartNumber]
		, [Patient].[MedicareID]
		, [Patient].[IsActive] 
	FROM
		[Patient] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Patient].[PatientID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Patient].[usp_GetBySearch_Patient] @ClinicID=2
	-- EXEC [Patient].[usp_GetBySearch_Patient] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
