USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Audit].[usp_GetBySearch_WebCulture]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Audit].[usp_GetBySearch_WebCulture]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Audit].[usp_GetBySearch_WebCulture]
	@SearchName NVARCHAR(150) = NULL
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
		, [PK_ID] NVARCHAR(12) NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT
		[Audit].[WebCulture].[KeyName]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'EnglishName' AND @OrderByDirection = 'A' THEN [Audit].[WebCulture].[EnglishName] END ASC,
				CASE WHEN @orderByField = 'EnglishName' AND @orderByDirection = 'D' THEN [Audit].[WebCulture].[EnglishName] END DESC,
						
				CASE WHEN @OrderByField = 'NativeName' AND @OrderByDirection = 'A' THEN [Audit].[WebCulture].[NativeName] END ASC,
				CASE WHEN @orderByField = 'NativeName' AND @orderByDirection = 'D' THEN [Audit].[WebCulture].[NativeName] END DESC
				
			) AS ROW_NUM
	FROM
		[Audit].[WebCulture]
	WHERE
		[Audit].[WebCulture].[EnglishName] LIKE @StartBy + '%' 
	AND
	(
		[Audit].[WebCulture].[EnglishName] LIKE '%' + @SearchName + '%' 
	
	)
	
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[WebCulture].[KeyName], [WebCulture].[EnglishName], [WebCulture].[NativeName], [WebCulture].[IsActive]
	FROM
		[WebCulture] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [WebCulture].[KeyName]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Audit].[usp_GetBySearch_WebCulture] @SearchName  = '36'
	-- EXEC [Audit].[usp_GetBySearch_WebCulture] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
