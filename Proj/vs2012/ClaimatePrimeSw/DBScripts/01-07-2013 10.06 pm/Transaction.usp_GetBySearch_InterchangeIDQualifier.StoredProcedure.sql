USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_InterchangeIDQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetBySearch_InterchangeIDQualifier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Transaction].[usp_GetBySearch_InterchangeIDQualifier]
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
		[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'InterchangeIDQualifierName' AND @OrderByDirection = 'A' THEN [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] END ASC,
				CASE WHEN @orderByField = 'InterchangeIDQualifierName' AND @orderByDirection = 'D' THEN [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] END DESC,
				
				CASE WHEN @OrderByField = 'InterchangeIDQualifierCode' AND @OrderByDirection = 'A' THEN [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] END ASC,
				CASE WHEN @orderByField = 'InterchangeIDQualifierCode' AND @orderByDirection = 'D' THEN [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[InterchangeIDQualifier].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[InterchangeIDQualifier].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[InterchangeIDQualifier]
	WHERE
		[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[InterchangeIDQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[InterchangeIDQualifier].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[InterchangeIDQualifier].[InterchangeIDQualifierID], [InterchangeIDQualifier].[InterchangeIDQualifierCode], [InterchangeIDQualifier].[InterchangeIDQualifierName], [InterchangeIDQualifier].[IsActive]
	FROM
		[InterchangeIDQualifier] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [InterchangeIDQualifier].[InterchangeIDQualifierID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_InterchangeIDQualifier] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_InterchangeIDQualifier] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
