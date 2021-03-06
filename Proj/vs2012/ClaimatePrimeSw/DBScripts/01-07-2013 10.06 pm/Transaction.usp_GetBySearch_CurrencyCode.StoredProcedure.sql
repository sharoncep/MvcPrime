USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_CurrencyCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetBySearch_CurrencyCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Transaction].[usp_GetBySearch_CurrencyCode]
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
		[Transaction].[CurrencyCode].[CurrencyCodeID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'CurrencyCodeName' AND @OrderByDirection = 'A' THEN [Transaction].[CurrencyCode].[CurrencyCodeName] END ASC,
				CASE WHEN @orderByField = 'CurrencyCodeName' AND @orderByDirection = 'D' THEN [Transaction].[CurrencyCode].[CurrencyCodeName] END DESC,
				
				CASE WHEN @OrderByField = 'CurrencyCodeCode' AND @OrderByDirection = 'A' THEN [Transaction].[CurrencyCode].[CurrencyCodeCode] END ASC,
				CASE WHEN @orderByField = 'CurrencyCodeCode' AND @orderByDirection = 'D' THEN [Transaction].[CurrencyCode].[CurrencyCodeCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[CurrencyCode].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[CurrencyCode].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[CurrencyCode]
	WHERE
		[Transaction].[CurrencyCode].[CurrencyCodeName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[CurrencyCode].[CurrencyCodeName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[CurrencyCode].[CurrencyCodeCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[CurrencyCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[CurrencyCode].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[CurrencyCode].[CurrencyCodeID], [CurrencyCode].[CurrencyCodeCode], [CurrencyCode].[CurrencyCodeName], [CurrencyCode].[IsActive]
	FROM
		[CurrencyCode] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [CurrencyCode].[CurrencyCodeID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_CurrencyCode] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_CurrencyCode] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
