USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_EntityIdentifierCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetBySearch_EntityIdentifierCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Transaction].[usp_GetBySearch_EntityIdentifierCode]
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
		[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'EntityIdentifierCodeName' AND @OrderByDirection = 'A' THEN [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeName] END ASC,
				CASE WHEN @orderByField = 'EntityIdentifierCodeName' AND @orderByDirection = 'D' THEN [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeName] END DESC,
				
				CASE WHEN @OrderByField = 'EntityIdentifierCodeCode' AND @OrderByDirection = 'A' THEN [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeCode] END ASC,
				CASE WHEN @orderByField = 'EntityIdentifierCodeCode' AND @orderByDirection = 'D' THEN [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[EntityIdentifierCode].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[EntityIdentifierCode].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[EntityIdentifierCode]
	WHERE
		[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[EntityIdentifierCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[EntityIdentifierCode].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[EntityIdentifierCode].[EntityIdentifierCodeID], [EntityIdentifierCode].[EntityIdentifierCodeCode], [EntityIdentifierCode].[EntityIdentifierCodeName], [EntityIdentifierCode].[IsActive]
	FROM
		[EntityIdentifierCode] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [EntityIdentifierCode].[EntityIdentifierCodeID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_EntityIdentifierCode] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_EntityIdentifierCode] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
